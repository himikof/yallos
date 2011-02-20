# arch/x86_64: x86_64-specific sources

# Magic header, do not touch
sp :=
sp +=
_walk = $(if $1,$(wildcard /$(subst $(sp),/,$1)/$2) $(call _walk,$(wordlist 2,$(words $1),x $1),$2))
_find = $(firstword $(call _walk,$(strip $(subst /, ,$1)),$2))
_ROOT ?= $(patsubst %/root.mk,%,$(call _find,$(CURDIR),root.mk))
include $(_ROOT)/root.mk
include $(_ROOT)/prefix.mk
# End of magic

# boot32 is disabled for now
$(call set_subtargets,boot16 kernel)

$(call add_all_library)

TARGETS = all


# Magic footer, do not touch
include $(_ROOT)/suffix.mk
