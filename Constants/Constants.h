@import UIKit;
#import <GcUniversal/GcColorPickerUtils.h>
#import <GcUniversal/GcImagePickerUtils.h>


static NSString *const kDefaults = @"me.luki.ariaprefs";
static NSString *const kPATH = @"/var/mobile/Library/Preferences/me.luki.ariaprefs.plist";

#define Class(string) NSClassFromString(string)
#define kSaveToGallery UIImageWriteToSavedPhotosAlbum
#define kAriaTintColor [UIColor colorWithRed: 0.38 green: 0.22 blue: 0.40 alpha: 1.0]
#define kUserInterfaceStyle UIScreen.mainScreen.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark
#define kIsPrysm [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/Prysm.dylib"]


@interface NSDistributedNotificationCenter : NSNotificationCenter
@end
