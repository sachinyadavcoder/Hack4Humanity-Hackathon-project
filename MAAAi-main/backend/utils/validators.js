const EMAIL_REGEX = /^\S+@\S+\.\S+$/
const ALLOWED_EMAIL_SUFFIXES = ['.org', '.in']

export function isValidEmailFormat(email) {
  return typeof email === 'string' && EMAIL_REGEX.test(email)
}

export function isInstitutionalEmail(email) {
  if (!isValidEmailFormat(email)) return false
  const domain = email.toLowerCase().split('@')[1] || ''
  return ALLOWED_EMAIL_SUFFIXES.some((suffix) => domain.endsWith(suffix))
}

export const INSTITUTIONAL_EMAIL_ERROR =
  'Please register using an approved institutional email address (.org or .in).'

export function isStrongEnoughPassword(password) {
  return typeof password === 'string' && password.length >= 6
}
