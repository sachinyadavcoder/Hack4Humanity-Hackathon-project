import Patient from '../models/Patient.js'
import Appointment from '../models/Appointment.js'

const MONTH_LABELS = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']

function lastSixMonthsBuckets() {
  const buckets = []
  const now = new Date()
  for (let i = 5; i >= 0; i--) {
    const d = new Date(now.getFullYear(), now.getMonth() - i, 1)
    buckets.push({ year: d.getFullYear(), month: d.getMonth(), label: MONTH_LABELS[d.getMonth()] })
  }
  return buckets
}

// GET /dashboard
export async function getDashboardStats(req, res) {
  const [totalPatients, normalRisk, mediumRisk, highRisk] = await Promise.all([
    Patient.countDocuments(),
    Patient.countDocuments({ risk: 'Normal' }),
    Patient.countDocuments({ risk: 'Medium' }),
    Patient.countDocuments({ risk: 'High' }),
  ])

  const startOfToday = new Date()
  startOfToday.setHours(0, 0, 0, 0)
  const endOfToday = new Date()
  endOfToday.setHours(23, 59, 59, 999)

  const todaysAppointments = await Appointment.countDocuments({
    date: { $gte: startOfToday, $lte: endOfToday },
    status: 'Scheduled',
  })

  // Pending follow-ups: patients whose last visit was 21+ days ago (simple heuristic)
  const followUpCutoff = new Date()
  followUpCutoff.setDate(followUpCutoff.getDate() - 21)
  const pendingFollowUps = await Patient.countDocuments({ lastVisit: { $lte: followUpCutoff } })

  const recentPatients = await Patient.find()
    .sort({ lastVisit: -1 })
    .limit(5)
    .select('patientId name risk riskScore village lastVisit')

  // Chart data, aggregated from real patient records over the last 6 months.
  const buckets = lastSixMonthsBuckets()
  const allPatients = await Patient.find().select('createdAt risk')

  const monthlyRegistrations = buckets.map(({ year, month, label }) => ({
    month: label,
    registrations: allPatients.filter((p) => {
      const d = new Date(p.createdAt)
      return d.getFullYear() === year && d.getMonth() === month
    }).length,
  }))

  const highRiskTrend = buckets.map(({ year, month, label }) => ({
    month: label,
    highRisk: allPatients.filter((p) => {
      const d = new Date(p.createdAt)
      return d.getFullYear() === year && d.getMonth() === month && p.risk === 'High'
    }).length,
  }))

  return res.status(200).json({
    totalPatients,
    normalRisk,
    mediumRisk,
    highRisk,
    todaysAppointments,
    pendingFollowUps,
    recentPatients,
    monthlyRegistrations,
    highRiskTrend,
  })
}
