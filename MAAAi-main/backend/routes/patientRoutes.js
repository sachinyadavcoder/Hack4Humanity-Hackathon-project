import express from 'express'
import { getPatients, getHighRiskPatients, getPatientById } from '../controllers/patientController.js'
import { getRecommendations, addRecommendation } from '../controllers/recommendationController.js'
import { protect } from '../middleware/authMiddleware.js'

const router = express.Router()

router.use(protect)

// IMPORTANT: /high-risk must be declared before /:id, otherwise Express
// will treat "high-risk" as a patient id.
router.get('/high-risk', getHighRiskPatients)
router.get('/', getPatients)
router.get('/:id', getPatientById)

router.get('/:id/recommendations', getRecommendations)
router.post('/:id/recommendations', addRecommendation)

export default router
