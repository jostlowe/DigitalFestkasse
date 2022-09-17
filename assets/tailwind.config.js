// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

let plugin = require('tailwindcss/plugin')

module.exports = {
  content: [
    './js/**/*.js',
    '../lib/*_web.ex',
    '../lib/*_web/**/*.*ex'
  ],
  theme: {
    fontFamily: {
      'roboto': ['Roboto Slab', 'serif'],
      'caveat': ['Caveat Brush', 'serif'],
    },
    extend: {
      colors: {
        RegiWhite: '#f5f4f4',
        RegiGrey: '#9c9c9c',
        RegiYellow: '#fab53a',
        RegiBlack: '#171717',
        RegiGreen: '#27ae60',
        RegiRod: '#de6057'
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    plugin(({ addVariant }) => addVariant('phx-no-feedback', ['&.phx-no-feedback', '.phx-no-feedback &'])),
    plugin(({ addVariant }) => addVariant('phx-click-loading', ['&.phx-click-loading', '.phx-click-loading &'])),
    plugin(({ addVariant }) => addVariant('phx-submit-loading', ['&.phx-submit-loading', '.phx-submit-loading &'])),
    plugin(({ addVariant }) => addVariant('phx-change-loading', ['&.phx-change-loading', '.phx-change-loading &']))
  ]
}
