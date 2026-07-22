import { useForm } from 'react-hook-form'
import { useState } from 'react'
import DashboardLayout from '../components/DashboardLayout'
import Card from '../components/Card'
import profileService from '../services/profileService'

export default function Settings() {
  const [theme, setTheme] = useState('light')
  const [language, setLanguage] = useState('English')
  const [prefs, setPrefs] = useState({
    highRiskAlerts: true,
    followUpReminders: true,
    reportUploads: false,
    missedAppointments: true,
  })
  const [passwordSaved, setPasswordSaved] = useState(false)
  const [passwordError, setPasswordError] = useState('')

  const {
    register,
    handleSubmit,
    watch,
    reset,
    formState: { errors, isSubmitting },
  } = useForm()

  const newPassword = watch('newPassword')

  const onChangePassword = async (data) => {
    setPasswordError('')
    try {
      await profileService.changePassword(data.currentPassword, data.newPassword)
      setPasswordSaved(true)
      reset()
      setTimeout(() => setPasswordSaved(false), 2000)
    } catch (err) {
      setPasswordError(err.message || 'Failed to change password. Please try again.')
    }
  }

  const togglePref = (key) => setPrefs((p) => ({ ...p, [key]: !p[key] }))

  return (
    <DashboardLayout>
      <div className="mb-6">
        <h1 className="font-display text-2xl font-bold text-ink-900">Settings</h1>
        <p className="text-sm text-ink-500 mt-1">Manage your preferences and account security.</p>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-5">
        <Card title="Theme" className="p-5">
          <div className="flex gap-3">
            {['light', 'dark'].map((t) => (
              <button
                key={t}
                onClick={() => setTheme(t)}
                className={`flex-1 py-3 rounded-lg border text-sm font-medium capitalize transition-colors ${
                  theme === t ? 'border-primary-500 bg-primary-50 text-primary-700' : 'border-surface-border text-ink-700 hover:bg-surface-bg'
                }`}
              >
                {t === 'light' ? '☀️' : '🌙'} {t}
              </button>
            ))}
          </div>
         
        </Card>

        <Card title="Language" className="p-5">
          <select
            value={language}
            onChange={(e) => setLanguage(e.target.value)}
            className="w-full px-3 py-2.5 text-sm bg-white border border-surface-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-400"
          >
            <option value="English">English</option>
            <option value="Hindi">Hindi</option>
            <option value="Marathi">Marathi</option>
            <option value="Bengali">Bengali</option>
          </select>
          
        </Card>

        <Card title="Notification Preferences" className="p-5">
          <div className="space-y-3">
            <PrefToggle label="New High-Risk Patient Alerts" checked={prefs.highRiskAlerts} onChange={() => togglePref('highRiskAlerts')} />
            <PrefToggle label="Follow-up Reminders" checked={prefs.followUpReminders} onChange={() => togglePref('followUpReminders')} />
            <PrefToggle label="Report Upload Notifications" checked={prefs.reportUploads} onChange={() => togglePref('reportUploads')} />
            <PrefToggle label="Missed Appointment Alerts" checked={prefs.missedAppointments} onChange={() => togglePref('missedAppointments')} />
          </div>
        </Card>

        <Card title="Change Password" className="p-5">
          <form onSubmit={handleSubmit(onChangePassword)} className="space-y-4" noValidate>
            <div>
              <label className="block text-sm font-medium text-ink-700 mb-1">Current Password</label>
              <input
                type="password"
                {...register('currentPassword', { required: 'Current password is required' })}
                className="w-full px-3 py-2.5 text-sm bg-white border border-surface-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-400"
              />
              {errors.currentPassword && <p className="text-xs text-risk-high mt-1">{errors.currentPassword.message}</p>}
            </div>
            <div>
              <label className="block text-sm font-medium text-ink-700 mb-1">New Password</label>
              <input
                type="password"
                {...register('newPassword', {
                  required: 'New password is required',
                  minLength: { value: 6, message: 'Password must be at least 6 characters' },
                })}
                className="w-full px-3 py-2.5 text-sm bg-white border border-surface-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-400"
              />
              {errors.newPassword && <p className="text-xs text-risk-high mt-1">{errors.newPassword.message}</p>}
            </div>
            <div>
              <label className="block text-sm font-medium text-ink-700 mb-1">Confirm New Password</label>
              <input
                type="password"
                {...register('confirmPassword', {
                  required: 'Please confirm your new password',
                  validate: (v) => v === newPassword || 'Passwords do not match',
                })}
                className="w-full px-3 py-2.5 text-sm bg-white border border-surface-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-400"
              />
              {errors.confirmPassword && <p className="text-xs text-risk-high mt-1">{errors.confirmPassword.message}</p>}
            </div>

            {passwordSaved && (
              <div className="bg-risk-normalBg text-risk-normal text-sm px-3.5 py-2.5 rounded-lg">
                Password changed successfully.
              </div>
            )}

            {passwordError && (
              <div className="bg-risk-highBg text-[#B8412D] text-sm px-3.5 py-2.5 rounded-lg">
                {passwordError}
              </div>
            )}

            <button
              type="submit"
              disabled={isSubmitting}
              className="px-5 py-2.5 text-sm font-semibold text-white bg-primary-500 rounded-lg hover:bg-primary-600 disabled:opacity-60"
            >
              {isSubmitting ? 'Updating...' : 'Update Password'}
            </button>
          </form>
        </Card>
      </div>
    </DashboardLayout>
  )
}

function PrefToggle({ label, checked, onChange }) {
  return (
    <label className="flex items-center justify-between cursor-pointer">
      <span className="text-sm text-ink-700">{label}</span>
      <button
        type="button"
        onClick={onChange}
        className={`w-10 h-6 rounded-full transition-colors relative flex-shrink-0 ${checked ? 'bg-primary-500' : 'bg-surface-border'}`}
      >
        <span className={`absolute top-0.5 w-5 h-5 rounded-full bg-white transition-transform ${checked ? 'translate-x-[18px]' : 'translate-x-0.5'}`} />
      </button>
    </label>
  )
}
