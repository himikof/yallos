# arch/x86/yaldr: test bootloader

# Magic header, do not touch
sp :=
sp +=
_walk = $(if $1,$(wildcard /$(subst $(sp),/,$1)/$2) $(call _walk,$(wordlist 2,$(words $1),x $1),$2))
_find = $(firstword $(call _walk,$(strip $(subst /, ,$1)),$2))
_ROOT ?= $(patsubst %/root.mk,%,$(call _find,$(CURDIR),root.mk))
include $(_ROOT)/root.mk
include $(_ROOT)/prefix.mk
# End of magic

$(call DEPENDS_ON,arch/$(ARCH)/builder)

YALDR_SRC := boot.S
SIZE_TARGET = arch_$(ARCH)_builder_size
$(call local_target,preyaldr)_LDSCRIPT = $(_MODULE_PATH)/boot.ld
$(call local_target,preyaldr)_EXTRA_TDEPS := $(SIZE_TARGET)
$(call add_executable,preyaldr,$(YALDR_SRC))
$($(call local_target,preyaldr)_PATH) : INCLUDE_DIRS_ASM := $(_ROOT)/include/asm-x86 $(dir $(call get_tpath,$(SIZE_TARGET)))
$($(call local_target,preyaldr)_PATH) : ALL_ASFLAGS += --32

$(call local_target,yaldr)_TDEPS := $(call local_target,preyaldr)
$(call add_binary,yaldr,)

TARGETS = yaldr

QUIET_FDIMG = @echo 'FDIMG '$(call local_build,$@) &&
SILENT_FDIMG = @

$(call local_target,fdimage)_OUTPUT := fdimage
$(call add_custom,fdimage,)
$(call local_target,fdimage)_SRCS := $($(call local_target,yaldr)_PATH) $(arch_$(ARCH)_builder_image_PATH)

ifneq ($($(_MODULE_NAME)_DEFINED),T)
$($(call local_target,fdimage)_PATH) : $($(call local_target,fdimage)_SRCS)
	$($(MODE)FDIMG)$(DD) if=/dev/zero of=$@ count=2880 2>/dev/null
	$(Q)cat $^|$(DD) of=$@ conv=notrunc 2>/dev/null
endif

# Magic footer, do not touch
include $(_ROOT)/suffix.mk
