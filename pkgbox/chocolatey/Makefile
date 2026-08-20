# Package directories are discovered by a same-named nuspec file, for example:
#   pipx/pipx.nuspec -> package target "pipx"
PACKAGES := $(sort $(foreach nuspec,$(wildcard */*.nuspec),\
             $(if $(wildcard $(dir $(nuspec))$(notdir $(patsubst %/,%,$(dir $(nuspec)))).nuspec),\
               $(notdir $(patsubst %/,%,$(dir $(nuspec)))))))
UPDATABLE_PACKAGES := $(sort $(foreach package,$(PACKAGES),\
                       $(if $(wildcard $(package)/update.ps1),$(package))))
UPDATE_TARGETS := $(addprefix update-,$(UPDATABLE_PACKAGES))

.DEFAULT_GOAL := all

.PHONY: all list update $(PACKAGES) $(UPDATE_TARGETS)

all: $(PACKAGES)

list:
	@printf '%s\n' $(PACKAGES)

update: $(UPDATE_TARGETS)

$(UPDATE_TARGETS): update-%:
	pwsh -NoProfile -Command "if (-not (Get-Module -ListAvailable -Name au)) { throw 'AU is not installed. Run: choco install au' }; Set-Location '$*'; & '.\update.ps1'"

$(PACKAGES):
	@mkdir -p "$@/vendor"
	choco pack "$@/$@.nuspec" --output-directory "$@/vendor"
