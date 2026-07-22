import bcrypt from 'bcryptjs'
import Doctor from '../models/Doctor.js'
import generateToken from '../utils/generateToken.js'
import { generateOtp, getOtpExpiry, isOtpExpired, canResendOtp, secondsUntilResendAllowed } from '../utils/otp.js'
import { isInstitutionalEmail, isValidEmailFormat, isStrongEnoughPassword, INSTITUTIONAL_EMAIL_ERROR } from '../utils/validators.js'
import { sendOtpEmail } from '../services/emailService.js'

// POST /auth/register
export async function registerDoctor(req, res) {
  const { name, email, password, confirmPassword, hospital, specialization, registrationNumber, phone } = req.body

  if (!name || !email || !password || !hospital || !specialization || !registrationNumber || !phone) {
    return res.status(400).json({ message: 'All fields are required.' })
  }

  if (!isValidEmailFormat(email)) {
    return res.status(400).json({ message: 'Enter a valid email address.' })
  }

  if (!isInstitutionalEmail(email)) {
    return res.status(400).json({ message: INSTITUTIONAL_EMAIL_ERROR })
  }

  if (!isStrongEnoughPassword(password)) {
    return res.status(400).json({ message: 'Password must be at least 6 characters.' })
  }

  if (confirmPassword !== undefined && confirmPassword !== password) {
    return res.status(400).json({ message: 'Passwords do not match.' })
  }

  const existing = await Doctor.findOne({ email: email.toLowerCase() })
  if (existing) {
    return res.status(409).json({ message: 'An account with this email already exists.' })
  }

  const hashedPassword = await bcrypt.hash(password, 10)

  const doctor = await Doctor.create({
    name,
    email: email.toLowerCase(),
    password: hashedPassword,
    hospital,
    specialization,
    registrationNumber,
    phone,
    isEmailVerified: false,
  })

  return res.status(201).json({
    message: 'Registration successful. Please verify your email with the OTP that will be sent to you.',
    doctorId: doctor._id,
    email: doctor.email,
  })
}

// POST /auth/send-otp
export async function sendOtp(req, res) {
  const { email } = req.body

  if (!email || !isValidEmailFormat(email)) {
    return res.status(400).json({ message: 'A valid email address is required.' })
  }

  if (!isInstitutionalEmail(email)) {
    return res.status(400).json({ message: INSTITUTIONAL_EMAIL_ERROR })
  }

  const doctor = await Doctor.findOne({ email: email.toLowerCase() }).select('+otp +otpExpiry +lastOtpSentAt')
  if (!doctor) {
    return res.status(404).json({ message: 'No account found for this email. Please register first.' })
  }

  if (doctor.isEmailVerified) {
    return res.status(400).json({ message: 'This email is already verified. You can log in.' })
  }

  if (!canResendOtp(doctor.lastOtpSentAt)) {
    return res.status(429).json({
      message: `Please wait ${secondsUntilResendAllowed(doctor.lastOtpSentAt)} seconds before requesting another OTP.`,
      retryAfterSeconds: secondsUntilResendAllowed(doctor.lastOtpSentAt),
    })
  }

  const otp = generateOtp()
  doctor.otp = otp
  doctor.otpExpiry = getOtpExpiry()
  doctor.lastOtpSentAt = new Date()
  await doctor.save()

  try {
    await sendOtpEmail(doctor.email, otp, doctor.name)
  } catch (err) {
    return res.status(502).json({ message: 'Failed to send OTP email. Please try again shortly.' })
  }

  return res.status(200).json({ message: 'OTP sent to your email address.', expiresInMinutes: 5 })
}

// POST /auth/verify-otp
export async function verifyOtp(req, res) {
  const { email, otp } = req.body

  if (!email || !otp) {
    return res.status(400).json({ message: 'Email and OTP are required.' })
  }

  const doctor = await Doctor.findOne({ email: email.toLowerCase() }).select('+otp +otpExpiry')
  if (!doctor) {
    return res.status(404).json({ message: 'No account found for this email.' })
  }

  if (doctor.isEmailVerified) {
    return res.status(400).json({ message: 'Email is already verified.' })
  }

  if (!doctor.otp || isOtpExpired(doctor.otpExpiry)) {
    return res.status(400).json({ message: 'OTP has expired. Please request a new one.' })
  }

  if (doctor.otp !== String(otp)) {
    return res.status(400).json({ message: 'Incorrect OTP. Please try again.' })
  }

  doctor.isEmailVerified = true
  doctor.otp = null
  doctor.otpExpiry = null
  await doctor.save()

  return res.status(200).json({ message: 'Email verified successfully. You can now log in.' })
}

// POST /auth/login
export async function loginDoctor(req, res) {
  const { email, password } = req.body

  if (!email || !password) {
    return res.status(400).json({ message: 'Email and password are required.' })
  }

  const doctor = await Doctor.findOne({ email: email.toLowerCase() }).select('+password')
  if (!doctor) {
    return res.status(401).json({ message: 'Invalid email or password.' })
  }

  const isMatch = await bcrypt.compare(password, doctor.password)
  if (!isMatch) {
    return res.status(401).json({ message: 'Invalid email or password.' })
  }

  if (!doctor.isEmailVerified) {
    return res.status(403).json({
      message: 'Please verify your email before logging in.',
      requiresVerification: true,
      email: doctor.email,
    })
  }

  const token = generateToken(doctor._id)

  return res.status(200).json({
    token,
    doctor: {
      id: doctor._id,
      name: doctor.name,
      email: doctor.email,
      role: doctor.role,
      hospital: doctor.hospital,
      specialization: doctor.specialization,
      registrationNumber: doctor.registrationNumber,
      contact: doctor.phone,
      language: doctor.language,
    },
  })
}

// GET /auth/me
export async function getMe(req, res) {
  const doctor = req.doctor
  return res.status(200).json({
    id: doctor._id,
    name: doctor.name,
    email: doctor.email,
    role: doctor.role,
    hospital: doctor.hospital,
    specialization: doctor.specialization,
    registrationNumber: doctor.registrationNumber,
    contact: doctor.phone,
    language: doctor.language,
  })
}
