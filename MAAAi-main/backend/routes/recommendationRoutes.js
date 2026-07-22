import express from 'express'
import { updateRecommendation, deleteRecommendation } from '../controllers/recommendationController.js'
import { protect } from '../middleware/authMiddleware.js'

const router = express.Router()

router.use(protect)

router.put('/:recId', updateRecommendation)
router.delete('/:recId', deleteRecommendation)

export default router
