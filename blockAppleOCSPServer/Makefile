ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TOOL_NAME = blockAppleOCSPServer
$(TOOL_NAME)_FILES = ../utils.c main.m
$(TOOL_NAME)_CODESIGN_FLAGS = -S../ent.plist

include $(THEOS_MAKE_PATH)/tool.mk
