import mongoose from 'mongoose'

const doctorSchema = new mongoose.Schema(
  {
    name: { type: String, required: true, trim: true },
    email: { type: String, required: true, unique: true, lowercase: true, trim: true },
    password: { type: String, required: true, select: false },
    hospital: { type: String, required: true, trim: true },
    specialization: { type: String, required: true, trim: true },
    registrationNumber: { type: String, required: true, trim: true },
    phone: { type: String, required: true, trim: true },
    role: { type: String, default: 'doctor', enum: ['doctor'] },
    language: { type: String, default: 'English' },

    isEmailVerified: { type: Boolean, default: false },
    otp: { type: String, default: null, select: false },
    otpExpiry: { type: Date, default: null, select: false },
    lastOtpSentAt: { type: Date, default: null, select: false },
  },
  { timestamps: true }
)

const Doctor = mongoose.model('Doctor', doctorSchema)

export default Doctor
