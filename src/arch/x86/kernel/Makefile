# arch/x86/kernel: x86-specific sources

# Magic header, do not touch
sp :=
sp +=
_walk = $(if $1,$(wildcard /$(subst $(sp),/,$1)/$2) $(call _walk,$(wordlist 2,$(words $1),x $1),$2))
_find = $(firstword $(call _walk,$(strip $(subst /, ,$1)),$2))
_ROOT ?= $(patsubst %/root.mk,%,$(call _find,$(CURDIR),root.mk))
include $(_ROOT)/root.mk
include $(_ROOT)/prefix.mk
# End of magic

ALL_SRCS = output.S syscall.S syscall_table.S exceptions_asm.S irq_asm.S \
	irq.c exceptions.c string.c

$(call add_library,all,$(ALL_SRCS))

TARGETS = all


# Magic footer, do not touch
include $(_ROOT)/suffix.mk
