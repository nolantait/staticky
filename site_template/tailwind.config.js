import defaultTheme from "tailwindcss/defaultTheme"

// For importing tailwind styles from protos gem
const execSync = require('child_process').execSync;
const output = execSync('bundle show protos', { encoding: 'utf-8' });
const protos_path = output.trim() + '/**/*.rb';

/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./app/**/*.rb",
    "./lib/**/*.rb",
    protos_path
  ],
  theme: {
    fontFamily: {
      ...defaultTheme.fontFamily,
      sans: ["Inter Variable", ...defaultTheme.fontFamily.sans],
    },
    boxShadow: {
      sm: "var(--box-shadow-sm)",
      md: "var(--box-shadow-md)",
      lg: "var(--box-shadow-lg)"
    },
    extend: {
      colors: {
        "base-400": "#1e2227",
      },
      spacing: {
        xs: "var(--spacing-xs)",
        sm: "var(--spacing-sm)",
        md: "var(--spacing-md)",
        lg: "var(--spacing-lg)",
        xl: "var(--spacing-xl)",
      },
      gap: {
        xs: "var(--spacing-gap-xs)",
        sm: "var(--spacing-gap-sm)",
        md: "var(--spacing-gap-md)",
        lg: "var(--spacing-gap-lg)",
        xl: "var(--spacing-gap-xl)",
      },
    },
  },
  daisyui: {
    themes: [
      {
        onedark: {
          "primary": "#61afef",
          "secondary": "#e5c07b",
          "accent": "#c678dd",
          "neutral": "#545862",
          "neutral-content": "#c8ccd4",
          "base-100": "#3e4451",
          "base-200": "#353b45",
          "base-300": "#282c34",
          "base-content": "#b6bdca",
          "info": "#61afef",
          "success": "#98c379",
          "warning": "#e5c07b",
          "error": "#e06c75",

          "--rounded-box": "0.5rem", // border radius rounded-box utility class, used in card and other large boxes
          "--rounded-btn": "0.25rem", // border radius rounded-btn utility class, used in buttons and similar element
          "--rounded-badge": "1rem", // border radius rounded-badge utility class, used in badges and similar
          "--animation-btn": "0.25s", // duration of animation when you click on button
          "--animation-input": "0.2s", // duration of animation for inputs like checkbox, toggle, radio, etc
          "--btn-text-case": "uppercase", // set default text transform for buttons
          "--btn-focus-scale": "0.95", // scale transform of button when you focus on it
          "--border-btn": "1px", // border width of buttons
          "--tab-border": "1px", // border width of tabs
          "--tab-radius": "0.25rem", // border radius of tabs
        },
      },
    ]
  },
  plugins: [
    require("daisyui"),
    require('@tailwindcss/typography'),
    require("./frontend/tailwindcss/variable_font_plugin"),
  ],
}

