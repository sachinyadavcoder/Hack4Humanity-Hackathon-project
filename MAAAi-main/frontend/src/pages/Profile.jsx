import { useForm } from 'react-hook-form'
import { useState } from 'react'
import DashboardLayout from '../components/DashboardLayout'
import Card from '../components/Card'
import { useAuth } from '../context/AuthContext'
import profileService from '../services/profileService'

export default function Profile() {
  const { doctor, updateDoctor } = useAuth()
  const [saved, setSaved] = useState(false)
  const [serverError, setServerError] = useState('')

  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting },
  } = useForm({
    defaultValues: {
      name: doctor?.name || '',
      hospital: doctor?.hospital || '',
      specialization: doctor?.specialization || '',
      contact: doctor?.contact || '',
      language: doctor?.language || 'English',
    },
  })

  const onSubmit = async (data) => {
    setServerError('')
    try {
      const updated = await profileService.updateProfile(data)
      updateDoctor({ ...doctor, ...updated })
      setSaved(true)
      setTimeout(() => setSaved(false), 2000)
    } catch (err) {
      setServerError(err.message || 'Failed to update profile. Please try again.')
    }
  }

  return (
    <DashboardLayout>
      <div className="mb-6">
        <h1 className="font-display text-2xl font-bold text-ink-900">Profile</h1>
        <p className="text-sm text-ink-500 mt-1">Manage your doctor profile information.</p>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-5">
        <Card className="p-6 lg:col-span-1 h-fit text-center">
          <div className="w-20 h-20 rounded-full bg-primary-500 text-white flex items-center justify-center text-2xl font-display font-bold mx-auto mb-4">
            {doctor?.name?.split(' ').map((n) => n[0]).slice(0, 2).join('') || 'DR'}
          </div>
          <p className="font-display font-semibold text-lg text-ink-900">{doctor?.name}</p>
          <p className="text-sm text-ink-500 mt-0.5">{doctor?.specialization}</p>
          <p className="text-sm text-ink-500">{doctor?.hospital}</p>
        </Card>

        <Card title="Doctor Information" className="p-5 lg:col-span-2">
          <form onSubmit={handleSubmit(onSubmit)} className="space-y-4" noValidate>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-ink-700 mb-1">Name</label>
                <input
                  {...register('name', { required: 'Name is required' })}
                  className="w-full px-3 py-2.5 text-sm bg-white border border-surface-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-400"
                />
                {errors.name && <p className="text-xs text-risk-high mt-1">{errors.name.message}</p>}
              </div>
              <div>
                <label className="block text-sm font-medium text-ink-700 mb-1">Hospital</label>
                <input
                  {...register('hospital', { required: 'Hospital is required' })}
                  className="w-full px-3 py-2.5 text-sm bg-white border border-surface-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-400"
                />
                {errors.hospital && <p className="text-xs text-risk-high mt-1">{errors.hospital.message}</p>}
              </div>
              <div>
                <label className="block text-sm font-medium text-ink-700 mb-1">Specialization</label>
                <input
                  {...register('specialization', { required: 'Specialization is required' })}
                  className="w-full px-3 py-2.5 text-sm bg-white border border-surface-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-400"
                />
                {errors.specialization && <p className="text-xs text-risk-high mt-1">{errors.specialization.message}</p>}
              </div>
              <div>
                <label className="block text-sm font-medium text-ink-700 mb-1">Contact</label>
                <input
                  {...register('contact', { required: 'Contact is required' })}
                  className="w-full px-3 py-2.5 text-sm bg-white border border-surface-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-400"
                />
                {errors.contact && <p className="text-xs text-risk-high mt-1">{errors.contact.message}</p>}
              </div>
              <div>
                <label className="block text-sm font-medium text-ink-700 mb-1">Language</label>
                <select
                  {...register('language')}
                  className="w-full px-3 py-2.5 text-sm bg-white border border-surface-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-400"
                >
                  <option value="English">English</option>
                  <option value="Hindi">Hindi</option>
                  <option value="Marathi">Marathi</option>
                  <option value="Bengali">Bengali</option>
                </select>
              </div>
            </div>

            {saved && (
              <div className="bg-risk-normalBg text-risk-normal text-sm px-3.5 py-2.5 rounded-lg">
                Profile updated successfully.
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
              className="px-5 py-2.5 text-sm font-semibold text-white bg-primary-500 rounded-lg hover:bg-primary-600 disabled:opacity-60"
            >
              {isSubmitting ? 'Saving...' : 'Save Changes'}
            </button>
          </form>
        </Card>
      </div>
    </DashboardLayout>
  )
}
