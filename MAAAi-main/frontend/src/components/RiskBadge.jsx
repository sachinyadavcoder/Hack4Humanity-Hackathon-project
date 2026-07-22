const riskStyles = {
  Normal: 'bg-risk-normalBg text-risk-normal',
  Medium: 'bg-risk-mediumBg text-[#96741F]',
  High: 'bg-risk-highBg text-[#B8412D]',
}

const dotStyles = {
  Normal: 'bg-risk-normal',
  Medium: 'bg-risk-medium',
  High: 'bg-risk-high',
}

export default function RiskBadge({ risk, size = 'md' }) {
  const sizeClass = size === 'sm' ? 'text-xs px-2 py-0.5' : 'text-sm px-3 py-1'

  return (
    <span
      className={`inline-flex items-center gap-1.5 rounded-full font-semibold font-body ${sizeClass} ${riskStyles[risk] || riskStyles.Normal}`}
    >
      <span className={`w-2 h-2 rounded-full ${dotStyles[risk] || dotStyles.Normal}`} />
      {risk}
    </span>
  )
}
