export default function Card({ children, className = '', title, action }) {
  return (
    <div className={`bg-surface-card border border-surface-border rounded-card shadow-card ${className}`}>
      {(title || action) && (
        <div className="flex items-center justify-between px-5 pt-5 pb-3">
          {title && <h3 className="font-display font-semibold text-ink-900 text-base">{title}</h3>}
          {action}
        </div>
      )}
      {children}
    </div>
  )
}
