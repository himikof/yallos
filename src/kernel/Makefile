# Main kernel sources

# Magic header, do not touch
sp :=
sp +=
_walk = $(if $1,$(wildcard /$(subst $(sp),/,$1)/$2) $(call _walk,$(wordlist 2,$(words $1),x $1),$2))
_find = $(firstword $(call _walk,$(strip $(subst /, ,$1)),$2))
_ROOT ?= $(patsubst %/root.mk,%,$(call _find,$(CURDIR),root.mk))
include $(_ROOT)/root.mk
include $(_ROOT)/prefix.mk
# End of magic


ALL_SRCS = main.c ctype.c die.c print.c
$(call add_library,all,$(ALL_SRCS))

$(call DEPENDS_ON,arch/$(ARCH))

$(call local_target,preimage)_TDEPS += $(call local_target,all) arch_$(ARCH)_all
$(call add_library,preimage,)

TARGETS = all preimage


# Magic footer, do not touch
include $(_ROOT)/suffix.mk
