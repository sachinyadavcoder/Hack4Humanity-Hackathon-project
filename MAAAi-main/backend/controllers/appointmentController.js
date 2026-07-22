import Appointment from '../models/Appointment.js'

// GET /appointments
export async function getAllAppointments(req, res) {
  const appointments = await Appointment.find().sort({ date: 1 }).populate('patient', 'patientId name')
  return res.status(200).json(appointments)
}

// GET /appointments/today
export async function getTodaysAppointments(req, res) {
  const startOfToday = new Date()
  startOfToday.setHours(0, 0, 0, 0)
  const endOfToday = new Date()
  endOfToday.setHours(23, 59, 59, 999)

  const appointments = await Appointment.find({
    date: { $gte: startOfToday, $lte: endOfToday },
  })
    .sort({ time: 1 })
    .populate('patient', 'patientId name')

  return res.status(200).json(appointments)
}

// GET /appointments/upcoming
export async function getUpcomingAppointments(req, res) {
  const startOfTomorrow = new Date()
  startOfTomorrow.setDate(startOfTomorrow.getDate() + 1)
  startOfTomorrow.setHours(0, 0, 0, 0)

  const appointments = await Appointment.find({
    date: { $gte: startOfTomorrow },
    status: 'Scheduled',
  })
    .sort({ date: 1 })
    .populate('patient', 'patientId name')

  return res.status(200).json(appointments)
}

// GET /appointments/:id
export async function getAppointmentById(req, res) {
  const appointment = await Appointment.findById(req.params.id).populate('patient', 'patientId name')
  if (!appointment) {
    return res.status(404).json({ message: 'Appointment not found.' })
  }
  return res.status(200).json(appointment)
}

// Intentionally NOT implemented, per spec:
// createAppointment, updateAppointment, deleteAppointment
// Appointment scheduling belongs to the Receptionist Portal.
