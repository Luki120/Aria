@import UIKit;
@import CydiaSubstrate;
#import "Common.h"
#import "Views/AriaBlurView.h"
#import "Views/AriaGradientView.h"


// Aria Prysm
@interface SpringBoard : UIApplication
@end


@interface PrysmCardBackgroundViewController : UIViewController
@property (nonatomic, strong) UIView *overlayView;
@property (nonatomic, strong) _UIBackdropView *backdropView;
- (void)setGradientStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;
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
- (void)updateAriaImage;
- (void)unleashAriaGradients;
- (void)setGradientStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;
@end


@interface CCUIOverlayTransitionState : NSObject
@property (assign, nonatomic, readonly) CGFloat clampedPresentationProgress;
@end
