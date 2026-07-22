import api from './api'

// Read-only: appointment creation/editing belongs to the Receptionist Portal.
export const appointmentService = {
  async getAllAppointments() {
    const { data } = await api.get('/appointments')
    return data
  },

  async getTodaysAppointments() {
    const { data } = await api.get('/appointments/today')
    return data
  },

  async getUpcomingAppointments() {
    const { data } = await api.get('/appointments/upcoming')
    return data
  },

  async getAppointmentById(id) {
    const { data } = await api.get(`/appointments/${id}`)
    return data
  },
}

export default appointmentService
