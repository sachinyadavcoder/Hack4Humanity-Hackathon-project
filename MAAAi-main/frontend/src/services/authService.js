import api from './api'

export const authService = {
  async register(doctorData) {
    const { data } = await api.post('/auth/register', doctorData)
    return data
  },

  async sendOtp(email) {
    const { data } = await api.post('/auth/send-otp', { email })
    return data
  },

  async verifyOtp(email, otp) {
    const { data } = await api.post('/auth/verify-otp', { email, otp })
    return data
  },

  async login(email, password) {
    const { data } = await api.post('/auth/login', { email, password })
    localStorage.setItem('doctor_jwt_token', data.token)
    localStorage.setItem('doctor_profile', JSON.stringify(data.doctor))
    return data
  },

  async getMe() {
    const { data } = await api.get('/auth/me')
    return data
  },

  async forgotPassword(email) {
    // Not part of the requested backend endpoints (no POST /auth/forgot-password).
    // Kept as a stub so the existing Login page UI/flow keeps working unmodified.
    return new Promise((resolve) => {
      setTimeout(() => resolve({ message: `If an account exists for ${email}, a reset link has been sent.` }), 600)
    })
  },

  logout() {
    localStorage.removeItem('doctor_jwt_token')
    localStorage.removeItem('doctor_profile')
  },

  getCurrentDoctor() {
    const raw = localStorage.getItem('doctor_profile')
    return raw ? JSON.parse(raw) : null
  },

  isAuthenticated() {
    return !!localStorage.getItem('doctor_jwt_token')
  },

  verifyRole(requiredRole = 'doctor') {
    const doctor = authService.getCurrentDoctor()
    return doctor?.role === requiredRole
  },
}

export default authService
