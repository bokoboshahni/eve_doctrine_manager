/* eslint-env node, mocha */

const colors = require("tailwindcss/colors")
const defaultTheme = require("tailwindcss/defaultTheme")

/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./app/views/**/*.html.erb",
    "./app/helpers/**/*.rb",
    "./app/assets/stylesheets/**/*.css",
    "./app/javascript/**/*.{js,ts}",
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ["Inter", ...defaultTheme.fontFamily.sans],
        mono: ['"Source Code Pro"', ...defaultTheme.fontFamily.mono],
      },
      fontSize: {
        "2xs": [".625rem", { lineHeight: ".75rem" }],
        md: ["1rem", { lineHeight: "1.5rem" }],
      },
      opacity: {
        "elevation-1": ".05",
        "elevation-2": ".08",
        "elevation-3": ".11",
        "elevation-4": ".12",
        "elevation-5": ".14",
        hover: ".08",
        focus: ".12",
        press: ".12",
        drag: ".16",
        "disabled-container": ".12",
        "disabled-content": ".38",
      },
      margin: {
        50: ".125rem",
        75: ".25rem",
        100: ".5rem",
        200: ".75rem",
        300: "1rem",
        400: "1.5rem",
        500: "2rem",
        600: "2.5rem",
        700: "3rem",
        800: "4rem",
        900: "5rem",
        1000: "6rem",
      },
      padding: {
        50: ".125rem",
        75: ".25rem",
        100: ".5rem",
        200: ".75rem",
        300: "1rem",
        400: "1.5rem",
        500: "2rem",
        600: "2.5rem",
        700: "3rem",
        800: "4rem",
        900: "5rem",
        1000: "6rem",
      },
      spacing: {
        50: ".125rem",
        75: ".25rem",
        100: ".5rem",
        200: ".75rem",
        300: "1rem",
        400: "1.5rem",
        500: "2rem",
        600: "2.5rem",
        700: "3rem",
        800: "4rem",
        900: "5rem",
        1000: "6rem",
      },
      borderRadius: {
        xs: ".25rem",
        sm: ".5rem",
        md: ".75rem",
        lg: "1rem",
        xl: "1.5rem",
      },
      colors: {
        primary: colors.cyan,
        secondary: colors.slate,
        tertiary: colors.teal,
      },
    },
  },
}
