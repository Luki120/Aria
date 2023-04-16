export TARGET := iphone:clang:latest:14.0

INSTALL_TARGET_PROCESSES = SpringBoard

SUBPROJECTS += AriaPrefs Hooks/AriaPrysm Hooks/AriaStock

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
