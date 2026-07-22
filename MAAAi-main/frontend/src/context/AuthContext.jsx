import { createContext, useContext, useEffect, useState } from 'react'
import authService from '../services/authService'

const AuthContext = createContext(null)

export function AuthProvider({ children }) {
  const [doctor, setDoctor] = useState(null)
  const [isLoading, setIsLoading] = useState(true)

  useEffect(() => {
    async function verifySession() {
      if (!authService.isAuthenticated()) {
        setIsLoading(false)
        return
      }
      // A token sitting in localStorage doesn't mean it's still valid — verify
      // it against the backend before trusting it. If verification fails (backend
      // down, expired/invalid token, etc.), treat the user as logged out rather
      // than silently letting them into protected pages with broken data.
      try {
        const doctorData = await authService.getMe()
        setDoctor(doctorData)
      } catch (err) {
        authService.logout()
        setDoctor(null)
      } finally {
        setIsLoading(false)
      }
    }
    verifySession()
  }, [])

  const login = async (email, password) => {
    const result = await authService.login(email, password)
    setDoctor(result.doctor)
    return result
  }

  // Registration no longer auto-logs the doctor in: the backend creates the
  // account as unverified and requires OTP verification before login works.
  const register = async (doctorData) => {
    return authService.register(doctorData)
  }

  const sendOtp = async (email) => {
    return authService.sendOtp(email)
  }

  const verifyOtp = async (email, otp) => {
    return authService.verifyOtp(email, otp)
  }

  const logout = () => {
    authService.logout()
    setDoctor(null)
  }

  // Syncs an updated doctor object (e.g. after a profile edit) into both
  // context state and localStorage, without requiring a re-login.
  const updateDoctor = (updatedDoctor) => {
    setDoctor(updatedDoctor)
    localStorage.setItem('doctor_profile', JSON.stringify(updatedDoctor))
  }

  const value = {
    doctor,
    isLoading,
    isAuthenticated: !!doctor,
    login,
    register,
    sendOtp,
    verifyOtp,
    logout,
    updateDoctor,
  }

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>
}

export function useAuth() {
  const ctx = useContext(AuthContext)
  if (!ctx) throw new Error('useAuth must be used within AuthProvider')
  return ctx
}
