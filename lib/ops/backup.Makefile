#!make
# ─────────────────────────────────────────────────────────────────────────────
# ops/backup — dated archive of a source directory, and restore.
# BACKUP_SRC = what to archive, BACKUP_DIR = where archives land.
# ─────────────────────────────────────────────────────────────────────────────

.PHONY: backup restore

BACKUP_SRC ?= $(SRC_DIR)
BACKUP_DIR ?= backups

backup: ## Create a dated tar.gz of the source dir in the backups dir
	@mkdir -p $(BACKUP_DIR)
	@archive="$(BACKUP_DIR)/backup_$$(date +%Y%m%d_%H%M%S).tar.gz"; \
	tar --exclude-vcs -czf "$$archive" $(BACKUP_SRC) \
		&& printf "$(COLOR_GREEN)✔ %s$(COLOR_RESET)\n" "created $$archive"

restore: check-defined-archive ## Restore a backup archive => [archive={path}]
	$(call confirm_destructive,This overwrites files from $(archive).)
	@tar -xzf "$(archive)"
	$(call log-ok,restored from $(archive))
