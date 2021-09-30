export ARCHS = arm64 arm64e
export TARGET := iphone:clang:latest:latest

INSTALL_TARGET_PROCESSES = SpringBoard

SUBPROJECTS += AriaPrefs AriaPrysm AriaStock

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
