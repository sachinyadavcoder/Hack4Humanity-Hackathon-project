import { useEffect, useState } from 'react'
import { useParams, useNavigate, Link } from 'react-router-dom'
import DashboardLayout from '../components/DashboardLayout'
import Card from '../components/Card'
import RiskBadge from '../components/RiskBadge'
import { formatDate } from '../utils/formatters'
import patientService from '../services/patientService'

const EMPTY_REC = { medicines: '', advice: '', diet: '', bedRest: false, referral: '' }

export default function PatientDetails() {
  const { id } = useParams()
  const navigate = useNavigate()

  const [patient, setPatient] = useState(null)
  const [loading, setLoading] = useState(true)
  const [notFound, setNotFound] = useState(false)

  const [previewReport, setPreviewReport] = useState(null)
  const [recommendations, setRecommendations] = useState([])
  const [recText, setRecText] = useState(EMPTY_REC)
  const [editingId, setEditingId] = useState(null)
  const [saving, setSaving] = useState(false)
  const [saved, setSaved] = useState(false)

  useEffect(() => {
    setLoading(true)
    Promise.all([patientService.getPatientById(id), patientService.getRecommendations(id)])
      .then(([patientData, recData]) => {
        setPatient({ ...patientData, id: patientData.patientId })
        setRecommendations(recData)
      })
      .catch(() => setNotFound(true))
      .finally(() => setLoading(false))
  }, [id])

  if (loading) {
    return (
      <DashboardLayout>
        <p className="text-sm text-ink-500">Loading patient...</p>
      </DashboardLayout>
    )
  }

  if (notFound || !patient) {
    return (
      <DashboardLayout>
        <div className="bg-surface-card border border-surface-border rounded-card p-10 text-center">
          <p className="text-ink-700 font-medium mb-2">Patient not found</p>
          <button onClick={() => navigate('/patients')} className="text-sm text-primary-600 font-semibold">
            ← Back to Patients
          </button>
        </div>
      </DashboardLayout>
    )
  }

  const riskColor = patient.risk === 'High' ? 'text-[#B8412D]' : patient.risk === 'Medium' ? 'text-[#96741F]' : 'text-risk-normal'

  const handleSaveRecommendation = async () => {
    setSaving(true)
    try {
      if (editingId) {
        const updated = await patientService.updateRecommendation(editingId, recText)
        setRecommendations((prev) => prev.map((r) => (r._id === editingId ? updated : r)))
      } else {
        const created = await patientService.saveRecommendation(patient.id, recText)
        setRecommendations((prev) => [created, ...prev])
      }
      setRecText(EMPTY_REC)
      setEditingId(null)
      setSaved(true)
      setTimeout(() => setSaved(false), 2000)
    } finally {
      setSaving(false)
    }
  }

  const handleEditRecommendation = (rec) => {
    setEditingId(rec._id)
    setRecText({
      medicines: rec.medicines || '',
      advice: rec.advice || '',
      diet: rec.diet || '',
      bedRest: !!rec.bedRest,
      referral: rec.referral || '',
    })
  }

  const handleCancelEdit = () => {
    setEditingId(null)
    setRecText(EMPTY_REC)
  }

  const handleDeleteRecommendation = async (recId) => {
    await patientService.deleteRecommendation(recId)
    setRecommendations((prev) => prev.filter((r) => r._id !== recId))
    if (editingId === recId) handleCancelEdit()
  }

  const timelineSteps = [
    { label: 'Patient Registered', date: patient.previousVisits[patient.previousVisits.length - 1]?.date },
    { label: 'First Visit', date: patient.previousVisits[patient.previousVisits.length - 1]?.date },
    { label: 'Ultrasound', date: patient.lastVisit },
    { label: 'Prediction Generated', date: patient.prediction ? patient.lastVisit : null },
    { label: 'Doctor Recommendation', date: recommendations[0]?.createdAt || null },
    { label: 'Follow-up Visit', date: null },
  ]

  return (
    <DashboardLayout>
      {/* Header */}
      <div className="flex flex-wrap items-start justify-between gap-4 mb-6">
        <div>
          <Link to="/patients" className="text-xs font-medium text-primary-600 hover:text-primary-700">← Back to Patients</Link>
          <h1 className="font-display text-2xl font-bold text-ink-900 mt-1">{patient.name}</h1>
          <p className="text-sm text-ink-500 mt-0.5">{patient.id} · {patient.village} · Week {patient.pregnancyWeek} ({patient.gravida})</p>
        </div>
        <div className="flex items-center gap-3">
          <RiskBadge risk={patient.risk} />
        </div>
      </div>

      <div className="grid grid-cols-1 xl:grid-cols-3 gap-5">
        {/* Left column: main content */}
        <div className="xl:col-span-2 space-y-5">
          {/* Basic Information */}
          <Card title="Basic Information" className="p-5">
            <div className="grid grid-cols-2 sm:grid-cols-3 gap-4 text-sm">
              <Info label="Name" value={patient.name} />
              <Info label="Age" value={`${patient.age} years`} />
              <Info label="Contact" value={patient.contact} />
              <Info label="Village" value={patient.village} />
              <Info label="Pregnancy Week" value={`Week ${patient.pregnancyWeek}`} />
              <Info label="Gravida" value={patient.gravida} />
              <Info label="Blood Group" value={patient.bloodGroup} />
              <Info label="ASHA Worker" value={patient.ashaWorker} />
            </div>
          </Card>

          {/* Medical History */}
          <Card title="Medical History" className="p-5">
            <div className="grid grid-cols-2 sm:grid-cols-3 gap-3 text-sm">
              <HistoryFlag label="Diabetes" flagged={patient.medicalHistory.diabetes} />
              <HistoryFlag label="Hypertension" flagged={patient.medicalHistory.hypertension} />
              <HistoryFlag label="Thyroid" flagged={patient.medicalHistory.thyroid} />
              <HistoryFlag label="Previous C-section" flagged={patient.medicalHistory.previousCSection} />
              <HistoryFlag label="Previous Miscarriage" flagged={patient.medicalHistory.previousMiscarriage} />
              <Info label="Allergies" value={patient.medicalHistory.allergies} />
            </div>
          </Card>

          {/* Current Pregnancy */}
          <Card title="Current Pregnancy" className="p-5">
            <div className="grid grid-cols-2 sm:grid-cols-3 gap-4 text-sm mb-4">
              <Info label="Blood Pressure" value={patient.vitals.bp} />
              <Info label="Weight" value={patient.vitals.weight} />
              <Info label="Hemoglobin" value={patient.vitals.hemoglobin} />
              <Info label="Sugar" value={patient.vitals.sugar} />
            </div>
            <div className="mb-4">
              <p className="text-xs font-semibold text-ink-500 uppercase tracking-wide mb-1">Ultrasound Summary</p>
              <p className="text-sm text-ink-700">{patient.vitals.ultrasoundSummary}</p>
            </div>
            <div>
              <p className="text-xs font-semibold text-ink-500 uppercase tracking-wide mb-2">Previous Visits</p>
              <div className="space-y-2">
                {patient.previousVisits.map((v, i) => (
                  <div key={i} className="flex flex-wrap items-center justify-between bg-surface-bg rounded-lg px-3 py-2 text-sm">
                    <span className="text-ink-700 font-medium">{formatDate(v.date)}</span>
                    <span className="text-ink-500">BP {v.bp} · {v.weight}</span>
                  </div>
                ))}
              </div>
            </div>
          </Card>

          {/* Uploaded Reports */}
          <Card title="Uploaded Reports" className="p-5">
            <div className="space-y-2">
              {patient.reports.map((r, i) => (
                <div key={i} className="flex items-center justify-between bg-surface-bg rounded-lg px-3 py-2.5">
                  <div>
                    <p className="text-sm font-medium text-ink-900">{r.type}</p>
                    <p className="text-xs text-ink-500">{formatDate(r.date)} · {r.fileName}</p>
                  </div>
                  <button
                    onClick={() => setPreviewReport(r)}
                    className="text-xs font-semibold text-primary-600 hover:text-primary-700"
                  >
                    Preview
                  </button>
                </div>
              ))}
            </div>
          </Card>

          {/* Doctor Recommendations */}
          <Card title="Doctor Recommendations" className="p-5">
            <div className="space-y-3">
              <textarea
                value={recText.advice}
                onChange={(e) => setRecText({ ...recText, advice: e.target.value })}
                rows={3}
                placeholder="Write advice for the patient..."
                className="w-full px-3 py-2.5 text-sm bg-white border border-surface-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-400 resize-none"
              />
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <input
                  type="text"
                  value={recText.medicines}
                  onChange={(e) => setRecText({ ...recText, medicines: e.target.value })}
                  placeholder="Medicines"
                  className="w-full px-3 py-2.5 text-sm bg-white border border-surface-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-400"
                />
                <input
                  type="text"
                  value={recText.diet}
                  onChange={(e) => setRecText({ ...recText, diet: e.target.value })}
                  placeholder="Diet recommendation"
                  className="w-full px-3 py-2.5 text-sm bg-white border border-surface-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-400"
                />
                <input
                  type="text"
                  value={recText.referral}
                  onChange={(e) => setRecText({ ...recText, referral: e.target.value })}
                  placeholder="Referral (if any)"
                  className="w-full px-3 py-2.5 text-sm bg-white border border-surface-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-400"
                />
                <label className="flex items-center gap-2 text-sm text-ink-700 px-1">
                  <input
                    type="checkbox"
                    checked={recText.bedRest}
                    onChange={(e) => setRecText({ ...recText, bedRest: e.target.checked })}
                    className="rounded border-surface-border text-primary-500 focus:ring-primary-400"
                  />
                  Recommend bed rest
                </label>
              </div>
              <div className="flex items-center gap-3">
                <button
                  onClick={handleSaveRecommendation}
                  disabled={saving || !recText.advice.trim()}
                  className="px-4 py-2 text-sm font-semibold text-white bg-primary-500 rounded-lg hover:bg-primary-600 disabled:opacity-50"
                >
                  {saving ? 'Saving...' : editingId ? 'Update' : 'Save'}
                </button>
                {editingId && (
                  <button
                    onClick={handleCancelEdit}
                    className="px-4 py-2 text-sm font-semibold text-ink-700 border border-surface-border rounded-lg hover:bg-surface-bg"
                  >
                    Cancel
                  </button>
                )}
                {saved && <span className="text-sm text-risk-normal font-medium">Recommendation saved</span>}
              </div>
            </div>

            {recommendations.length > 0 && (
              <div className="mt-5 pt-5 border-t border-surface-border space-y-3">
                <p className="text-xs font-semibold text-ink-500 uppercase tracking-wide">Previous Recommendations</p>
                {recommendations.map((r) => (
                  <div key={r._id} className="bg-surface-bg rounded-lg p-3.5 text-sm">
                    <div className="flex justify-between mb-1.5">
                      <span className="font-semibold text-ink-900">{r.doctorName}</span>
                      <div className="flex items-center gap-3">
                        <span className="text-xs text-ink-500">{formatDate(r.createdAt)}</span>
                        <button
                          onClick={() => handleEditRecommendation(r)}
                          className="text-xs font-semibold text-primary-600 hover:text-primary-700"
                        >
                          Edit
                        </button>
                        <button
                          onClick={() => handleDeleteRecommendation(r._id)}
                          className="text-xs font-semibold text-risk-high hover:text-[#B8412D]"
                        >
                          Delete
                        </button>
                      </div>
                    </div>
                    {r.advice && <p className="text-ink-700 mb-1"><span className="font-medium">Advice:</span> {r.advice}</p>}
                    {r.medicines && <p className="text-ink-700 mb-1"><span className="font-medium">Medicines:</span> {r.medicines}</p>}
                    {r.diet && <p className="text-ink-700 mb-1"><span className="font-medium">Diet:</span> {r.diet}</p>}
                    {r.bedRest && <p className="text-ink-700 mb-1">🛏 Bed rest recommended</p>}
                    {r.referral && <p className="text-ink-700"><span className="font-medium">Referral:</span> {r.referral}</p>}
                  </div>
                ))}
              </div>
            )}
          </Card>

          {/* Patient Timeline */}
          <Card title="Patient Timeline" className="p-5">
            <ol className="relative border-l-2 border-surface-border ml-2">
              {timelineSteps.map((step, i) => (
                <li key={i} className="mb-6 last:mb-0 ml-5">
                  <span className={`absolute -left-[9px] w-4 h-4 rounded-full border-2 border-white ${step.date ? 'bg-primary-500' : 'bg-surface-border'}`} />
                  <p className="text-sm font-semibold text-ink-900">{step.label}</p>
                  <p className="text-xs text-ink-500">{step.date ? formatDate(step.date) : 'Pending'}</p>
                </li>
              ))}
            </ol>
          </Card>
        </div>

        {/* Right column: AI Prediction */}
        <div className="space-y-5">
          <Card className="p-5">
            <h3 className="font-display font-semibold text-ink-900 text-base mb-4">AI Prediction</h3>
            <div className="text-center bg-surface-bg rounded-card py-6 mb-4">
              <p className={`font-display text-3xl font-bold ${riskColor}`}>{patient.risk === 'High' ? '🔴' : patient.risk === 'Medium' ? '🟡' : '🟢'} {patient.risk}</p>
              <p className="text-xs text-ink-500 mt-1">Risk Level</p>
            </div>
            <div className="flex items-center justify-between bg-surface-bg rounded-lg px-4 py-3 mb-4">
              <span className="text-sm font-medium text-ink-700">Risk Score</span>
              <span className={`font-display text-xl font-bold ${riskColor}`}>{patient.riskScore}%</span>
            </div>
            <div>
              <p className="text-xs font-semibold text-ink-500 uppercase tracking-wide mb-2">Prediction Reasons</p>
              <ul className="space-y-1.5">
                {patient.reasons.map((reason, i) => (
                  <li key={i} className="text-sm text-ink-700 flex items-start gap-2">
                    <span className="text-risk-normal mt-0.5">✔</span>
                    {reason}
                  </li>
                ))}
              </ul>
            </div>
          </Card>
        </div>
      </div>

      {previewReport && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/40" onClick={() => setPreviewReport(null)}>
          <div className="bg-surface-card rounded-card shadow-cardHover w-full max-w-md p-6" onClick={(e) => e.stopPropagation()}>
            <div className="flex items-center justify-between mb-4">
              <h3 className="font-display font-semibold text-ink-900">{previewReport.type} Preview</h3>
              <button onClick={() => setPreviewReport(null)} className="text-ink-500 hover:text-ink-900 text-xl leading-none">×</button>
            </div>
            <div className="bg-surface-bg rounded-lg h-64 flex items-center justify-center text-ink-500 text-sm">
              📄 {previewReport.fileName}
            </div>
          </div>
        </div>
      )}
    </DashboardLayout>
  )
}

function Info({ label, value }) {
  return (
    <div>
      <p className="text-xs text-ink-500 mb-0.5">{label}</p>
      <p className="font-medium text-ink-900">{value}</p>
    </div>
  )
}

function HistoryFlag({ label, flagged }) {
  return (
    <div className="flex items-center gap-2">
      <span className={`w-2 h-2 rounded-full ${flagged ? 'bg-risk-high' : 'bg-risk-normal'}`} />
      <span className="text-ink-700">{label}</span>
      <span className={`text-xs ml-auto font-medium ${flagged ? 'text-risk-high' : 'text-risk-normal'}`}>
        {flagged ? 'Yes' : 'No'}
      </span>
    </div>
  )
}
