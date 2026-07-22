import { useNavigate } from 'react-router-dom'
import { useAuth } from '../context/AuthContext'
import { useNotifications } from '../context/NotificationContext'

export default function Navbar({ onMenuClick, onSearch }) {
  const { doctor } = useAuth()
  const { unreadCount } = useNotifications()
  const navigate = useNavigate()

  return (
    <header className="sticky top-0 z-20 bg-surface-card border-b border-surface-border">
      <div className="flex items-center gap-4 px-4 sm:px-6 py-3">
        <button
          onClick={onMenuClick}
          className="lg:hidden p-2 -ml-2 rounded-lg text-ink-700 hover:bg-surface-bg"
          aria-label="Open menu"
        >
          <svg className="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.8}>
            <path strokeLinecap="round" strokeLinejoin="round" d="M4 6h16M4 12h16M4 18h16" />
          </svg>
        </button>

        <div className="flex-1 max-w-md hidden sm:block">
          <div className="relative">
            <svg className="w-4 h-4 absolute left-3 top-1/2 -translate-y-1/2 text-ink-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
              <path strokeLinecap="round" strokeLinejoin="round" d="M21 21l-4.35-4.35M17 10a7 7 0 11-14 0 7 7 0 0114 0z" />
            </svg>
            <input
              type="text"
              placeholder="Search patients by name or ID..."
              onChange={(e) => onSearch?.(e.target.value)}
              className="w-full pl-9 pr-4 py-2 text-sm bg-surface-bg border border-surface-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-400 focus:border-transparent"
            />
          </div>
        </div>

        <div className="flex-1 sm:hidden" />

        <button
          onClick={() => navigate('/notifications')}
          className="relative ml-auto p-2 rounded-lg text-ink-700 hover:bg-surface-bg"
          aria-label="Notifications"
        >
          <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.8}>
            <path strokeLinecap="round" strokeLinejoin="round" d="M15 17h5l-1.4-1.4A2 2 0 0118 14.2V11a6 6 0 10-12 0v3.2a2 2 0 01-.6 1.4L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
          </svg>
          {unreadCount > 0 && (
            <span className="absolute top-1 right-1 w-4 h-4 flex items-center justify-center bg-risk-high text-white text-[10px] font-bold rounded-full">
              {unreadCount}
            </span>
          )}
        </button>

        <button
          onClick={() => navigate('/profile')}
          className="flex items-center gap-2.5 pl-2 pr-1 py-1 rounded-lg hover:bg-surface-bg"
        >
          <div className="w-8 h-8 rounded-full bg-primary-500 text-white flex items-center justify-center text-sm font-semibold font-display">
            {doctor?.name?.split(' ').map((n) => n[0]).slice(0, 2).join('') || 'DR'}
          </div>
          <div className="hidden md:block text-left">
            <p className="text-sm font-semibold text-ink-900 leading-tight">{doctor?.name || 'Doctor'}</p>
            <p className="text-xs text-ink-500 leading-tight">{doctor?.specialization || ''}</p>
          </div>
        </button>
      </div>
    </header>
  )
}
