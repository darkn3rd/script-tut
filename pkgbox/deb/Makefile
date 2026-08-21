# Package directories are discovered by an nfpm.yaml file, for example:
#   act/nfpm.yaml -> package target "act"
PACKAGES := $(sort $(patsubst %/,%,$(dir $(wildcard */nfpm.yaml))))
UPDATABLE_PACKAGES := $(sort $(foreach package,$(PACKAGES),\
                       $(if $(wildcard $(package)/update.sh),$(package))))
UPDATE_TARGETS := $(addprefix update-,$(UPDATABLE_PACKAGES))

.DEFAULT_GOAL := all

.PHONY: all list update $(PACKAGES) $(UPDATE_TARGETS)

all: $(PACKAGES)

list:
	@printf '%s\n' $(PACKAGES)

update: $(UPDATE_TARGETS)

$(UPDATE_TARGETS): update-%:
	./$*/update.sh

# cd into the package dir first - nfpm resolves contents: src: paths
#  relative to its own working directory, not --config's location.
$(PACKAGES):
	@mkdir -p "$@/vendor"
	cd "$@" && nfpm pkg --config nfpm.yaml --target vendor/ --packager deb
