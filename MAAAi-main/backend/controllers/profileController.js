import bcrypt from 'bcryptjs'
import Doctor from '../models/Doctor.js'
import { isStrongEnoughPassword } from '../utils/validators.js'

// GET /profile
export async function getProfile(req, res) {
  const doctor = req.doctor
  return res.status(200).json({
    id: doctor._id,
    name: doctor.name,
    email: doctor.email,
    hospital: doctor.hospital,
    specialization: doctor.specialization,
    registrationNumber: doctor.registrationNumber,
    contact: doctor.phone,
    language: doctor.language,
  })
}

// PUT /profile
export async function updateProfile(req, res) {
  const { name, hospital, specialization, contact, language } = req.body
  const doctor = req.doctor

  if (name !== undefined) doctor.name = name
  if (hospital !== undefined) doctor.hospital = hospital
  if (specialization !== undefined) doctor.specialization = specialization
  if (contact !== undefined) doctor.phone = contact
  if (language !== undefined) doctor.language = language

  await doctor.save()

  return res.status(200).json({
    id: doctor._id,
    name: doctor.name,
    email: doctor.email,
    hospital: doctor.hospital,
    specialization: doctor.specialization,
    registrationNumber: doctor.registrationNumber,
    contact: doctor.phone,
    language: doctor.language,
  })
}

// PUT /profile/change-password
export async function changePassword(req, res) {
  const { currentPassword, newPassword } = req.body

  if (!currentPassword || !newPassword) {
    return res.status(400).json({ message: 'Current and new password are required.' })
  }

  if (!isStrongEnoughPassword(newPassword)) {
    return res.status(400).json({ message: 'New password must be at least 6 characters.' })
  }

  const doctor = await Doctor.findById(req.doctor._id).select('+password')

  const isMatch = await bcrypt.compare(currentPassword, doctor.password)
  if (!isMatch) {
    return res.status(401).json({ message: 'Current password is incorrect.' })
  }

  doctor.password = await bcrypt.hash(newPassword, 10)
  await doctor.save()

  return res.status(200).json({ message: 'Password changed successfully.' })
}
