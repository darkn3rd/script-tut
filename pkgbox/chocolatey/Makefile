# Package directories are discovered by a same-named nuspec file, for example:
#   pipx/pipx.nuspec -> package target "pipx"
PACKAGES := $(sort $(foreach nuspec,$(wildcard */*.nuspec),\
             $(if $(wildcard $(dir $(nuspec))$(notdir $(patsubst %/,%,$(dir $(nuspec)))).nuspec),\
               $(notdir $(patsubst %/,%,$(dir $(nuspec)))))))
UPDATABLE_PACKAGES := $(sort $(foreach package,$(PACKAGES),\
                       $(if $(wildcard $(package)/update.ps1),$(package))))
UPDATE_TARGETS := $(addprefix update-,$(UPDATABLE_PACKAGES))
PUBLISH_TARGETS := $(addprefix publish-,$(PACKAGES))

.DEFAULT_GOAL := all

.PHONY: all list update $(PACKAGES) $(UPDATE_TARGETS) $(PUBLISH_TARGETS)

all: $(PACKAGES)

list:
	@printf '%s\n' $(PACKAGES)

update: $(UPDATE_TARGETS)

$(UPDATE_TARGETS): update-%:
	pwsh -NoProfile -Command "if (-not (Get-Module -ListAvailable -Name au)) { throw 'AU is not installed. Run: choco install au' }; Set-Location '$*'; & '.\update.ps1'"

$(PACKAGES):
	@mkdir -p "$@/vendor"
	choco pack "$@/$@.nuspec" --output-directory "$@/vendor"

# publish-<pkg> only - never wired into `all`/the default goal, and there
#  is deliberately no bare `publish` target covering every package at
#  once. This pushes to the public Chocolatey Community Repository -
#  moderated, but publicly visible the moment it's pushed, not something
#  to fire by accident or all at once. See publish.ps1 for prerequisites
#  and why the logic lives in a real script, not an inline recipe.
$(PUBLISH_TARGETS): publish-%:
	pwsh -NoProfile -File publish.ps1 -Package $*
