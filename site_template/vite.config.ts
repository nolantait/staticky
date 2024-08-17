import { defineConfig } from "vite"
import RubyPlugin from "vite-plugin-ruby"
import FullReload from "vite-plugin-full-reload"

export default defineConfig({
  server: { hmr: false },
  plugins: [
    RubyPlugin(),
    FullReload(
      "build/index.html",
      { delay: 0 }
    ),
  ],
})
