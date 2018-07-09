include $(THEOS)/makefiles/common.mk

SUBPROJECTS += blockAppleOCSPServer
SUBPROJECTS += unblockAppleOCSPServer

include $(THEOS_MAKE_PATH)/aggregate.mk
