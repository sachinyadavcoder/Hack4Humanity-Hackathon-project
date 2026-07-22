import { useEffect, useState } from 'react'
import DashboardLayout from '../components/DashboardLayout'
import Card from '../components/Card'
import appointmentService from '../services/appointmentService'
import { formatDate } from '../utils/formatters'

export default function Appointments() {
  const [todaysAppointments, setTodaysAppointments] = useState([])
  const [upcomingAppointments, setUpcomingAppointments] = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    Promise.all([appointmentService.getTodaysAppointments(), appointmentService.getUpcomingAppointments()])
      .then(([today, upcoming]) => {
        setTodaysAppointments(today)
        setUpcomingAppointments(upcoming)
      })
      .finally(() => setLoading(false))
  }, [])

  return (
    <DashboardLayout>
      <div className="mb-6">
        <h1 className="font-display text-2xl font-bold text-ink-900">Appointments</h1>
        <p className="text-sm text-ink-500 mt-1">Review today's and upcoming appointments.</p>
      </div>

      {loading ? (
        <p className="text-sm text-ink-500">Loading appointments...</p>
      ) : (
        <div className="space-y-5">
          <Card title="Today's Appointments" className="p-5">
            <AppointmentList appointments={todaysAppointments} showDate={false} />
          </Card>

          <Card title="Upcoming Appointments" className="p-5">
            <AppointmentList appointments={upcomingAppointments} showDate />
          </Card>
        </div>
      )}
    </DashboardLayout>
  )
}

function AppointmentList({ appointments, showDate }) {
  if (appointments.length === 0) {
    return <p className="text-sm text-ink-500 py-6 text-center">No appointments scheduled.</p>
  }

  return (
    <div className="divide-y divide-surface-border">
      {appointments.map((appt) => (
        <div key={appt._id} className="flex flex-wrap items-center justify-between gap-2 py-3.5">
          <div>
            <p className="text-sm font-semibold text-ink-900">{appt.patientName}</p>
            <p className="text-xs text-ink-500">{appt.patient?.patientId} · {appt.type}</p>
            {appt.hospital && <p className="text-xs text-ink-500">{appt.hospital}</p>}
          </div>
          <div className="text-right">
            <span className="text-sm font-medium text-primary-600">{appt.time}</span>
            {showDate && appt.date && <p className="text-xs text-ink-500">{formatDate(appt.date)}</p>}
          </div>
        </div>
      ))}
    </div>
  )
}
