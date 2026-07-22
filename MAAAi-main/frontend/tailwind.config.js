/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,jsx}",
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          50: '#EAF4F3',
          100: '#CFE6E4',
          200: '#9FCDC8',
          300: '#6FB4AD',
          400: '#3F9B91',
          500: '#0F5C5C',
          600: '#0D4F4F',
          700: '#0A3F3F',
          800: '#082F2F',
          900: '#052020',
        },
        risk: {
          normal: '#5FA88B',
          normalBg: '#E9F5EF',
          medium: '#E8B84B',
          mediumBg: '#FCF3DF',
          high: '#E8735C',
          highBg: '#FBE7E3',
        },
        surface: {
          bg: '#FAF8F5',
          card: '#FFFFFF',
          border: '#E7E2D9',
        },
        ink: {
          900: '#2A2E2E',
          700: '#4A4F4F',
          500: '#767C7C',
          300: '#A9AEAE',
        },
      },
      fontFamily: {
        display: ['Lexend', 'sans-serif'],
        body: ['Inter', 'sans-serif'],
      },
      boxShadow: {
        card: '0 1px 2px rgba(42, 46, 46, 0.04), 0 1px 8px rgba(42, 46, 46, 0.06)',
        cardHover: '0 4px 16px rgba(42, 46, 46, 0.10)',
      },
      borderRadius: {
        card: '14px',
      },
    },
  },
  plugins: [],
}
