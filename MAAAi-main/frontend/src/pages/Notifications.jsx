import DashboardLayout from '../components/DashboardLayout'
import Card from '../components/Card'
import { useNotifications } from '../context/NotificationContext'
import { daysAgo } from '../utils/formatters'

const typeConfig = {
  'high-risk': { icon: '🔴', bg: 'bg-risk-highBg' },
  'follow-up': { icon: '🟡', bg: 'bg-risk-mediumBg' },
  report: { icon: '📄', bg: 'bg-primary-50' },
  missed: { icon: '⚠️', bg: 'bg-risk-highBg' },
}

export default function Notifications() {
  const { notifications, unreadCount, markAsRead, markAllAsRead } = useNotifications()

  return (
    <DashboardLayout>
      <div className="flex items-center justify-between flex-wrap gap-3 mb-6">
        <div>
          <h1 className="font-display text-2xl font-bold text-ink-900">Notifications</h1>
          <p className="text-sm text-ink-500 mt-1">{unreadCount} unread notification{unreadCount !== 1 ? 's' : ''}</p>
        </div>
        {unreadCount > 0 && (
          <button
            onClick={markAllAsRead}
            className="text-sm font-semibold text-primary-600 hover:text-primary-700"
          >
            Mark all as read
          </button>
        )}
      </div>

      <Card className="p-0 overflow-hidden">
        <div className="divide-y divide-surface-border">
          {notifications.map((n) => {
            const cfg = typeConfig[n.type] || typeConfig.report
            return (
              <div
                key={n._id}
                onClick={() => markAsRead(n._id)}
                className={`flex items-start gap-3.5 px-5 py-4 cursor-pointer hover:bg-surface-bg/60 ${!n.read ? 'bg-primary-50/40' : ''}`}
              >
                <div className={`w-9 h-9 rounded-full flex items-center justify-center flex-shrink-0 ${cfg.bg}`}>
                  <span className="text-sm">{cfg.icon}</span>
                </div>
                <div className="flex-1 min-w-0">
                  <div className="flex items-center gap-2">
                    <p className="text-sm font-semibold text-ink-900">{n.title}</p>
                    {!n.read && <span className="w-1.5 h-1.5 rounded-full bg-primary-500 flex-shrink-0" />}
                  </div>
                  <p className="text-sm text-ink-700 mt-0.5">{n.message}</p>
                  <p className="text-xs text-ink-500 mt-1">{daysAgo(n.createdAt)}</p>
                </div>
              </div>
            )
          })}
        </div>
      </Card>
    </DashboardLayout>
  )
}
