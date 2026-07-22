import dotenv from 'dotenv'
import bcrypt from 'bcryptjs'
import connectDB from '../config/db.js'
import Doctor from '../models/Doctor.js'
import Patient from '../models/Patient.js'
import Appointment from '../models/Appointment.js'
import Notification from '../models/Notification.js'

dotenv.config()

const villages = ['Rampur', 'Sitapur', 'Govindpura', 'Lakhanpur', 'Devgaon', 'Chandpur', 'Mahua Kheda', 'Bhairupur']
const ashaWorkers = ['Sunita Devi', 'Radha Kumari', 'Meena Sharma', 'Kavita Yadav', 'Pooja Singh']
const firstNames = ['Anjali', 'Priya', 'Sunita', 'Kavita', 'Meena', 'Rekha', 'Pooja', 'Neha', 'Deepa', 'Sarita']
const lastNames = ['Devi', 'Kumari', 'Sharma', 'Yadav', 'Singh', 'Verma', 'Patel', 'Gupta', 'Rathore', 'Chauhan']

function pick(arr) {
  return arr[Math.floor(Math.random() * arr.length)]
}

function buildPatient(index) {
  const riskRoll = Math.random()
  const risk = riskRoll < 0.15 ? 'High' : riskRoll < 0.45 ? 'Medium' : 'Normal'
  const riskScore = risk === 'High' ? Math.floor(70 + Math.random() * 28) : risk === 'Medium' ? Math.floor(40 + Math.random() * 29) : Math.floor(5 + Math.random() * 34)
  const trimester = pick([1, 2, 3])
  const week = trimester === 1 ? Math.floor(1 + Math.random() * 12) : trimester === 2 ? Math.floor(13 + Math.random() * 14) : Math.floor(27 + Math.random() * 13)

  const highRiskReasons = ['Low Hemoglobin', 'High Blood Pressure', 'Previous Miscarriage', 'Fetal Growth Restriction', 'Gestational Diabetes']
  const mediumRiskReasons = ['Borderline Blood Pressure', 'Mild Anemia', 'Irregular Weight Gain']
  const reasons = risk === 'High' ? highRiskReasons.slice(0, 2) : risk === 'Medium' ? mediumRiskReasons.slice(0, 1) : ['No significant risk factors identified']

  const lastVisit = new Date()
  lastVisit.setDate(lastVisit.getDate() - Math.floor(Math.random() * 45))

  return {
    patientId: `PT-${String(index).padStart(4, '0')}`,
    name: `${pick(firstNames)} ${pick(lastNames)}`,
    age: Math.floor(19 + Math.random() * 20),
    contact: `+91 ${Math.floor(70000 + Math.random() * 29999)}${Math.floor(10000 + Math.random() * 89999)}`,
    village: pick(villages),
    ashaWorker: pick(ashaWorkers),
    trimester,
    pregnancyWeek: week,
    gravida: `G${Math.floor(1 + Math.random() * 4)}`,
    bloodGroup: pick(['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+']),
    risk,
    riskScore,
    reasons,
    prediction: null,
    lastVisit,
    vitals: {
      bp: `${Math.floor(110 + Math.random() * 30)}/${Math.floor(70 + Math.random() * 15)}`,
      weight: `${Math.floor(48 + Math.random() * 25)} kg`,
      hemoglobin: `${(10 + Math.random() * 3).toFixed(1)} g/dL`,
      sugar: `${Math.floor(80 + Math.random() * 60)} mg/dL`,
      ultrasoundSummary: 'Single live intrauterine fetus, cephalic presentation, adequate liquor.',
    },
    medicalHistory: {
      diabetes: Math.random() < 0.15,
      hypertension: Math.random() < 0.18,
      thyroid: Math.random() < 0.12,
      previousCSection: Math.random() < 0.2,
      previousMiscarriage: Math.random() < 0.15,
      allergies: Math.random() < 0.1 ? 'Penicillin' : 'None reported',
    },
    reports: [
      { type: 'Ultrasound', date: lastVisit, fileName: 'ultrasound_scan.pdf' },
      { type: 'Blood Test', date: lastVisit, fileName: 'blood_test_report.pdf' },
    ],
    previousVisits: [
      { date: new Date(lastVisit.getTime() - 21 * 86400000), bp: '118/76', weight: '58 kg', notes: 'Routine antenatal checkup.' },
    ],
  }
}

async function seed() {
  await connectDB()

  console.log('Clearing existing collections...')
  await Promise.all([Doctor.deleteMany({}), Patient.deleteMany({}), Appointment.deleteMany({}), Notification.deleteMany({})])

  console.log('Creating demo doctor (pre-verified)...')
  const hashedPassword = await bcrypt.hash('password123', 10)
  const demoDoctor = await Doctor.create({
    name: 'Dr. Ayesha Khan',
    email: 'ayesha.khan@districthospital.in',
    password: hashedPassword,
    hospital: 'District Women & Child Hospital',
    specialization: 'Obstetrics & Gynaecology',
    registrationNumber: 'MCI-123456',
    phone: '+91 98765 43210',
    isEmailVerified: true,
  })

  console.log('Seeding patients...')
  const patientDocs = Array.from({ length: 60 }, (_, i) => buildPatient(i + 1))
  const patients = await Patient.insertMany(patientDocs)

  console.log('Seeding appointments...')
  const today = new Date()
  await Appointment.insertMany(
    patients.slice(0, 7).map((p, i) => ({
      patient: p._id,
      patientName: p.name,
      doctor: demoDoctor._id,
      date: today,
      time: `${9 + i}:00 AM`,
      type: 'Routine Checkup',
      hospital: demoDoctor.hospital,
      status: 'Scheduled',
    }))
  )

  console.log('Seeding notifications...')
  const highRisk = patients.find((p) => p.risk === 'High')
  await Notification.insertMany([
    {
      doctor: demoDoctor._id,
      type: 'high-risk',
      title: 'New High-Risk Patient',
      message: `${highRisk?.name || 'A patient'} has been flagged as high-risk.`,
      read: false,
      relatedPatient: highRisk?._id,
    },
    {
      doctor: demoDoctor._id,
      type: 'follow-up',
      title: 'Follow-up Due Tomorrow',
      message: 'A patient has a follow-up visit scheduled for tomorrow.',
      read: false,
    },
  ])

  console.log('Seed complete.')
  console.log(`Demo login: ${demoDoctor.email} / password123`)
  process.exit(0)
}

seed().catch((err) => {
  console.error(err)
  process.exit(1)
})
