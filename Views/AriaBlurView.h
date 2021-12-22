@import UIKit;
#import "Headers/Prefs.h"
#import "Headers/Common.h"
#import "Constants/Constants.h"



@interface AriaBlurView : _UIBackdropView {

	@public AriaBlurView *blurView;

}
+ (AriaBlurView *)sharedInstance;
+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
- (instancetype)copy __attribute__((unavailable("copy not available, call sharedInstance instead")));
- (instancetype)init __attribute__((unavailable("init not available, call sharedInstance instead")));
+ (instancetype)new __attribute__((unavailable("new not available, call sharedInstance instead")));
@end
