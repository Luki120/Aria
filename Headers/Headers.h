#import <substrate.h>
#import "Views/AriaBlurView.h"
#import "Views/AriaGradientView.h"


// Aria Prysm

@interface SpringBoard : UIApplication
@end


@interface PrysmCardBackgroundViewController : UIViewController
@property (nonatomic, strong, readwrite) UIView *overlayView;
@property (nonatomic, strong, readwrite) _UIBackdropView *backdropView;
@end


// Aria Stock

@interface MTMaterialView : UIView
@property (assign, nonatomic) BOOL shouldCrossfade;
@end


@interface CCUIModularControlCenterOverlayViewController : UIViewController
@property (nonatomic, strong) UIImageView *ariaImageView;
@property (nonatomic, strong) AriaGradientView *ariaGradientView;
@property (nonatomic, strong) MTMaterialView *overlayBackgroundView;
- (void)unleashAriaImage;
- (void)unleashAriaGradients;
@end


@interface CCUIOverlayTransitionState : NSObject
@property (assign, nonatomic, readonly) CGFloat clampedPresentationProgress;
@end
