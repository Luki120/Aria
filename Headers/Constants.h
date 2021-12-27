@import UIKit;
#import <GcUniversal/GcColorPickerUtils.h>
#import <GcUniversal/GcImagePickerUtils.h>


static NSString *const kDefaults = @"me.luki.ariaprefs";
static NSString *const kPATH = @"/var/mobile/Library/Preferences/me.luki.ariaprefs.plist";
static NSString *const kPrysmDarkImage = @"prysmDarkImage";
static NSString *const kPrysmLightImage = @"prysmLightImage";
static NSString *const kStockDarkImage = @"stockDarkImage";
static NSString *const kStockLightImage = @"stockLightImage";
static NSString *const kPrysmGradientFirstColor = @"prysmGradientFirstColor";
static NSString *const kPrysmGradientSecondColor = @"prysmGradientSecondColor";
static NSString *const kStockGradientFirstColor = @"gradientFirstColor";
static NSString *const kStockGradientSecondColor = @"gradientSecondColor";


#define Class(string) NSClassFromString(string)
#define kSaveToGallery UIImageWriteToSavedPhotosAlbum
#define kAriaTintColor [UIColor colorWithRed: 0.47 green: 0.04 blue: 0.27 alpha: 1.0];
#define kUserInterfaceStyle UIScreen.mainScreen.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark
#define kIsPrysm [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/Prysm.dylib"]
