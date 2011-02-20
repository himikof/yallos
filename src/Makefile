# Yallos main makefile
_ROOT ?= $(CURDIR)
include $(_ROOT)/root.mk

SUBDIRS = arch/$(ARCH) kernel arch/$(ARCH)/builder arch/x86/yaldr
include $(addprefix $(_ROOT)/,$(addsuffix /Makefile,$(SUBDIRS)))
all: $(subst /,_,$(SUBDIRS))
clean: $(addprefix clean-,$(subst /,_,$(SUBDIRS)))
image: arch_$(ARCH)_builder_image
yaldr: arch_x86_yaldr_yaldr
fdimage: arch_x86_yaldr_fdimage
