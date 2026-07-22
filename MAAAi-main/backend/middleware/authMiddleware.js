import jwt from 'jsonwebtoken'
import Doctor from '../models/Doctor.js'

export async function protect(req, res, next) {
  try {
    const authHeader = req.headers.authorization

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ message: 'Not authorized. No token provided.' })
    }

    const token = authHeader.split(' ')[1]
    const decoded = jwt.verify(token, process.env.JWT_SECRET)

    const doctor = await Doctor.findById(decoded.id)
    if (!doctor) {
      return res.status(401).json({ message: 'Not authorized. Doctor account not found.' })
    }

    req.doctor = doctor
    next()
  } catch (err) {
    return res.status(401).json({ message: 'Not authorized. Invalid or expired token.' })
  }
}

export function requireRole(role) {
  return (req, res, next) => {
    if (!req.doctor || req.doctor.role !== role) {
      return res.status(403).json({ message: 'Forbidden. Insufficient role.' })
    }
    next()
  }
}
