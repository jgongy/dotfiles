"use strict";

const main = "/tmp/ags/main.js"
const entry = `${App.configDir}/main.ts`
const bundler = "esbuild"

try {
  await Utils.execAsync([
    "esbuild", "--bundle", entry,
    "--format=esm",
    `--outfile=${main}`,
  ]);

  await import(`file://${main}`)
} catch (error) {
  console.error(error)
  App.quit()
}
