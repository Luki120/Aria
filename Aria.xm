#import <UIKit/UIKit.h>
#import "GcImagePickerUtils.h"
#import "GcColorPickerUtils.h"




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
@property (nonatomic, strong) UIView *hotGradientView;
@property (nonatomic, strong) CAGradientLayer *gradient;
- (void)unleashThatHotGoodLookingImage;
- (void)setAHotGoodLookingGradient;
@end


@interface CCUIOverlayTransitionState : NSObject
@property (nonatomic, readonly, assign) CGFloat clampedPresentationProgress;
@end


static NSString *takeMeToTheValues = @"/var/mobile/Library/Preferences/me.luki.ariaprefs.plist";

static BOOL giveMeTheImage;
static BOOL shouldTransition;
static BOOL giveMeThoseGradients;
static BOOL neatGradientAnimation;
static BOOL shouldTransitionForGradient;

float alpha = 1.0f;

//CAGradientLayer *gradient;
//UIView *hotGradientView;


static void loadWithoutAGoddamnRespring() {


	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:takeMeToTheValues];
	NSMutableDictionary *prefs = dict ? [dict mutableCopy] : [NSMutableDictionary dictionary];
	
	giveMeTheImage = prefs[@"giveMeTheImage"] ? [prefs[@"giveMeTheImage"] boolValue] : NO;
	shouldTransition = prefs[@"shouldTransition"] ? [prefs[@"shouldTransition"] boolValue] : NO;
	giveMeThoseGradients = prefs[@"giveMeThoseGradients"] ? [prefs[@"giveMeThoseGradients"] boolValue] : NO;
	neatGradientAnimation = prefs[@"neatGradientAnimation"] ?  [prefs[@"neatGradientAnimation"] boolValue] : NO;
	shouldTransitionForGradient = prefs[@"shouldTransitionForGradient"] ? [prefs[@"shouldTransitionForGradient"] boolValue] : NO;	
	alpha = prefs[@"alpha"] ? [prefs[@"alpha"] floatValue] : 1.0f;


}




%hook CCUIModularControlCenterOverlayViewController


%property (nonatomic, strong) UIImageView *hotGoodLookingImageView;
%property (nonatomic, strong) _UIBackdropView *blurView;
%property (nonatomic, strong) UIView *hotGradientView;
%property (nonatomic, strong) CAGradientLayer *gradient;


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

	loadWithoutAGoddamnRespring();
	

	if(shouldTransition) { // add an optional transition to fade in the image for a more stockish behavior

		
		self.hotGoodLookingImageView.alpha = state.clampedPresentationProgress;
		self.blurView.alpha = state.clampedPresentationProgress * alpha;


	}


	else self.hotGoodLookingImageView.alpha = 1;


	if(shouldTransitionForGradient) {


		self.hotGradientView.alpha = state.clampedPresentationProgress;
		self.blurView.alpha = state.clampedPresentationProgress * alpha;


	}


	else self.hotGradientView.alpha = 1;

}


%new


- (void)unleashThatHotGoodLookingImage { // self explanatory
	

	loadWithoutAGoddamnRespring();

	[[self.blurView viewWithTag:120] removeFromSuperview];


	if(giveMeTheImage) {


		if(!self.hotGoodLookingImageView) {


			self.hotGoodLookingImageView = [[UIImageView alloc] initWithFrame:self.overlayBackgroundView.bounds];
			self.hotGoodLookingImageView.contentMode = UIViewContentModeScaleAspectFill;
			if(shouldTransition) self.hotGoodLookingImageView.alpha = MSHookIvar<CCUIOverlayTransitionState*>(self, "_previousTransitionState").clampedPresentationProgress;
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


	} else {


		[self.hotGoodLookingImageView removeFromSuperview];
		self.hotGoodLookingImageView = nil;


	}

}


%new


- (void)setAHotGoodLookingGradient {


	loadWithoutAGoddamnRespring();

	[[self.view viewWithTag:2811] removeFromSuperview];


	UIColor *firstColor = [GcColorPickerUtils colorFromDefaults:@"me.luki.ariaprefs" withKey:@"gradientFirstColor" fallback:@"ffffff"];
	UIColor *secondColor = [GcColorPickerUtils colorFromDefaults:@"me.luki.ariaprefs" withKey:@"gradientSecondColor" fallback:@"ffffff"];


	if(giveMeThoseGradients) {


		self.hotGradientView = [[UIView alloc] initWithFrame:self.overlayBackgroundView.bounds];
		self.hotGradientView.tag = 2811;
		self.hotGradientView.clipsToBounds = YES;
		if(shouldTransitionForGradient) self.hotGradientView.alpha = MSHookIvar<CCUIOverlayTransitionState*>(self, "_previousTransitionState").clampedPresentationProgress;
		self.gradient = [CAGradientLayer layer];
		self.gradient.frame = self.hotGradientView.frame;
		self.gradient.startPoint = CGPointMake(0.5,1); // Lower right to upper left
		self.gradient.endPoint = CGPointMake(0.5,0);
		self.gradient.colors = [NSArray arrayWithObjects:(id)firstColor.CGColor, (id)secondColor.CGColor, nil];
//		self.gradient.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.00], [NSNumber numberWithFloat:0.50] , nil];
		[self.hotGradientView.layer insertSublayer:self.gradient atIndex:0];
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
		[self.gradient addAnimation:animation forKey:@"animateGradient"];


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