import express from 'express'
import { registerDoctor, sendOtp, verifyOtp, loginDoctor, getMe } from '../controllers/authController.js'
import { protect } from '../middleware/authMiddleware.js'

const router = express.Router()

router.post('/register', registerDoctor)
router.post('/send-otp', sendOtp)
router.post('/verify-otp', verifyOtp)
router.post('/login', loginDoctor)
router.get('/me', protect, getMe)

export default router
