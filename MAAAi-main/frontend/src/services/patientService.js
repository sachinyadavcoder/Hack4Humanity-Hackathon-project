import api from './api'

export const patientService = {
  async getAllPatients(params = {}) {
    const { data } = await api.get('/patients', { params })
    return data.patients
  },

  async getPatientById(id) {
    const { data } = await api.get(`/patients/${id}`)
    return data
  },

  async getHighRiskPatients() {
    const { data } = await api.get('/patients/high-risk')
    return data
  },

  async getRecommendations(patientId) {
    const { data } = await api.get(`/patients/${patientId}/recommendations`)
    return data
  },

  async saveRecommendation(patientId, recommendation) {
    const { data } = await api.post(`/patients/${patientId}/recommendations`, recommendation)
    return data
  },

  async updateRecommendation(recommendationId, recommendation) {
    const { data } = await api.put(`/recommendations/${recommendationId}`, recommendation)
    return data
  },

  async deleteRecommendation(recommendationId) {
    const { data } = await api.delete(`/recommendations/${recommendationId}`)
    return data
  },
}

export default patientService
