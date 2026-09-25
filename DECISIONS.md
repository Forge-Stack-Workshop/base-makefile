# DECISIONS — base-makefile (ADR log)

> Docs-only. ADRs reconstructed from code, `HANDOFF.md`, and git history. Status
> **Observed** = inferred from the repo, not from a written decision record.

## ADR-001 — Composable brick library over one flat Makefile
- **Status**: Observed / Accepted (FACT — implemented).
- **Context**: Projects previously shared flat templates (`examples/Makefile.*`).
- **Decision**: Split into a shared core + single-purpose bricks assembled by
  profiles; keep flat templates under `examples/` for projects that opt out.
- **Consequences**: reuse and per-stack composition; include order becomes a
  contract; a smoke-test gate is needed to keep all combinations valid.
- **Evidence**: `lib/`, `profiles/`, commit `31c95e2` "composable Make brick library".

## ADR-002 — `$(RUN)`-prefixed tool calls for host/container parity
- **Status**: Observed / Accepted (FACT).
- **Decision**: Every Python/JS tool call is prefixed `$(RUN)`; empty on host, a
  `docker compose run` wrapper in container mode (`runner.Makefile`). pre-commit
  is excluded (manages its own environments).
- **Consequences**: identical target names on host and in CI/containers; UID/GID
  passed to keep mounted files developer-owned.

## ADR-003 — Generated, comment-driven help as the default goal
- **Status**: Observed / Accepted (FACT).
- **Decision**: `## Description` comments generate grouped help; undocumented
  targets are hidden; documented targets are auto-`.PHONY`.
- **Consequences**: single source of truth for docs + phony declaration; forbids
  `$(VAR)` in help comments (static text only).

## ADR-004 — Canonical target names + tiers under the chrysa standard
- **Status**: Observed / Accepted (FACT per `HANDOFF.md`).
- **Decision**: Adopt `shared-standards` canonical names (`lint`/`format`/`test`/
  `typecheck`/`pre-commit`…) and `# makefile-tier:` markers; validate with
  `makefile-check`.
- **Consequences**: cross-repo consistency; non-blocking linter warnings remain.

## ADR-005 — Smoke-test as the CI correctness gate
- **Status**: Observed / Accepted (FACT).
- **Decision**: `validate-makefile` runs `scripts/smoke-test.sh`, failing on any
  non-zero exit **or** stderr (to catch `$(shell …)` errors make hides).
- **Consequences**: cheap, dependency-free validation of every profile+example.

## ADR-006 — Release created in the tagging run (CD fix)
- **Status**: Observed / Accepted (FACT — documented inline in `cd.yml`).
- **Decision**: Create the GitHub release in the same run that pushes the tag,
  because a token-pushed tag does not retrigger workflows. Idempotent; no
  force-push (released tags immutable).
- **Evidence**: `cd.yml` comments, commit `e6d5497`.

## Candidate bricks (PROPOSAL — from `HANDOFF.md`, now largely delivered)
`docker/build`, `ops/release`, `infra/helm`, `infra/terraform`, `docs/sphinx`,
`quality/coverage-gate`, `db/alembic` were listed as candidates; all are present
in `lib/` as of this snapshot.
