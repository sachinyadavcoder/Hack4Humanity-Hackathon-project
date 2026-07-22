import { Link } from 'react-router-dom'

export default function NotFound() {
  return (
    <div className="min-h-screen flex flex-col items-center justify-center bg-surface-bg px-6 text-center">
      <p className="font-display text-6xl font-bold text-primary-500 mb-2">404</p>
      <p className="text-ink-700 font-medium mb-6">This page doesn't exist.</p>
      <Link to="/dashboard" className="px-5 py-2.5 text-sm font-semibold text-white bg-primary-500 rounded-lg hover:bg-primary-600">
        Back to Dashboard
      </Link>
    </div>
  )
}
