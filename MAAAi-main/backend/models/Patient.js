import mongoose from 'mongoose'

const patientSchema = new mongoose.Schema(
  {
    patientId: { type: String, required: true, unique: true }, // e.g. PT-0001
    name: { type: String, required: true, trim: true },
    age: { type: Number, required: true },
    contact: { type: String, required: true },
    village: { type: String, required: true, index: true },
    ashaWorker: { type: String },
    trimester: { type: Number, enum: [1, 2, 3], required: true },
    pregnancyWeek: { type: Number, required: true },
    gravida: { type: String },
    bloodGroup: { type: String },

    risk: { type: String, enum: ['Normal', 'Medium', 'High'], default: 'Normal', index: true },
    riskScore: { type: Number, default: 0 },
    reasons: [{ type: String }],
    // AI prediction is owned by a separate FastAPI service. Never populated here.
    prediction: { type: mongoose.Schema.Types.Mixed, default: null },

    lastVisit: { type: Date },

    vitals: {
      bp: String,
      weight: String,
      hemoglobin: String,
      sugar: String,
      ultrasoundSummary: String,
    },

    medicalHistory: {
      diabetes: { type: Boolean, default: false },
      hypertension: { type: Boolean, default: false },
      thyroid: { type: Boolean, default: false },
      previousCSection: { type: Boolean, default: false },
      previousMiscarriage: { type: Boolean, default: false },
      allergies: { type: String, default: 'None reported' },
    },

    reports: [
      {
        type: { type: String },
        date: Date,
        fileName: String,
        filePath: String,
      },
    ],

    previousVisits: [
      {
        date: Date,
        bp: String,
        weight: String,
        notes: String,
      },
    ],

    assignedDoctor: { type: mongoose.Schema.Types.ObjectId, ref: 'Doctor' },
  },
  { timestamps: true }
)

patientSchema.index({ name: 'text', patientId: 'text' })

const Patient = mongoose.model('Patient', patientSchema)

export default Patient
