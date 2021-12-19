#import <substrate.h>
#import "Headers/Prefs.h"
#import "Managers/AriaImageManager.h"
#import <AudioToolbox/AudioServices.h>


#pragma mark Custom Views


@interface _UIBackdropView : UIView
@property (assign, nonatomic) BOOL blurRadiusSetOnce;
@property (copy, nonatomic) NSString *_blurQuality;
@property (assign, nonatomic) double _blurRadius;
- (id)initWithSettings:(id)arg1;
- (id)initWithFrame:(CGRect)arg1 autosizesToFitSuperview:(BOOL)arg2 settings:(id)arg3;
@end


@interface _UIBackdropViewSettings : NSObject
+ (id)settingsForStyle:(long long)arg1;
@end


@interface AriaBlurView : _UIBackdropView
@property (nonatomic, strong) AriaBlurView *blurView;
+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
- (instancetype)copy __attribute__((unavailable("copy not available, call sharedInstance instead")));
- (instancetype)init __attribute__((unavailable("init not available, call sharedInstance instead")));
+ (instancetype)new __attribute__((unavailable("new not available, call sharedInstance instead")));
@end


@implementation AriaBlurView


+ (AriaBlurView *)sharedInstance {

	static AriaBlurView *sharedInstance = nil;
	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{ sharedInstance = [[self alloc] initPrivate]; });

	return sharedInstance;

}


- (id)initPrivate {

	self = [super init];

	if(self) {

		if(!self.blurView) {

			_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];

			self.blurView = [[AriaBlurView alloc] initWithFrame:CGRectZero autosizesToFitSuperview:YES settings:settings];
			self.blurView.tag = 120;
			if(kIsPrysm) self.blurView.alpha = prysmAlpha;
			else self.blurView.alpha = alpha;
			self.blurView._blurRadius = 80.0;
			self.blurView._blurQuality = @"high";
			self.blurView.blurRadiusSetOnce = NO;

		}

	}

	return self;

}


@end


@interface AriaGradientView : UIView
@property (nonatomic, strong, readonly) CAGradientLayer *layer;
@end


@implementation AriaGradientView

@dynamic layer;

+ (Class)layerClass { return [CAGradientLayer class]; }

@end


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
