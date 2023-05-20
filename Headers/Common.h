@import GcUniversal.ColorPickerUtils;
@import GcUniversal.ImagePickerUtils;
#import <rootless.h>

#define rootlessPathC(cPath) ROOT_PATH(cPath)
#define rootlessPathNS(path) ROOT_PATH_NS(path)

static NSString *const kDefaults = @"me.luki.ariaprefs";
static NSString *const kPath = rootlessPathNS(@"/var/mobile/Library/Preferences/me.luki.ariaprefs.plist");
static NSString *const kPrysmDarkImage = @"prysmDarkImage";
static NSString *const kPrysmLightImage = @"prysmLightImage";
static NSString *const kStockDarkImage = @"stockDarkImage";
static NSString *const kStockLightImage = @"stockLightImage";

static NSNotificationName const AriaDidApplyPrysmImageNotification = @"AriaDidApplyPrysmImageNotification";
static NSNotificationName const AriaDidApplyPrysmGradientsNotification = @"AriaDidApplyPrysmGradientsNotification";

#define kClass(class) NSClassFromString(class)
#define kAriaTintColor [UIColor colorWithRed:0.47 green:0.04 blue:0.27 alpha: 1.0]
#define kUserInterfaceStyle UIScreen.mainScreen.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark
#define kPrysmExists [[NSFileManager defaultManager] fileExistsAtPath:rootlessPathNS(@"/Library/MobileSubstrate/DynamicLibraries/Prysm.dylib")]


@interface _UIBackdropView : UIView
- (id)initWithFrame:(CGRect)arg1 autosizesToFitSuperview:(BOOL)arg2 settings:(id)arg3;
@end


@interface _UIBackdropViewSettings : NSObject
+ (id)settingsForStyle:(NSInteger)arg1;
@end


@interface NSDistributedNotificationCenter : NSNotificationCenter
@end
