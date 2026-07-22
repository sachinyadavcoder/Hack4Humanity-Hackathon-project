import mongoose from 'mongoose'

const healthRecordSchema = new mongoose.Schema(
  {
    patient: { type: mongoose.Schema.Types.ObjectId, ref: 'Patient', required: true, index: true },
    recordType: { type: String, enum: ['Ultrasound', 'Blood Test', 'Prescription', 'Other'], required: true },
    date: { type: Date, default: Date.now },
    fileName: { type: String, required: true },
    filePath: { type: String, required: true }, // path under /uploads, populated via Multer
    notes: { type: String },
    uploadedBy: { type: mongoose.Schema.Types.ObjectId, ref: 'Doctor' },
  },
  { timestamps: true }
)

const HealthRecord = mongoose.model('HealthRecord', healthRecordSchema)

export default HealthRecord
