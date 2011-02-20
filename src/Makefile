# Yallos main makefile
_ROOT ?= $(CURDIR)
include $(_ROOT)/root.mk

SUBDIRS = arch/$(ARCH) kernel arch/$(ARCH)/builder arch/$(ARCH)/yaldr
include $(addprefix $(_ROOT)/,$(addsuffix /Makefile,$(SUBDIRS)))
all: $(subst /,_,$(SUBDIRS))
clean: $(addprefix clean-,$(subst /,_,$(SUBDIRS)))
