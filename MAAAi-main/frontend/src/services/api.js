import axios from 'axios'

// Base Axios instance for the Doctor Dashboard.
// Points at the Express/MongoDB backend under backend/.
const api = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL || 'http://localhost:5000',
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json',
  },
})

api.interceptors.request.use((config) => {
  const token = localStorage.getItem('doctor_jwt_token')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

// Normalize backend error responses into plain Error objects with a
// readable .message, since every page reads err.message directly.
api.interceptors.response.use(
  (response) => response,
  (error) => {
    const message = error.response?.data?.message || error.message || 'Something went wrong. Please try again.'
    const normalized = new Error(message)
    normalized.status = error.response?.status
    normalized.data = error.response?.data
    return Promise.reject(normalized)
  }
)

export default api
