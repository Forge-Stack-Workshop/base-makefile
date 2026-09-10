#!make
# ─────────────────────────────────────────────────────────────────────────────
# unity/unity — Unity project automation via the Unity CLI (batch mode).
# UNITY = path to the Unity executable (override per machine / CI image).
# UNITY_PROJECT = project path (default: repo root). Logs go to the reports dir.
# ─────────────────────────────────────────────────────────────────────────────

.PHONY: unity-tests unity-tests-play unity-build unity-license

UNITY         ?= unity
UNITY_PROJECT ?= .
UNITY_PLATFORM ?= StandaloneLinux64
UNITY_BUILD_METHOD ?= BuildScript.PerformBuild
UNITY_BASE = $(UNITY) -batchmode -nographics -projectPath $(UNITY_PROJECT)

unity-tests: ## Run EditMode tests headless
	@mkdir -p $(REPORTS_DIR)
	@$(UNITY_BASE) -runTests -testPlatform EditMode \
		-testResults $(REPORTS_DIR)/unity-editmode.xml -logFile -

unity-tests-play: ## Run PlayMode tests headless
	@mkdir -p $(REPORTS_DIR)
	@$(UNITY_BASE) -runTests -testPlatform PlayMode \
		-testResults $(REPORTS_DIR)/unity-playmode.xml -logFile -

unity-build: ## Build the player => [UNITY_PLATFORM={target}]
	@$(UNITY_BASE) -quit -executeMethod $(UNITY_BUILD_METHOD) \
		-buildTarget $(UNITY_PLATFORM) -logFile -

unity-license: ## Activate the Unity license (needs UNITY_SERIAL/USER/PASS)
	@$(UNITY) -batchmode -nographics -quit \
		-serial "$(UNITY_SERIAL)" -username "$(UNITY_USER)" -password "$(UNITY_PASS)" -logFile -
