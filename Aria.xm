#import <UIKit/UIKit.h>
#import "GcImagePickerUtils.h"
#import "GcColorPickerUtils.h"




@interface GradientView : UIView
@property (nonatomic, strong, readonly) CAGradientLayer *layer;
@end


@implementation GradientView

@dynamic layer;

+ (Class)layerClass {

	return [CAGradientLayer class];

}

@end


@interface NSDistributedNotificationCenter : NSNotificationCenter
+ (instancetype)defaultCenter;
- (void)postNotificationName:(NSString *)name object:(NSString *)object userInfo:(NSDictionary *)userInfo;
@end


@interface _UIBackdropViewSettings : NSObject
+ (id)settingsForStyle:(long long)arg1;
@end


@interface _UIBackdropView : UIView
@property (assign,nonatomic) BOOL blurRadiusSetOnce;
@property (nonatomic,copy) NSString * _blurQuality;
@property (assign,nonatomic) double _blurRadius;
- (id)initWithFrame:(CGRect)arg1 autosizesToFitSuperview:(BOOL)arg2 settings:(id)arg3;
- (id)initWithSettings:(id)arg1;
@end


@interface MTMaterialView : UIView
@property (nonatomic, assign) BOOL shouldCrossfade;
@end


@interface CCUIModularControlCenterOverlayViewController : UIViewController
@property (nonatomic, retain) MTMaterialView *overlayBackgroundView;
@property (nonatomic, strong) UIImageView *hotGoodLookingImageView;
@property (nonatomic, strong) _UIBackdropView *blurView;
@property (nonatomic, strong) GradientView *hotGradientView;
- (void)unleashThatHotGoodLookingImage;
- (void)setAHotGoodLookingGradient;
@end


@interface CCUIOverlayTransitionState : NSObject
@property (nonatomic, readonly, assign) CGFloat clampedPresentationProgress;
@end


static NSString *takeMeToTheValues = @"/var/mobile/Library/Preferences/me.luki.ariaprefs.plist";

static BOOL giveMeTheImage;
static BOOL giveMeThoseGradients;
static BOOL neatGradientAnimation;

static int gradientDirection;

float alpha = 1.0f;


static void loadWithoutAGoddamnRespring() {


	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:takeMeToTheValues];
	NSMutableDictionary *prefs = dict ? [dict mutableCopy] : [NSMutableDictionary dictionary];
	
	giveMeTheImage = prefs[@"giveMeTheImage"] ? [prefs[@"giveMeTheImage"] boolValue] : NO;
	giveMeThoseGradients = prefs[@"giveMeThoseGradients"] ? [prefs[@"giveMeThoseGradients"] boolValue] : NO;
	neatGradientAnimation = prefs[@"neatGradientAnimation"] ?  [prefs[@"neatGradientAnimation"] boolValue] : NO;
	gradientDirection = prefs[@"gradientDirection"] ? [prefs[@"gradientDirection"] integerValue] : 0;
	alpha = prefs[@"alpha"] ? [prefs[@"alpha"] floatValue] : 1.0f;


}




%hook CCUIModularControlCenterOverlayViewController


%property (nonatomic, strong) UIImageView *hotGoodLookingImageView;
%property (nonatomic, strong) _UIBackdropView *blurView;
%property (nonatomic, strong) GradientView *hotGradientView;


- (void)viewDidLoad { // create a notification observer to force dark/light mode in the CC


	%orig;
	
	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(unleashThatHotGoodLookingImage) name:@"traitCollectionDidChange" object:nil];

}


- (void)viewWillAppear:(BOOL)animated {


	%orig(animated);
	
	[self unleashThatHotGoodLookingImage];
	[self setAHotGoodLookingGradient];


}


- (void)_updatePresentationForTransitionState:(CCUIOverlayTransitionState*)state withCompletionHander:(id)handler {


	%orig;
		
	if(giveMeTheImage) {

		self.hotGoodLookingImageView.alpha = state.clampedPresentationProgress;
		self.blurView.alpha = state.clampedPresentationProgress * alpha;


	}

	
	else if(giveMeThoseGradients) self.hotGradientView.alpha = state.clampedPresentationProgress;


}


%new


- (void)unleashThatHotGoodLookingImage { // self explanatory
	

	loadWithoutAGoddamnRespring();

	[[self.blurView viewWithTag:120] removeFromSuperview];


	if(giveMeTheImage) {


		if(!self.hotGoodLookingImageView) {


			self.hotGoodLookingImageView = [[UIImageView alloc] initWithFrame:self.overlayBackgroundView.bounds];
			self.hotGoodLookingImageView.alpha = MSHookIvar<CCUIOverlayTransitionState*>(self, "_previousTransitionState").clampedPresentationProgress;
			self.hotGoodLookingImageView.contentMode = UIViewContentModeScaleAspectFill;
			self.hotGoodLookingImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
			[self.overlayBackgroundView insertSubview:self.hotGoodLookingImageView atIndex:0];

		
		}


		self.overlayBackgroundView.shouldCrossfade = YES;
		

		// Hot good looking transition between dark/light mode

		[UIView transitionWithView:self.hotGoodLookingImageView duration:0.8 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{

			self.hotGoodLookingImageView.image = (UIScreen.mainScreen.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) ? [GcImagePickerUtils imageFromDefaults:@"me.luki.ariaprefs" withKey:@"hotGoodLookingImage"] : [GcImagePickerUtils imageFromDefaults:@"me.luki.ariaprefs" withKey:@"hotGoodLightLookingImage"];			
		
		} completion:nil];


		_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];

		self.blurView = [[_UIBackdropView alloc] initWithFrame:CGRectZero autosizesToFitSuperview:YES settings:settings];
		self.blurView.blurRadiusSetOnce = NO;
		self.blurView._blurRadius = 80.0;
		self.blurView._blurQuality = @"high";
		self.blurView.alpha = alpha;
		self.blurView.tag = 120;
		[self.overlayBackgroundView insertSubview:self.blurView atIndex:1];


	} 

}


%new


- (void)setAHotGoodLookingGradient {


	loadWithoutAGoddamnRespring();

	[[self.view viewWithTag:2811] removeFromSuperview];


	UIColor *firstColor = [GcColorPickerUtils colorFromDefaults:@"me.luki.ariaprefs" withKey:@"gradientFirstColor" fallback:@"ffffff"];
	UIColor *secondColor = [GcColorPickerUtils colorFromDefaults:@"me.luki.ariaprefs" withKey:@"gradientSecondColor" fallback:@"ffffff"];


	if(giveMeThoseGradients) {


		self.hotGradientView = [[GradientView alloc] initWithFrame:self.overlayBackgroundView.bounds];
		self.hotGradientView.tag = 2811;
		self.hotGradientView.alpha = MSHookIvar<CCUIOverlayTransitionState*>(self, "_previousTransitionState").clampedPresentationProgress;
		self.hotGradientView.clipsToBounds = YES;
		self.hotGradientView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.hotGradientView.layer.startPoint = CGPointMake(0.5,1); // Bottom to top, default
		self.hotGradientView.layer.endPoint = CGPointMake(0.5,0);
		self.hotGradientView.layer.colors = [NSArray arrayWithObjects:(id)firstColor.CGColor, (id)secondColor.CGColor, nil];
		[self.overlayBackgroundView insertSubview:self.hotGradientView atIndex:0];

		self.overlayBackgroundView.shouldCrossfade = YES;


	}


	if(neatGradientAnimation) {

			
		CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"colors"];
		animation.fromValue = [NSArray arrayWithObjects:(id)firstColor.CGColor, (id)secondColor.CGColor, nil];
		animation.toValue = [NSArray arrayWithObjects:(id)secondColor.CGColor, (id)firstColor.CGColor, nil];
		animation.duration = 4.5;
		animation.removedOnCompletion = NO;
		animation.autoreverses = YES;
		animation.repeatCount = HUGE_VALF; // Loop the animation forever
		animation.fillMode = kCAFillModeBoth;
		animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
		[self.hotGradientView.layer addAnimation:animation forKey:@"animateGradient"];


	}


	switch(gradientDirection) {


		case 0: // Bottom to Top

			self.hotGradientView.layer.startPoint = CGPointMake(0.5,1);
			self.hotGradientView.layer.endPoint = CGPointMake(0.5,0);
			break;


		case 1: // Top to Bottom

			self.hotGradientView.layer.startPoint = CGPointMake(0.5,0);
			self.hotGradientView.layer.endPoint = CGPointMake(0.5,1);
			break;


		case 2: // Left to Right

			self.hotGradientView.layer.startPoint = CGPointMake(0,0.5);
			self.hotGradientView.layer.endPoint = CGPointMake(1,0.5);
			break;


		case 3: // Right to Left

			self.hotGradientView.layer.startPoint = CGPointMake(1,0.5);
			self.hotGradientView.layer.endPoint = CGPointMake(0,0.5);
			break;


		case 4: // Upper Left lower right

			self.hotGradientView.layer.startPoint = CGPointMake(0,0);
			self.hotGradientView.layer.endPoint = CGPointMake(1,1);
			break;


		case 5: // Lower left upper right

			self.hotGradientView.layer.startPoint = CGPointMake(0,1);
			self.hotGradientView.layer.endPoint = CGPointMake(1,0);
			break;


		case 6: // Upper right lower left

			self.hotGradientView.layer.startPoint = CGPointMake(1,0);
			self.hotGradientView.layer.endPoint = CGPointMake(0,1);
			break;


		case 7: // Lower right upper left

			self.hotGradientView.layer.startPoint = CGPointMake(1,1);
			self.hotGradientView.layer.endPoint = CGPointMake(0,0);
			break;

	}

}


%end




%hook UIScreen


- (void)traitCollectionDidChange:(id)previous { // post a notification to force dark/light mode in the CC
						// because otherwise for some goddamn reason the CC forces light mode

	%orig;
	
	[NSNotificationCenter.defaultCenter postNotificationName:@"traitCollectionDidChange" object:nil];


}


%end




%ctor {


	loadWithoutAGoddamnRespring();


}