#!/usr/bin/env node
/**
 * Makefile syntax check — PostToolUse hook (file writes).
 *
 * After Claude edits a brick under `makefiles/` or a profile (`Makefile.*`),
 * dry-run every root profile's `help` target (same check as
 * `scripts/smoke-test.sh` / CI's `validate-makefile`) so a broken recipe
 * (bad tab/space, unescaped parens, undefined var) surfaces immediately
 * instead of only when a consumer repo runs it.
 *
 * Hook type: PostToolUse — target: Write, Edit, MultiEdit
 * Does NOT block (informative only — exit 0). Prints warnings to stderr.
 */

"use strict";

const { execFileSync } = require("child_process");
const fs = require("fs");
const path = require("path");

function readStdin() {
  try {
    return JSON.parse(fs.readFileSync(0, "utf8"));
  } catch {
    return {};
  }
}

function isMakeRelated(filePath) {
  return /\/makefiles\/.+\.Makefile$/.test(filePath) || /(^|\/)Makefile\.[^/]+$/.test(filePath);
}

function findProfiles(repoRoot) {
  return fs
    .readdirSync(repoRoot)
    .filter((name) => /^Makefile\.[^/]+$/.test(name));
}

function main() {
  const input = readStdin();
  const filePath = input.tool_input?.file_path || input.tool_input?.path || "";
  if (!filePath || !isMakeRelated(filePath)) {
    process.exit(0);
  }

  const repoRoot = process.cwd();
  const failures = [];
  for (const profile of findProfiles(repoRoot)) {
    try {
      const stderr = execFileSync("make", ["-n", "-f", profile, "help"], {
        cwd: repoRoot,
        stdio: ["ignore", "ignore", "pipe"],
      });
      if (stderr && stderr.toString().trim()) {
        failures.push(`${profile}: stderr not empty:\n${stderr.toString()}`);
      }
    } catch (error) {
      failures.push(`${profile}: make exited non-zero:\n${error.stderr || error.message}`);
    }
  }

  if (failures.length > 0) {
    process.stderr.write(`[makefile-syntax-check] ${failures.join("\n")}\n`);
  }
  process.exit(0);
}

main();
