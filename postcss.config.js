module.exports = {
  plugins: [
    require('tailwindcss')('./app/javascript/packs/tailwind.config.js'), // 追加
    require('autoprefixer'),                                             // 追加
    require('postcss-import'),
    require('postcss-flexbugs-fixes'),
    require('postcss-preset-env')({
      autoprefixer: {
        flexbox: 'no-2009'
      },
      stage: 3
    })
  ]
}
