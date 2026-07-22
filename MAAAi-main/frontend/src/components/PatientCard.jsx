import { useNavigate } from 'react-router-dom'
import RiskBadge from './RiskBadge'
import { formatDate } from '../utils/formatters'

export default function PatientCard({ patient }) {
  const navigate = useNavigate()

  return (
    <div className="bg-surface-card border border-surface-border rounded-card shadow-card p-5 flex flex-col gap-4 hover:shadow-cardHover transition-shadow">
      <div className="flex items-start justify-between">
        <div>
          <p className="font-display font-semibold text-ink-900">{patient.name}</p>
          <p className="text-xs text-ink-500">{patient.id} · Age {patient.age} · Week {patient.pregnancyWeek}</p>
        </div>
        <RiskBadge risk={patient.risk} size="sm" />
      </div>

      <div className="flex items-center justify-between bg-risk-highBg/60 rounded-lg px-3 py-2">
        <span className="text-xs font-medium text-[#B8412D]">Risk Score</span>
        <span className="text-lg font-display font-bold text-[#B8412D]">{patient.riskScore}%</span>
      </div>

      <div>
        <p className="text-xs font-semibold text-ink-700 mb-1.5">Reasons</p>
        <ul className="space-y-1">
          {patient.reasons.slice(0, 3).map((reason, i) => (
            <li key={i} className="text-xs text-ink-700 flex items-start gap-1.5">
              <span className="text-risk-high mt-0.5">✔</span>
              {reason}
            </li>
          ))}
        </ul>
      </div>

      <div className="flex items-center justify-between pt-1 border-t border-surface-border">
        <span className="text-xs text-ink-500">Last visit: {formatDate(patient.lastVisit)}</span>
        <button
          onClick={() => navigate(`/patients/${patient.id}`)}
          className="text-xs font-semibold text-primary-600 hover:text-primary-700"
        >
          View Details →
        </button>
      </div>
    </div>
  )
}
