import mongoose from 'mongoose'

const doctorRecommendationSchema = new mongoose.Schema(
  {
    patient: { type: mongoose.Schema.Types.ObjectId, ref: 'Patient', required: true, index: true },
    doctor: { type: mongoose.Schema.Types.ObjectId, ref: 'Doctor', required: true },
    doctorName: { type: String, required: true }, // denormalized for fast display
    medicines: { type: String, default: '' },
    advice: { type: String, default: '' },
    diet: { type: String, default: '' },
    bedRest: { type: Boolean, default: false },
    referral: { type: String, default: '' },
  },
  { timestamps: true }
)

const DoctorRecommendation = mongoose.model('DoctorRecommendation', doctorRecommendationSchema)

export default DoctorRecommendation
