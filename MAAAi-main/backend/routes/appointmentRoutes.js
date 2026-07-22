import express from 'express'
import {
  getAllAppointments,
  getTodaysAppointments,
  getUpcomingAppointments,
  getAppointmentById,
} from '../controllers/appointmentController.js'
import { protect } from '../middleware/authMiddleware.js'

const router = express.Router()

router.use(protect)

// Order matters: specific paths before /:id
router.get('/today', getTodaysAppointments)
router.get('/upcoming', getUpcomingAppointments)
router.get('/', getAllAppointments)
router.get('/:id', getAppointmentById)

// No POST / PUT / DELETE routes — doctors can only view appointments.
// Scheduling is owned by the Receptionist Portal.

export default router
