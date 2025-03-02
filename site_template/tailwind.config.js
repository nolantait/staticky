// For importing tailwind styles from protos gem
import { execSync } from "child_process"
import typography from "@tailwindcss/typography"

const output = execSync("bundle show protos", { encoding: "utf-8" });
const protos_path = output.trim() + "/**/*.rb";

/** @type {import("tailwindcss").Config} */
const config = {
  content: [
    "./app/views/**/*.rb",
    "./lib/**/*.rb",
    protos_path
  ],
  plugins: [typography]
}

export default config
