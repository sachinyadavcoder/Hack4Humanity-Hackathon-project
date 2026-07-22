export default function StatCard({ label, value, icon, tint = 'primary' }) {
  const tintClasses = {
    primary: 'bg-primary-50 text-primary-600',
    normal: 'bg-risk-normalBg text-risk-normal',
    medium: 'bg-risk-mediumBg text-[#96741F]',
    high: 'bg-risk-highBg text-[#B8412D]',
  }

  return (
    <div className="bg-surface-card border border-surface-border rounded-card shadow-card p-5 flex items-center gap-4 hover:shadow-cardHover transition-shadow">
      <div className={`w-11 h-11 rounded-xl flex items-center justify-center flex-shrink-0 ${tintClasses[tint]}`}>
        {icon}
      </div>
      <div className="min-w-0">
        <p className="text-2xl font-display font-bold text-ink-900 leading-tight">{value}</p>
        <p className="text-sm text-ink-500 truncate">{label}</p>
      </div>
    </div>
  )
}
