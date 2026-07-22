import Patient from '../models/Patient.js'
import DoctorRecommendation from '../models/DoctorRecommendation.js'

// GET /patients/:id/recommendations
export async function getRecommendations(req, res) {
  const { id } = req.params
  const query = id.match(/^[0-9a-fA-F]{24}$/) ? { _id: id } : { patientId: id }
  const patient = await Patient.findOne(query).select('_id')

  if (!patient) {
    return res.status(404).json({ message: 'Patient not found.' })
  }

  const recommendations = await DoctorRecommendation.find({ patient: patient._id }).sort({ createdAt: -1 })
  return res.status(200).json(recommendations)
}

// POST /patients/:id/recommendations
export async function addRecommendation(req, res) {
  const { id } = req.params
  const { medicines, advice, diet, bedRest, referral } = req.body

  if (!advice || !advice.trim()) {
    return res.status(400).json({ message: 'Advice is required.' })
  }

  const query = id.match(/^[0-9a-fA-F]{24}$/) ? { _id: id } : { patientId: id }
  const patient = await Patient.findOne(query).select('_id')

  if (!patient) {
    return res.status(404).json({ message: 'Patient not found.' })
  }

  const recommendation = await DoctorRecommendation.create({
    patient: patient._id,
    doctor: req.doctor._id,
    doctorName: req.doctor.name,
    medicines,
    advice,
    diet,
    bedRest: !!bedRest,
    referral,
  })

  return res.status(201).json(recommendation)
}

// PUT /recommendations/:recId
export async function updateRecommendation(req, res) {
  const { recId } = req.params
  const { medicines, advice, diet, bedRest, referral } = req.body

  const recommendation = await DoctorRecommendation.findById(recId)
  if (!recommendation) {
    return res.status(404).json({ message: 'Recommendation not found.' })
  }

  if (String(recommendation.doctor) !== String(req.doctor._id)) {
    return res.status(403).json({ message: 'You can only edit your own recommendations.' })
  }

  if (medicines !== undefined) recommendation.medicines = medicines
  if (advice !== undefined) recommendation.advice = advice
  if (diet !== undefined) recommendation.diet = diet
  if (bedRest !== undefined) recommendation.bedRest = bedRest
  if (referral !== undefined) recommendation.referral = referral

  await recommendation.save()
  return res.status(200).json(recommendation)
}

// DELETE /recommendations/:recId
export async function deleteRecommendation(req, res) {
  const { recId } = req.params

  const recommendation = await DoctorRecommendation.findById(recId)
  if (!recommendation) {
    return res.status(404).json({ message: 'Recommendation not found.' })
  }

  if (String(recommendation.doctor) !== String(req.doctor._id)) {
    return res.status(403).json({ message: 'You can only delete your own recommendations.' })
  }

  await recommendation.deleteOne()
  return res.status(200).json({ message: 'Recommendation deleted.' })
}
