import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts'

export default function MonthlyRegistrationsChart({ data }) {
  return (
    <ResponsiveContainer width="100%" height={260}>
      <BarChart data={data} margin={{ top: 5, right: 10, left: -20, bottom: 0 }}>
        <CartesianGrid strokeDasharray="3 3" stroke="#E7E2D9" vertical={false} />
        <XAxis dataKey="month" tick={{ fontSize: 12, fontFamily: 'Inter', fill: '#767C7C' }} axisLine={false} tickLine={false} />
        <YAxis tick={{ fontSize: 12, fontFamily: 'Inter', fill: '#767C7C' }} axisLine={false} tickLine={false} />
        <Tooltip
          contentStyle={{ borderRadius: 10, border: '1px solid #E7E2D9', fontSize: 13, fontFamily: 'Inter' }}
          cursor={{ fill: '#EAF4F3' }}
        />
        <Bar dataKey="registrations" fill="#0F5C5C" radius={[6, 6, 0, 0]} maxBarSize={32} />
      </BarChart>
    </ResponsiveContainer>
  )
}
