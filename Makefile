export ARCHS = arm64 arm64e
export TARGET := iphone:clang:latest:latest

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Aria

Aria_FILES = Aria.x
Aria_CFLAGS = -fobjc-arc
Aria_LIBRARIES = gcuniversal

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += AriaPrefs
include $(THEOS_MAKE_PATH)/aggregate.mk