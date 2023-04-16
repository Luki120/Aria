BUNDLE_NAME = AriaPrefs

AriaPrefs_FILES = $(wildcard **/*.m) ../Managers/AriaImageManager.m
AriaPrefs_CFLAGS = -fobjc-arc
AriaPrefs_LIBRARIES = gcuniversal
AriaPrefs_FRAMEWORKS = UIKit
AriaPrefs_PRIVATE_FRAMEWORKS = Preferences
AriaPrefs_INSTALL_PATH = /Library/PreferenceBundles

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/bundle.mk
