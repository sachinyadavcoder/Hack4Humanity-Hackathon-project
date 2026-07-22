import crypto from 'crypto'

const OTP_TTL_MINUTES = 5
const RESEND_COOLDOWN_SECONDS = 60

export function generateOtp() {
  // Cryptographically secure 6-digit OTP
  return crypto.randomInt(100000, 999999).toString()
}

export function getOtpExpiry() {
  return new Date(Date.now() + OTP_TTL_MINUTES * 60 * 1000)
}

export function isOtpExpired(otpExpiry) {
  return !otpExpiry || new Date() > new Date(otpExpiry)
}

export function canResendOtp(lastOtpSentAt) {
  if (!lastOtpSentAt) return true
  const secondsSinceLastSend = (Date.now() - new Date(lastOtpSentAt).getTime()) / 1000
  return secondsSinceLastSend >= RESEND_COOLDOWN_SECONDS
}

export function secondsUntilResendAllowed(lastOtpSentAt) {
  if (!lastOtpSentAt) return 0
  const elapsed = (Date.now() - new Date(lastOtpSentAt).getTime()) / 1000
  return Math.max(0, Math.ceil(RESEND_COOLDOWN_SECONDS - elapsed))
}

export { OTP_TTL_MINUTES, RESEND_COOLDOWN_SECONDS }
