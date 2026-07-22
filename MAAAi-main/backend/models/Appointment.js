import mongoose from 'mongoose'

// NOTE: Doctors can only VIEW appointments in this dashboard.
// Creation / editing / cancellation belongs to the Receptionist Portal,
// which is expected to write to this same collection from a separate service.
const appointmentSchema = new mongoose.Schema(
  {
    patient: { type: mongoose.Schema.Types.ObjectId, ref: 'Patient', required: true, index: true },
    patientName: { type: String, required: true }, // denormalized for fast display
    doctor: { type: mongoose.Schema.Types.ObjectId, ref: 'Doctor', index: true },
    date: { type: Date, required: true },
    time: { type: String, required: true }, // e.g. "09:30 AM"
    type: { type: String, required: true }, // visit type, e.g. "Routine Checkup"
    hospital: { type: String },
    notes: { type: String },
    status: { type: String, enum: ['Scheduled', 'Completed', 'Missed', 'Cancelled'], default: 'Scheduled' },
  },
  { timestamps: true }
)

const Appointment = mongoose.model('Appointment', appointmentSchema)

export default Appointment
