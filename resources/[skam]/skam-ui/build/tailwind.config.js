/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        "primary": "var(--primary-color)",
        "primary-lighten": "var(--primary-color-lighten)",
        "custom-black": "#050505",
        "custom-gray": "#323443"
      }
    },
    keyframes: {
      message: {
        '0%': { transform: 'translateX(-3vh)', opacity: 0 },
        '100%': { transform: 'translateX(0vh)', opacity: 1 },
      },
      suggestions: {
        '0%': { transform: 'translateY(3vh)', opacity: 0 },
        '100%': { transform: 'translateY(0vh)', opacity: 1 },
      }
    },
    animation: {
      'message': 'message .5s',
      'suggestions': 'suggestions .5s',
    },
  },
  plugins: [],
}