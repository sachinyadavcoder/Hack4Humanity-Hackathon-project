import Patient from '../models/Patient.js'

// GET /patients
// Query params: search, patientId, village, risk, trimester, sortBy, page, limit
export async function getPatients(req, res) {
  const { search, patientId, village, risk, trimester, sortBy, page = 1, limit = 50 } = req.query

  const filter = {}

  if (search) {
    filter.$or = [
      { name: { $regex: search, $options: 'i' } },
      { patientId: { $regex: search, $options: 'i' } },
    ]
  }

  if (patientId) filter.patientId = { $regex: patientId, $options: 'i' }
  if (village && village !== 'All') filter.village = village
  if (risk && risk !== 'All') filter.risk = risk
  if (trimester && trimester !== 'All') filter.trimester = Number(trimester)

  const sortMap = {
    latest: { lastVisit: -1 },
    oldest: { lastVisit: 1 },
  }
  const sort = sortMap[sortBy] || sortMap.latest

  const pageNum = Math.max(1, Number(page))
  const limitNum = Math.max(1, Number(limit))

  const [patients, total] = await Promise.all([
    Patient.find(filter)
      .sort(sort)
      .skip((pageNum - 1) * limitNum)
      .limit(limitNum),
    Patient.countDocuments(filter),
  ])

  return res.status(200).json({
    patients,
    total,
    page: pageNum,
    totalPages: Math.ceil(total / limitNum),
  })
}

// GET /patients/high-risk
export async function getHighRiskPatients(req, res) {
  const patients = await Patient.find({ risk: 'High' }).sort({ riskScore: -1 })
  return res.status(200).json(patients)
}

// GET /patients/:id
// :id can be either the Mongo _id or the human-readable patientId (PT-0001)
export async function getPatientById(req, res) {
  const { id } = req.params

  const query = id.match(/^[0-9a-fA-F]{24}$/) ? { _id: id } : { patientId: id }
  const patient = await Patient.findOne(query)

  if (!patient) {
    return res.status(404).json({ message: 'Patient not found.' })
  }

  return res.status(200).json(patient)
}
