import jwt from 'jsonwebtoken'

export function generateToken(doctorId) {
  return jwt.sign({ id: doctorId, role: 'doctor' }, process.env.JWT_SECRET, {
    expiresIn: process.env.JWT_EXPIRES_IN || '8h',
  })
}

export default generateToken
