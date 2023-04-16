#import "Headers/Common.h"
@import Photos;


@interface AriaImageManager : NSObject
+ (AriaImageManager *)sharedInstance;
- (void)blurImage;
+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
- (instancetype)copy __attribute__((unavailable("copy not available, call sharedInstance instead")));
- (instancetype)init __attribute__((unavailable("init not available, call sharedInstance instead")));
+ (instancetype)new __attribute__((unavailable("new not available, call sharedInstance instead")));
@end


@interface UIApplication ()
- (BOOL)_openURL:(NSURL *)url;
@end
