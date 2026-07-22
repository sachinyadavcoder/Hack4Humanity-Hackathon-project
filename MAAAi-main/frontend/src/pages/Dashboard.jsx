import { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import DashboardLayout from '../components/DashboardLayout'
import StatCard from '../components/StatCard'
import Card from '../components/Card'
import RiskDistributionChart from '../components/Charts/RiskDistributionChart'
import MonthlyRegistrationsChart from '../components/Charts/MonthlyRegistrationsChart'
import HighRiskTrendChart from '../components/Charts/HighRiskTrendChart'
import { useAuth } from '../context/AuthContext'
import dashboardService from '../services/dashboardService'
import appointmentService from '../services/appointmentService'

const RISK_COLORS = { Normal: '#5FA88B', Medium: '#E8B84B', High: '#E8735C' }

export default function Dashboard() {
  const { doctor } = useAuth()
  const navigate = useNavigate()

  const [stats, setStats] = useState(null)
  const [todaysAppointments, setTodaysAppointments] = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    Promise.all([dashboardService.getStats(), appointmentService.getTodaysAppointments()])
      .then(([statsData, appointmentsData]) => {
        setStats(statsData)
        setTodaysAppointments(appointmentsData)
      })
      .finally(() => setLoading(false))
  }, [])

  if (loading || !stats) {
    return (
      <DashboardLayout>
        <p className="text-sm text-ink-500">Loading dashboard...</p>
      </DashboardLayout>
    )
  }

  const riskDistributionData = [
    { name: 'Normal', value: stats.normalRisk, color: RISK_COLORS.Normal },
    { name: 'Medium', value: stats.mediumRisk, color: RISK_COLORS.Medium },
    { name: 'High', value: stats.highRisk, color: RISK_COLORS.High },
  ]

  return (
    <DashboardLayout>
      <div className="mb-6">
        <h1 className="font-display text-2xl font-bold text-ink-900">
          Good day, {doctor?.name?.split(' ').slice(-1)[0] ? `Dr. ${doctor.name.split(' ').slice(-1)[0]}` : 'Doctor'}
        </h1>
        <p className="text-sm text-ink-500 mt-1">Here's what's happening across your patients today.</p>
      </div>

      {/* Overview Cards */}
      <div className="grid grid-cols-2 lg:grid-cols-3 xl:grid-cols-6 gap-4 mb-6">
        <StatCard label="Total Patients" value={stats.totalPatients} tint="primary" icon={<UsersIcon />} />
        <StatCard label="Normal Risk" value={stats.normalRisk} tint="normal" icon={<CheckIcon />} />
        <StatCard label="Medium Risk" value={stats.mediumRisk} tint="medium" icon={<WarnIcon />} />
        <StatCard label="High Risk" value={stats.highRisk} tint="high" icon={<AlertIcon />} />
        <StatCard label="Today's Appointments" value={stats.todaysAppointments} tint="primary" icon={<CalIcon />} />
        <StatCard label="Pending Follow-ups" value={stats.pendingFollowUps} tint="medium" icon={<ClockIcon />} />
      </div>

      {/* Charts */}
      <div className="grid grid-cols-1 xl:grid-cols-3 gap-5 mb-6">
        <Card title="Risk Distribution" className="p-5">
          <RiskDistributionChart data={riskDistributionData} />
        </Card>
        <Card title="Monthly Patient Registrations" className="p-5">
          <MonthlyRegistrationsChart data={stats.monthlyRegistrations} />
        </Card>
        <Card title="High-Risk Trend" className="p-5">
          <HighRiskTrendChart data={stats.highRiskTrend} />
        </Card>
      </div>

      {/* Today's Appointments list */}
      <Card
        title="Today's Appointments"
        className="p-5"
        action={
          <button onClick={() => navigate('/appointments')} className="text-sm font-semibold text-primary-600 hover:text-primary-700">
            View all →
          </button>
        }
      >
        <div className="divide-y divide-surface-border">
          {todaysAppointments.map((appt) => (
            <div key={appt._id} className="flex items-center justify-between py-3">
              <div>
                <p className="text-sm font-semibold text-ink-900">{appt.patientName}</p>
                <p className="text-xs text-ink-500">{appt.patient?.patientId} · {appt.type}</p>
              </div>
              <span className="text-sm font-medium text-primary-600">{appt.time}</span>
            </div>
          ))}
          {todaysAppointments.length === 0 && (
            <p className="text-sm text-ink-500 py-6 text-center">No appointments today.</p>
          )}
        </div>
      </Card>
    </DashboardLayout>
  )
}

function UsersIcon() {
  return <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.8}><path strokeLinecap="round" strokeLinejoin="round" d="M17 20h5v-2a4 4 0 00-3-3.87M9 20H4v-2a4 4 0 013-3.87m6-5.13a4 4 0 11-4-4 4 4 0 014 4zm6 4a4 4 0 10-4-4" /></svg>
}
function CheckIcon() {
  return <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.8}><path strokeLinecap="round" strokeLinejoin="round" d="M5 13l4 4L19 7" /></svg>
}
function WarnIcon() {
  return <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.8}><path strokeLinecap="round" strokeLinejoin="round" d="M12 9v2m0 4h.01M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z" /></svg>
}
function AlertIcon() {
  return <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.8}><path strokeLinecap="round" strokeLinejoin="round" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" /></svg>
}
function CalIcon() {
  return <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.8}><path strokeLinecap="round" strokeLinejoin="round" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" /></svg>
}
function ClockIcon() {
  return <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.8}><path strokeLinecap="round" strokeLinejoin="round" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
}
