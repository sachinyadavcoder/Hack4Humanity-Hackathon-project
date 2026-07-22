import { useState } from 'react'
import { useForm } from 'react-hook-form'
import { useNavigate, useLocation } from 'react-router-dom'
import { useAuth } from '../context/AuthContext'
import authService from '../services/authService'

export default function Login() {
  const { login } = useAuth()
  const navigate = useNavigate()
  const location = useLocation()
  const [serverError, setServerError] = useState('')
  const [mode, setMode] = useState('login') // 'login' | 'forgot'
  const [resetMessage, setResetMessage] = useState('')

  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting },
  } = useForm()

  const {
    register: registerReset,
    handleSubmit: handleResetSubmit,
    formState: { errors: resetErrors, isSubmitting: isResetting },
  } = useForm()

  const onSubmit = async (data) => {
    setServerError('')
    try {
      await login(data.email, data.password)
      navigate('/dashboard')
    } catch (err) {
      setServerError(err.message || 'Login failed. Please try again.')
    }
  }

  const onResetSubmit = async (data) => {
    setResetMessage('')
    const result = await authService.forgotPassword(data.resetEmail)
    setResetMessage(result.message)
  }

  return (
    <div className="min-h-screen flex bg-surface-bg">
      {/* Left brand panel */}
      <div className="hidden lg:flex lg:w-5/12 bg-primary-700 text-white flex-col justify-between p-12 relative overflow-hidden">
        <div className="absolute -bottom-24 -right-24 w-96 h-96 rounded-full bg-primary-600/40" />
        <div className="absolute top-1/3 -left-16 w-64 h-64 rounded-full bg-primary-800/50" />

        <div className="relative z-10 flex items-center gap-3">
          <div className="w-10 h-10 rounded-xl bg-white/10 flex items-center justify-center text-xl">🩺</div>
          <span className="font-display font-semibold text-lg">MAAAi</span>
        </div>

        <div className="relative z-10">
          <h1 className="font-display text-3xl font-bold leading-tight mb-4">
            AI-Assisted Maternal<br />
            Healthcare Platform
          </h1>

          <p className="text-primary-100/80 text-sm leading-relaxed max-w-sm">
            Monitor pregnancies, review AI-generated risk assessments,
            manage patient records, schedule follow-ups, and coordinate
            with ASHA workers—all from one unified dashboard.
          </p>
        </div>

        <p className="relative z-10 text-xs text-primary-100/60">
          © {new Date().getFullYear()} MAAAi. For clinical use by verified doctors only.
        </p>
      </div>

      {/* Right form panel */}
      <div className="flex-1 flex items-center justify-center p-6 sm:p-10">
        <div className="w-full max-w-sm">
          <div className="lg:hidden flex items-center gap-2.5 mb-8">
            <div className="w-9 h-9 rounded-lg bg-primary-500 flex items-center justify-center text-white text-lg">🩺</div>
            <span className="font-display font-semibold text-lg text-ink-900">MAAAi</span>
          </div>

          {mode === 'login' ? (
            <>
              <div className="text-center mb-8">
                <h2 className="font-display text-3xl font-bold text-ink-900">Doctor Portal</h2>
              </div>


              <form onSubmit={handleSubmit(onSubmit)} className="space-y-4" noValidate>
                <div>
                  <label className="block text-sm font-medium text-ink-700 mb-1.5">Email address</label>
                  <input
                    type="email"
                    placeholder="doctor@hospital.in"
                    {...register('email', {
                      required: 'Email is required',
                      pattern: { value: /^\S+@\S+\.\S+$/, message: 'Enter a valid email address' },
                    })}
                    className="w-full px-3.5 py-2.5 text-sm bg-white border border-surface-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-400 focus:border-transparent"
                  />
                  {errors.email && <p className="text-xs text-risk-high mt-1">{errors.email.message}</p>}
                </div>

                <div>
                  <label className="block text-sm font-medium text-ink-700 mb-1.5">Password</label>
                  <input
                    type="password"
                    placeholder="••••••••"
                    {...register('password', {
                      required: 'Password is required',
                      minLength: { value: 6, message: 'Password must be at least 6 characters' },
                    })}
                    className="w-full px-3.5 py-2.5 text-sm bg-white border border-surface-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-400 focus:border-transparent"
                  />
                  {errors.password && <p className="text-xs text-risk-high mt-1">{errors.password.message}</p>}
                </div>

                <div className="flex items-center justify-between text-sm">
                  <label className="flex items-center gap-2 text-ink-700">
                    <input type="checkbox" className="rounded border-surface-border text-primary-500 focus:ring-primary-400" />
                    Remember me
                  </label>
                  <button
                    type="button"
                    onClick={() => setMode('forgot')}
                    className="text-primary-600 font-medium hover:text-primary-700"
                  >
                    Forgot password?
                  </button>
                </div>

                {location.state?.verified && !serverError && (
                  <div className="bg-risk-normalBg text-risk-normal text-sm px-3.5 py-2.5 rounded-lg">
                    Email verified successfully. You can now sign in.
                  </div>
                )}

                {serverError && (
                  <div className="bg-risk-highBg text-[#B8412D] text-sm px-3.5 py-2.5 rounded-lg">
                    {serverError}
                  </div>
                )}

                <button
                  type="submit"
                  disabled={isSubmitting}
                  className="w-full py-2.5 bg-primary-500 text-white text-sm font-semibold rounded-lg hover:bg-primary-600 transition-colors disabled:opacity-60"
                >
                  {isSubmitting ? 'Signing in...' : 'Sign In'}
                </button>

                <p className="text-sm text-center text-ink-500">
                  Don't have an account?{' '}
                  <button
                    type="button"
                    onClick={() => navigate('/register')}
                    className="text-primary-600 font-semibold hover:text-primary-700"
                  >
                    Register
                  </button>
                </p>
              </form>
            </>
          ) : (
            <>
              <h2 className="font-display text-2xl font-bold text-ink-900 mb-1">Reset Password</h2>
              <p className="text-sm text-ink-500 mb-7">
                Enter your registered email and we'll send a reset link.
              </p>

              <form onSubmit={handleResetSubmit(onResetSubmit)} className="space-y-4" noValidate>
                <div>
                  <label className="block text-sm font-medium text-ink-700 mb-1.5">Email address</label>
                  <input
                    type="email"
                    placeholder="doctor@hospital.in"
                    {...registerReset('resetEmail', {
                      required: 'Email is required',
                      pattern: { value: /^\S+@\S+\.\S+$/, message: 'Enter a valid email address' },
                    })}
                    className="w-full px-3.5 py-2.5 text-sm bg-white border border-surface-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-400 focus:border-transparent"
                  />
                  {resetErrors.resetEmail && <p className="text-xs text-risk-high mt-1">{resetErrors.resetEmail.message}</p>}
                </div>

                {resetMessage && (
                  <div className="bg-risk-normalBg text-risk-normal text-sm px-3.5 py-2.5 rounded-lg">
                    {resetMessage}
                  </div>
                )}

                <button
                  type="submit"
                  disabled={isResetting}
                  className="w-full py-2.5 bg-primary-500 text-white text-sm font-semibold rounded-lg hover:bg-primary-600 transition-colors disabled:opacity-60"
                >
                  {isResetting ? 'Sending...' : 'Send Reset Link'}
                </button>

                <button
                  type="button"
                  onClick={() => { setMode('login'); setResetMessage('') }}
                  className="w-full py-2.5 text-sm font-semibold text-ink-700 border border-surface-border rounded-lg hover:bg-surface-bg"
                >
                  Back to Sign In
                </button>
              </form>
            </>
          )}
        </div>
      </div>
    </div>
  )
}
