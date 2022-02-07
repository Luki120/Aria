export ARCHS = arm64 arm64e
export TARGET := iphone:clang:14.4:13.0

INSTALL_TARGET_PROCESSES = SpringBoard

SUBPROJECTS += AriaPrefs Hooks/AriaPrysm Hooks/AriaStock

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
