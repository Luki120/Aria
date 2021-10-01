@import UIKit;
#import <substrate.h>
#import <GcUniversal/GcImagePickerUtils.h>
#import <GcUniversal/GcColorPickerUtils.h>


static NSString *takeMeToTheValues = @"/var/mobile/Library/Preferences/me.luki.ariaprefs.plist";

#define isPrysm [[NSFileManager defaultManager] fileExistsAtPath:@"Library/MobileSubstrate/DynamicLibraries/Prysm.dylib"]

// Aria Prysm

static BOOL isPrysmImage;
static BOOL prysmGradients;
static BOOL prysmGradientAnimation;

static float prysmAlpha = 1.0f;

static int prysmGradientDirection;


// Aria Stock

static BOOL giveMeTheImage;
static BOOL giveMeThoseGradients;
static BOOL neatGradientAnimation;

static float alpha = 1.0f;

static int gradientDirection;


static void loadWithoutAGoddamnRespring() {


	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:takeMeToTheValues];
	NSMutableDictionary *prefs = dict ? [dict mutableCopy] : [NSMutableDictionary dictionary];

	isPrysmImage = prefs[@"isPrysmImage"] ? [prefs[@"isPrysmImage"] boolValue] : NO;
	prysmAlpha = prefs[@"prysmAlpha"] ? [prefs[@"prysmAlpha"] floatValue] : 1.0f;
	prysmGradients = prefs[@"prysmGradients"] ? [prefs[@"prysmGradients"] boolValue] : NO;
	prysmGradientDirection = prefs[@"prysmGradientDirection"] ? [prefs[@"prysmGradientDirection"] integerValue] : 0;
	prysmGradientAnimation = prefs[@"prysmGradientAnimation"] ? [prefs[@"prysmGradientAnimation"] boolValue] : NO;
	
	giveMeTheImage = prefs[@"giveMeTheImage"] ? [prefs[@"giveMeTheImage"] boolValue] : NO;
	giveMeThoseGradients = prefs[@"giveMeThoseGradients"] ? [prefs[@"giveMeThoseGradients"] boolValue] : NO;
	neatGradientAnimation = prefs[@"neatGradientAnimation"] ?  [prefs[@"neatGradientAnimation"] boolValue] : NO;
	gradientDirection = prefs[@"gradientDirection"] ? [prefs[@"gradientDirection"] integerValue] : 0;
	alpha = prefs[@"alpha"] ? [prefs[@"alpha"] floatValue] : 1.0f;

}


// Aria Global


@interface _UIBackdropView : UIView
- (id)initWithFrame:(CGRect)arg1 autosizesToFitSuperview:(BOOL)arg2 settings:(id)arg3;
@end


@interface _UIBackdropViewSettings : NSObject
+ (id)settingsForStyle:(long long)arg1;
@end


@interface AriaBlurView : _UIBackdropView
@property (nonatomic, strong) AriaBlurView *blurView;
@property (assign, nonatomic) BOOL blurRadiusSetOnce;
@property (copy, nonatomic) NSString *_blurQuality;
@property (assign, nonatomic) double _blurRadius;
@end


@implementation AriaBlurView

+ (AriaBlurView *)sharedInstance {

	static AriaBlurView *sharedInstance = nil;
	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{

		sharedInstance = [AriaBlurView new];

	});

	return sharedInstance;

}


- (id)init {

	self = [super init];

	_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];

	if(!self.blurView) {

		self.blurView = [[AriaBlurView alloc] initWithFrame:CGRectZero autosizesToFitSuperview:YES settings:settings];
		self.blurView.tag = 120;
		if(!isPrysm) self.blurView.alpha = alpha;
		else self.blurView.alpha = prysmAlpha;
		self.blurView._blurRadius = 80.0;
		self.blurView._blurQuality = @"high";
		self.blurView.blurRadiusSetOnce = NO;

	}

	return self;

}


@end


@interface AriaGradientView : UIView
@property (nonatomic, strong, readonly) CAGradientLayer *layer;
@end


@implementation AriaGradientView

@dynamic layer;

+ (Class)layerClass {

	return [CAGradientLayer class];

}

@end


// Aria Prysm


@interface SpringBoard : UIApplication
@end


@interface PrysmCardBackgroundViewController : UIViewController
@property (nonatomic, strong, readwrite) UIView *overlayView;
@property (nonatomic, strong, readwrite) _UIBackdropView *backdropView;
@end


@interface NSDistributedNotificationCenter : NSNotificationCenter
+ (instancetype)defaultCenter;
- (void)postNotificationName:(NSString *)name object:(NSString *)object userInfo:(NSDictionary *)userInfo;
@end


// Aria Stock


@interface MTMaterialView : UIView
@property (assign, nonatomic) BOOL shouldCrossfade;
@end


@interface CCUIModularControlCenterOverlayViewController : UIViewController
@property (nonatomic, strong) MTMaterialView *overlayBackgroundView;
@property (nonatomic, strong) UIImageView *ariaImageView;
@property (nonatomic, strong) AriaGradientView *gradientView;
- (void)unleashAriaImage;
- (void)setAriaGradient;
@end


@interface CCUIOverlayTransitionState : NSObject
@property (assign, nonatomic, readonly) CGFloat clampedPresentationProgress;
@end
