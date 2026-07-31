# base-makefile — GitHub Copilot Instructions

## Mandatory Workflow

1. Read `.github/instructions/*.instructions.md` when present.
2. Read `CLAUDE.md` for repository context.
3. Follow repository-local conventions before writing code.

## Project Context

**Stack:** Mixed / to document
**Purpose:** [![CI](https://github.com/Forge-Stack-Workshop/base-makefile/actions/workflows/ci.yml/badge.svg)](https://github.com/Forge-Stack-Workshop/base-makefile/actions/workflows/ci.yml).

## Engineering Rules

- Write in English: code, comments, docs, issues, PRs and commits.
- Keep changes minimal and aligned with the existing style.
- Do not add unrelated refactors or speculative improvements.
- Prefer make targets when available instead of invoking tooling ad hoc.
- Never commit secrets, credentials or environment-specific values.
