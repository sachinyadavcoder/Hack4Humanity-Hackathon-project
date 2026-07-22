import { useEffect, useState } from 'react'
import { useForm } from 'react-hook-form'
import { useNavigate } from 'react-router-dom'
import { useAuth } from '../context/AuthContext'

const INSTITUTIONAL_EMAIL_PATTERN = /^\S+@\S+\.(org|in)$/i
const INSTITUTIONAL_EMAIL_ERROR = 'Please register using an approved institutional email address (.org or .in).'
const RESEND_COOLDOWN_SECONDS = 60

export default function Register() {
  const { register: registerDoctor, sendOtp, verifyOtp } = useAuth()
  const navigate = useNavigate()
  const [serverError, setServerError] = useState('')
  const [step, setStep] = useState('form') // 'form' | 'otp'
  const [pendingEmail, setPendingEmail] = useState('')
  const [cooldown, setCooldown] = useState(0)

  const {
    register,
    handleSubmit,
    watch,
    formState: { errors, isSubmitting },
  } = useForm()

  const {
    register: registerOtp,
    handleSubmit: handleOtpSubmit,
    formState: { errors: otpErrors, isSubmitting: isVerifying },
  } = useForm()

  const password = watch('password')

  useEffect(() => {
    if (cooldown <= 0) return
    const timer = setInterval(() => setCooldown((c) => Math.max(0, c - 1)), 1000)
    return () => clearInterval(timer)
  }, [cooldown])

  const onSubmit = async (data) => {
    setServerError('')
    try {
      await registerDoctor({
        name: data.name,
        email: data.email,
        password: data.password,
        confirmPassword: data.confirmPassword,
        hospital: data.hospital,
        specialization: data.specialization,
        registrationNumber: data.registrationNumber,
        phone: data.phone,
      })
      await sendOtp(data.email)
      setPendingEmail(data.email)
      setCooldown(RESEND_COOLDOWN_SECONDS)
      setStep('otp')
    } catch (err) {
      setServerError(err.message || 'Registration failed. Please try again.')
    }
  }

  const onVerifyOtp = async (data) => {
    setServerError('')
    try {
      await verifyOtp(pendingEmail, data.otp)
      navigate('/login', { state: { verified: true } })
    } catch (err) {
      setServerError(err.message || 'OTP verification failed. Please try again.')
    }
  }

  const handleResendOtp = async () => {
    if (cooldown > 0) return
    setServerError('')
    try {
      await sendOtp(pendingEmail)
      setCooldown(RESEND_COOLDOWN_SECONDS)
    } catch (err) {
      setServerError(err.message || 'Failed to resend OTP. Please try again.')
    }
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

          {step === 'form' ? (
            <>
              <div className="text-center mb-8">
                <h2 className="font-display text-3xl font-bold text-ink-900">Doctor Registration</h2>
              </div>

              <form onSubmit={handleSubmit(onSubmit)} className="space-y-4" noValidate>
                <div>
                  <label className="block text-sm font-medium text-ink-700 mb-1.5">Full Name</label>
                  <input
                    type="text"
                    placeholder="Dr. Ayesha Khan"
                    {...register('name', { required: 'Full name is required' })}
                    className="w-full px-3.5 py-2.5 text-sm bg-white border border-surface-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-400 focus:border-transparent"
                  />
                  {errors.name && <p className="text-xs text-risk-high mt-1">{errors.name.message}</p>}
                </div>

                <div>
                  <label className="block text-sm font-medium text-ink-700 mb-1.5">Email address</label>
                  <input
                    type="email"
                    placeholder="doctor@hospital.in"
                    {...register('email', {
                      required: 'Email is required',
                      pattern: { value: INSTITUTIONAL_EMAIL_PATTERN, message: INSTITUTIONAL_EMAIL_ERROR },
                    })}
                    className="w-full px-3.5 py-2.5 text-sm bg-white border border-surface-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-400 focus:border-transparent"
                  />
                  {errors.email && <p className="text-xs text-risk-high mt-1">{errors.email.message}</p>}
                  <p className="text-xs text-ink-500 mt-1">Only institutional emails ending in .org or .in are accepted.</p>
                </div>

                <div>
                  <label className="block text-sm font-medium text-ink-700 mb-1.5">Hospital Name</label>
                  <input
                    type="text"
                    placeholder="District Women & Child Hospital"
                    {...register('hospital', { required: 'Hospital name is required' })}
                    className="w-full px-3.5 py-2.5 text-sm bg-white border border-surface-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-400 focus:border-transparent"
                  />
                  {errors.hospital && <p className="text-xs text-risk-high mt-1">{errors.hospital.message}</p>}
                </div>

                <div>
                  <label className="block text-sm font-medium text-ink-700 mb-1.5">Specialization</label>
                  <input
                    type="text"
                    placeholder="Obstetrics & Gynaecology"
                    {...register('specialization', { required: 'Specialization is required' })}
                    className="w-full px-3.5 py-2.5 text-sm bg-white border border-surface-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-400 focus:border-transparent"
                  />
                  {errors.specialization && <p className="text-xs text-risk-high mt-1">{errors.specialization.message}</p>}
                </div>

                <div>
                  <label className="block text-sm font-medium text-ink-700 mb-1.5">Medical Registration Number</label>
                  <input
                    type="text"
                    placeholder="MCI-123456"
                    {...register('registrationNumber', { required: 'Medical registration number is required' })}
                    className="w-full px-3.5 py-2.5 text-sm bg-white border border-surface-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-400 focus:border-transparent"
                  />
                  {errors.registrationNumber && <p className="text-xs text-risk-high mt-1">{errors.registrationNumber.message}</p>}
                </div>

                <div>
                  <label className="block text-sm font-medium text-ink-700 mb-1.5">Phone Number</label>
                  <input
                    type="tel"
                    placeholder="+91 98765 43210"
                    {...register('phone', {
                      required: 'Phone number is required',
                      pattern: { value: /^[+\d][\d\s-]{7,}$/, message: 'Enter a valid phone number' },
                    })}
                    className="w-full px-3.5 py-2.5 text-sm bg-white border border-surface-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-400 focus:border-transparent"
                  />
                  {errors.phone && <p className="text-xs text-risk-high mt-1">{errors.phone.message}</p>}
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

                <div>
                  <label className="block text-sm font-medium text-ink-700 mb-1.5">Confirm Password</label>
                  <input
                    type="password"
                    placeholder="••••••••"
                    {...register('confirmPassword', {
                      required: 'Please confirm your password',
                      validate: (value) => value === password || 'Passwords do not match',
                    })}
                    className="w-full px-3.5 py-2.5 text-sm bg-white border border-surface-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-400 focus:border-transparent"
                  />
                  {errors.confirmPassword && <p className="text-xs text-risk-high mt-1">{errors.confirmPassword.message}</p>}
                </div>

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
                  {isSubmitting ? 'Registering...' : 'Register'}
                </button>

                <p className="text-sm text-center text-ink-500">
                  Already have an account?{' '}
                  <button
                    type="button"
                    onClick={() => navigate('/login')}
                    className="text-primary-600 font-semibold hover:text-primary-700"
                  >
                    Sign In
                  </button>
                </p>
              </form>
            </>
          ) : (
            <>
              <div className="text-center mb-8">
                <h2 className="font-display text-3xl font-bold text-ink-900">Verify Your Email</h2>
                <p className="text-sm text-ink-500 mt-2">
                  We sent a 6-digit code to <span className="font-medium text-ink-700">{pendingEmail}</span>. It expires in 5 minutes.
                </p>
              </div>

              <form onSubmit={handleOtpSubmit(onVerifyOtp)} className="space-y-4" noValidate>
                <div>
                  <label className="block text-sm font-medium text-ink-700 mb-1.5">Verification Code</label>
                  <input
                    type="text"
                    inputMode="numeric"
                    maxLength={6}
                    placeholder="123456"
                    {...registerOtp('otp', {
                      required: 'Verification code is required',
                      pattern: { value: /^\d{6}$/, message: 'Enter the 6-digit code' },
                    })}
                    className="w-full px-3.5 py-2.5 text-sm text-center tracking-[0.5em] font-semibold bg-white border border-surface-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-400 focus:border-transparent"
                  />
                  {otpErrors.otp && <p className="text-xs text-risk-high mt-1">{otpErrors.otp.message}</p>}
                </div>

                {serverError && (
                  <div className="bg-risk-highBg text-[#B8412D] text-sm px-3.5 py-2.5 rounded-lg">
                    {serverError}
                  </div>
                )}

                <button
                  type="submit"
                  disabled={isVerifying}
                  className="w-full py-2.5 bg-primary-500 text-white text-sm font-semibold rounded-lg hover:bg-primary-600 transition-colors disabled:opacity-60"
                >
                  {isVerifying ? 'Verifying...' : 'Verify & Continue'}
                </button>

                <p className="text-sm text-center text-ink-500">
                  Didn't receive the code?{' '}
                  <button
                    type="button"
                    onClick={handleResendOtp}
                    disabled={cooldown > 0}
                    className="text-primary-600 font-semibold hover:text-primary-700 disabled:text-ink-300 disabled:cursor-not-allowed"
                  >
                    {cooldown > 0 ? `Resend in ${cooldown}s` : 'Resend OTP'}
                  </button>
                </p>

                <button
                  type="button"
                  onClick={() => setStep('form')}
                  className="w-full py-2.5 text-sm font-semibold text-ink-700 border border-surface-border rounded-lg hover:bg-surface-bg"
                >
                  Back to Registration
                </button>
              </form>
            </>
          )}
        </div>
      </div>
    </div>
  )
}
