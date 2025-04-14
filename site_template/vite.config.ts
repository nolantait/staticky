import { defineConfig } from "vite"
import RubyPlugin from "vite-plugin-ruby"
import tailwindcss from "@tailwindcss/vite"

export default defineConfig({
  server: { hmr: false },
  clearScreen: false,
  plugins: [
    tailwindcss(),
    RubyPlugin(),
  ],
})
