import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts'

export default function HighRiskTrendChart({ data }) {
  return (
    <ResponsiveContainer width="100%" height={260}>
      <LineChart data={data} margin={{ top: 5, right: 10, left: -20, bottom: 0 }}>
        <CartesianGrid strokeDasharray="3 3" stroke="#E7E2D9" vertical={false} />
        <XAxis dataKey="month" tick={{ fontSize: 12, fontFamily: 'Inter', fill: '#767C7C' }} axisLine={false} tickLine={false} />
        <YAxis tick={{ fontSize: 12, fontFamily: 'Inter', fill: '#767C7C' }} axisLine={false} tickLine={false} />
        <Tooltip
          contentStyle={{ borderRadius: 10, border: '1px solid #E7E2D9', fontSize: 13, fontFamily: 'Inter' }}
        />
        <Line
          type="monotone"
          dataKey="highRisk"
          stroke="#E8735C"
          strokeWidth={2.5}
          dot={{ fill: '#E8735C', r: 4 }}
          activeDot={{ r: 6 }}
        />
      </LineChart>
    </ResponsiveContainer>
  )
}
