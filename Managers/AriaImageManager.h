#import "Managers/MyClass.h"
#import "Headers/Constants.h"


@interface AriaImageManager : NSObject
+ (AriaImageManager *)sharedInstance;
- (void)blurImageWithImage;
- (void)saveImageToGallery:(UIImage *)image;
+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
- (instancetype)copy __attribute__((unavailable("copy not available, call sharedInstance instead")));
- (instancetype)init __attribute__((unavailable("init not available, call sharedInstance instead")));
+ (instancetype)new __attribute__((unavailable("new not available, call sharedInstance instead")));
@end


// Private

@interface UIApplication ()
- (BOOL)_openURL:(id)url;
@end
