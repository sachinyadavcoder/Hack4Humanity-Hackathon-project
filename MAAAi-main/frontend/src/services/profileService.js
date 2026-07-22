import api from './api'

export const profileService = {
  async getProfile() {
    const { data } = await api.get('/profile')
    return data
  },

  async updateProfile(profileData) {
    const { data } = await api.put('/profile', profileData)
    return data
  },

  async changePassword(currentPassword, newPassword) {
    const { data } = await api.put('/profile/change-password', { currentPassword, newPassword })
    return data
  },
}

export default profileService
