#import "Headers/Headers.h"
#import "Headers/Prefs.h"


static NSString *const kStockGradientFirstColor = @"gradientFirstColor";
static NSString *const kStockGradientSecondColor = @"gradientSecondColor";

static NSNotificationName const AriaTraitCollectionDidChangeNotification = @"AriaTraitCollectionDidChangeNotification";

static UIImage *stockDarkImage;
static UIImage *stockLightImage;
static UIImageView *ariaImageView;
static AriaBlurView *ariaBlurView;
static AriaGradientView *ariaGradientView;

static void (*origVDL)(CCUIModularControlCenterOverlayViewController *, SEL);
static void overrideVDL(CCUIModularControlCenterOverlayViewController *self, SEL _cmd) {

	origVDL(self, _cmd);

	_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle: 2];
	ariaBlurView = [[AriaBlurView alloc] initWithFrame:CGRectZero autosizesToFitSuperview:YES settings:settings];

	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(updateAriaImage) name:AriaTraitCollectionDidChangeNotification object:nil];

}

static void (*origVWA)(CCUIModularControlCenterOverlayViewController *, SEL, BOOL);
static void overrideVWA(CCUIModularControlCenterOverlayViewController *self, SEL _cmd, BOOL animated) {

	origVWA(self, _cmd, animated);

	[self unleashAriaImage];
	[self unleashAriaGradients];

}

static void (*origUPFTS)(CCUIModularControlCenterOverlayViewController *, SEL, CCUIOverlayTransitionState *, id);
static void overrideUPFTS(CCUIModularControlCenterOverlayViewController *self, SEL _cmd, CCUIOverlayTransitionState *state, id completionHandler) {

	origUPFTS(self, _cmd, state, completionHandler);

	if(giveMeTheImage) {
		ariaImageView.alpha = state.clampedPresentationProgress;
		ariaBlurView.alpha = state.clampedPresentationProgress * alpha;
	}

	else if(giveMeThoseGradients) ariaGradientView.alpha = state.clampedPresentationProgress;

}

static void new_unleashAriaImage(CCUIModularControlCenterOverlayViewController *self, SEL _cmd) {

	loadWithoutAGoddamnRespring();

	[[ariaBlurView viewWithTag: 120] removeFromSuperview];

	if(!giveMeTheImage) return;

	stockDarkImage = [GcImagePickerUtils imageFromDefaults:kDefaults withKey: kStockDarkImage];
	stockLightImage = [GcImagePickerUtils imageFromDefaults:kDefaults withKey: kStockLightImage];
	
	if(!ariaImageView) {
		ariaImageView = [[UIImageView alloc] initWithFrame: self.overlayBackgroundView.bounds];
		ariaImageView.alpha = MSHookIvar<CCUIOverlayTransitionState *>(self, "_previousTransitionState").clampedPresentationProgress;
		ariaImageView.contentMode = UIViewContentModeScaleAspectFill;
		ariaImageView.clipsToBounds = YES;
		ariaImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.overlayBackgroundView insertSubview:ariaImageView atIndex:0];
	}

	self.overlayBackgroundView.shouldCrossfade = YES;

	[self updateAriaImage];

	ariaBlurView.alpha = alpha;
	[self.overlayBackgroundView insertSubview:ariaBlurView atIndex:1];

}

static void new_updateAriaImage(PrysmCardBackgroundViewController *self, SEL _cmd) {

	// Clean af transition between dark/light mode
	[UIView transitionWithView:ariaImageView duration:0.8 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{

		ariaImageView.image = kUserInterfaceStyle ? stockDarkImage : stockLightImage;

	} completion:nil];

}

static void new_unleashAriaGradients(CCUIModularControlCenterOverlayViewController *self, SEL _cmd) {

	loadWithoutAGoddamnRespring();

	[[self.view viewWithTag: 2811] removeFromSuperview];

	if(!giveMeThoseGradients) return;

	UIColor *firstColor = [GcColorPickerUtils colorFromDefaults:kDefaults withKey: kStockGradientFirstColor];
	UIColor *secondColor = [GcColorPickerUtils colorFromDefaults:kDefaults withKey: kStockGradientSecondColor];
	NSArray *gradientColors = @[(id)firstColor.CGColor, (id)secondColor.CGColor];

	ariaGradientView = [[AriaGradientView alloc] initWithFrame: self.view.bounds];
	ariaGradientView.tag = 2811;
	ariaGradientView.alpha = MSHookIvar<CCUIOverlayTransitionState *>(self, "_previousTransitionState").clampedPresentationProgress;
	ariaGradientView.clipsToBounds = YES;
	ariaGradientView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	ariaGradientView.layer.colors = gradientColors;
	[self.overlayBackgroundView insertSubview:ariaGradientView atIndex:0];

	self.overlayBackgroundView.shouldCrossfade = YES;

	switch(gradientDirection) {
		case 1: [self setGradientStartPoint:CGPointMake(0.5, 0) endPoint:CGPointMake(0.5, 1)]; break; // Top to bottom
		case 2: [self setGradientStartPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.5)]; break; // Left to right
		case 3: [self setGradientStartPoint:CGPointMake(1, 0.5) endPoint:CGPointMake(0, 0.5)]; break; // Right to left
		case 4: [self setGradientStartPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 1)]; break; // Upper left lower right
		case 5: [self setGradientStartPoint:CGPointMake(0, 1) endPoint:CGPointMake(1, 0)]; break; // Lower left upper right
		case 6: [self setGradientStartPoint:CGPointMake(1, 0) endPoint:CGPointMake(0, 1)]; break; // Upper right lower left
		case 7: [self setGradientStartPoint:CGPointMake(1, 1) endPoint:CGPointMake(0, 0)]; break; // Lower right upper left
		default: [self setGradientStartPoint:CGPointMake(0.5, 1) endPoint:CGPointMake(0.5, 0)]; break; // Bottom to top
	}

	if(!neatGradientAnimation) return;

	CABasicAnimation *animation = [CABasicAnimation animation];
	animation.keyPath = @"colors";
	animation.duration =  4.5;
	animation.fromValue = @[(id)firstColor.CGColor, (id)secondColor.CGColor];
	animation.toValue = @[(id)secondColor.CGColor, (id)firstColor.CGColor];
	animation.repeatCount = HUGE_VALF; // Loop the animation forever
	animation.autoreverses = YES;
	animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
	[ariaGradientView.layer addAnimation:animation forKey: @"gradientAnimation"];

}

static void new_setGradientStartAndEndPoint(CCUIModularControlCenterOverlayViewController *self, SEL _cmd, CGPoint startPoint, CGPoint endPoint) {

	ariaGradientView.layer.startPoint = startPoint;
	ariaGradientView.layer.endPoint = endPoint;

}

static void (*origTCDC)(UIScreen *, SEL, UITraitCollection *);
static void overrideTCDC(UIScreen *self, SEL _cmd, UITraitCollection *previousTrait) {

	origTCDC(self, _cmd, previousTrait);
	[NSNotificationCenter.defaultCenter postNotificationName:AriaTraitCollectionDidChangeNotification object:nil];

}

__attribute__((constructor)) static void init(void) {

	if(kPrysmExists) return;
	loadWithoutAGoddamnRespring();

	MSHookMessageEx(kClass(@"UIScreen"), @selector(traitCollectionDidChange:), (IMP) &overrideTCDC, (IMP *) &origTCDC);
	MSHookMessageEx(kClass(@"CCUIModularControlCenterOverlayViewController"), @selector(viewDidLoad), (IMP) &overrideVDL, (IMP *) &origVDL);	
	MSHookMessageEx(kClass(@"CCUIModularControlCenterOverlayViewController"), @selector(viewWillAppear:), (IMP) &overrideVWA, (IMP *) &origVWA);	
	MSHookMessageEx(kClass(@"CCUIModularControlCenterOverlayViewController"), @selector(_updatePresentationForTransitionState:withCompletionHander:), (IMP) &overrideUPFTS, (IMP *) &origUPFTS);	

	class_addMethod(
		kClass(@"CCUIModularControlCenterOverlayViewController"),
		@selector(unleashAriaImage),
		(IMP) &new_unleashAriaImage,
		"v@:"
	);

	class_addMethod(
		kClass(@"CCUIModularControlCenterOverlayViewController"),
		@selector(updateAriaImage),
		(IMP) &new_updateAriaImage,
		"v@:"
	);

	class_addMethod(
		kClass(@"CCUIModularControlCenterOverlayViewController"),
		@selector(unleashAriaGradients),
		(IMP) &new_unleashAriaGradients,
		"v@:"
	);

	class_addMethod(
		kClass(@"CCUIModularControlCenterOverlayViewController"),
		@selector(setGradientStartPoint:endPoint:),
		(IMP) &new_setGradientStartAndEndPoint,
		"v@:@@"
	);

}
