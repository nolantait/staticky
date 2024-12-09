import { defineConfig } from "vite"
import RubyPlugin from "vite-plugin-ruby"

export default defineConfig({
  server: { hmr: false },
  plugins: [
    RubyPlugin(),
  ],
})
