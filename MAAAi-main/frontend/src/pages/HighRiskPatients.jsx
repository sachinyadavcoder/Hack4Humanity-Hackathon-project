import { useEffect, useState } from 'react'
import DashboardLayout from '../components/DashboardLayout'
import PatientCard from '../components/PatientCard'
import patientService from '../services/patientService'

export default function HighRiskPatients() {
  const [highRiskPatients, setHighRiskPatients] = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    patientService
      .getHighRiskPatients()
      .then((data) => setHighRiskPatients(data.map((p) => ({ ...p, id: p.patientId }))))
      .finally(() => setLoading(false))
  }, [])

  return (
    <DashboardLayout>
      <div className="mb-6">
        <h1 className="font-display text-2xl font-bold text-ink-900">High-Risk Patients</h1>
        <p className="text-sm text-ink-500 mt-1">
          {highRiskPatients.length} patients flagged high-risk, sorted by highest risk score first.
        </p>
      </div>

      {loading ? (
        <div className="bg-surface-card border border-surface-border rounded-card p-10 text-center text-ink-500 text-sm">
          Loading...
        </div>
      ) : highRiskPatients.length === 0 ? (
        <div className="bg-surface-card border border-surface-border rounded-card p-10 text-center text-ink-500 text-sm">
          No high-risk patients at the moment.
        </div>
      ) : (
        <div className="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-3 gap-5">
          {highRiskPatients.map((patient) => (
            <PatientCard key={patient.id} patient={patient} />
          ))}
        </div>
      )}
    </DashboardLayout>
  )
}
