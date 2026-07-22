import { createContext, useContext, useEffect, useState } from 'react'
import notificationService from '../services/notificationService'
import authService from '../services/authService'

const NotificationContext = createContext(null)

export function NotificationProvider({ children }) {
  const [notifications, setNotifications] = useState([])

  const loadNotifications = async () => {
    if (!authService.isAuthenticated()) return
    try {
      const data = await notificationService.getAll()
      setNotifications(data)
    } catch (err) {
      // Silently ignore — most commonly hit before login on first app load.
      setNotifications([])
    }
  }

  useEffect(() => {
    loadNotifications()
  }, [])

  const unreadCount = notifications.filter((n) => !n.read).length

  const markAsRead = async (id) => {
    setNotifications((prev) => prev.map((n) => (n._id === id ? { ...n, read: true } : n)))
    try {
      await notificationService.markAsRead(id)
    } catch (err) {
      // Revert on failure
      loadNotifications()
    }
  }

  const markAllAsRead = async () => {
    setNotifications((prev) => prev.map((n) => ({ ...n, read: true })))
    try {
      await notificationService.markAllAsRead()
    } catch (err) {
      loadNotifications()
    }
  }

  const value = { notifications, unreadCount, markAsRead, markAllAsRead, reload: loadNotifications }

  return <NotificationContext.Provider value={value}>{children}</NotificationContext.Provider>
}

export function useNotifications() {
  const ctx = useContext(NotificationContext)
  if (!ctx) throw new Error('useNotifications must be used within NotificationProvider')
  return ctx
}
