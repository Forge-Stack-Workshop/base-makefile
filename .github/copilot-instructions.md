# Copilot Instructions - base-makefile

## Project Overview

This repository provides standard Makefile templates for Forge Stack Workshop projects.

## Guidelines

- Maintain backward compatibility
- Keep Makefile templates minimal and reusable
- Use `##` comments for help text
- Follow GNU Make best practices
- Test with both `make` and `make help`

## Makefile Standards

- Use `.DEFAULT_GOAL := help`
- Export environment variables with `export`
- Use `.PHONY` for all non-file targets
- Color code help output with ANSI escapes
