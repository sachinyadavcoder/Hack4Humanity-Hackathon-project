import Notification from '../models/Notification.js'

// GET /notifications
export async function getNotifications(req, res) {
  const notifications = await Notification.find({ doctor: req.doctor._id }).sort({ createdAt: -1 })
  return res.status(200).json(notifications)
}

// PUT /notifications/:id/read
export async function markNotificationRead(req, res) {
  const { id } = req.params

  const notification = await Notification.findOne({ _id: id, doctor: req.doctor._id })
  if (!notification) {
    return res.status(404).json({ message: 'Notification not found.' })
  }

  notification.read = true
  await notification.save()

  return res.status(200).json(notification)
}

// PUT /notifications/read-all
export async function markAllNotificationsRead(req, res) {
  await Notification.updateMany({ doctor: req.doctor._id, read: false }, { $set: { read: true } })
  const notifications = await Notification.find({ doctor: req.doctor._id }).sort({ createdAt: -1 })
  return res.status(200).json(notifications)
}
