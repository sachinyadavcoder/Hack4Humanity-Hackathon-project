export function formatDate(dateStr) {
  if (!dateStr) return '—'
  const date = new Date(dateStr)
  return date.toLocaleDateString('en-IN', { day: '2-digit', month: 'short', year: 'numeric' })
}

export function daysAgo(dateStr) {
  const date = new Date(dateStr)
  const diff = Math.floor((Date.now() - date.getTime()) / (1000 * 60 * 60 * 24))
  if (diff === 0) return 'Today'
  if (diff === 1) return 'Yesterday'
  return `${diff} days ago`
}

export function riskEmoji(risk) {
  if (risk === 'High') return '🔴'
  if (risk === 'Medium') return '🟡'
  return '🟢'
}
