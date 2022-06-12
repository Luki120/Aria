#import "Headers/Headers.h"
#import "Headers/Prefs.h"


static void new_setPrysmImage(PrysmCardBackgroundViewController *self, SEL _cmd) {

	loadWithoutAGoddamnRespring();

	if(prysmGradients) return;

	_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle: 2];
	AriaBlurView *ariaBlurView = [[AriaBlurView alloc] initWithFrame:CGRectZero autosizesToFitSuperview:YES settings:settings];

	[[self.view viewWithTag: 10000] removeFromSuperview];
	[[ariaBlurView viewWithTag: 120] removeFromSuperview];

	self.overlayView.hidden = NO;
	self.backdropView.hidden = NO;

	if(!isPrysmImage) return;

	prysmDarkImage = [GcImagePickerUtils imageFromDefaults:kDefaults withKey: kPrysmDarkImage];
	prysmLightImage = [GcImagePickerUtils imageFromDefaults:kDefaults withKey: kPrysmLightImage];

	self.overlayView.hidden = YES;
	self.backdropView.hidden = YES;

	prysmImageView = [[UIImageView alloc] initWithFrame: self.view.bounds];
	prysmImageView.tag = 10000;
	prysmImageView.image = kUserInterfaceStyle ? prysmDarkImage : prysmLightImage;
	prysmImageView.contentMode = UIViewContentModeScaleAspectFill;
	prysmImageView.clipsToBounds = YES;
	prysmImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view insertSubview:prysmImageView atIndex:0];

	ariaBlurView.alpha = prysmAlpha;
	[prysmImageView addSubview: ariaBlurView];

}

static void new_updatePrysmImage(PrysmCardBackgroundViewController *self, SEL _cmd) {

	[UIView transitionWithView:self.view duration:0.8 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{

		prysmImageView.image = kUserInterfaceStyle ? prysmDarkImage : prysmLightImage;

	} completion:nil];

}

static void new_setPrysmGradient(PrysmCardBackgroundViewController *self, SEL _cmd) {

	loadWithoutAGoddamnRespring();

	if(isPrysmImage) return;

	[[self.view viewWithTag: 2811] removeFromSuperview];

	self.overlayView.hidden = NO;
	self.backdropView.hidden = NO;

	if(!prysmGradients) return;

	UIColor *firstColor = [GcColorPickerUtils colorFromDefaults:kDefaults withKey:kPrysmGradientFirstColor fallback:@"ffffff"];
	UIColor *secondColor = [GcColorPickerUtils colorFromDefaults:kDefaults withKey:kPrysmGradientSecondColor fallback:@"ffffff"];
	NSArray *gradientColors = [NSArray arrayWithObjects:(id)firstColor.CGColor, (id)secondColor.CGColor, nil];

	self.overlayView.hidden = YES;
	self.backdropView.hidden = YES;

	prysmGradientView = [[AriaGradientView alloc] initWithFrame: self.view.bounds];
	prysmGradientView.tag = 2811;
	prysmGradientView.clipsToBounds = YES;
	prysmGradientView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	prysmGradientView.layer.colors = gradientColors;
	[self.view insertSubview:prysmGradientView atIndex:0];

	switch(prysmGradientDirection) {

		case 1: // Top to Bottom

			[self setGradientStartPoint:CGPointMake(0.5, 0) endPoint:CGPointMake(0.5, 1)]; break;

		case 2: // Left to Right

			[self setGradientStartPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.5)]; break;

		case 3: // Right to Left

			[self setGradientStartPoint:CGPointMake(1, 0.5) endPoint:CGPointMake(0, 0.5)]; break;

		case 4: // Upper Left lower right

			[self setGradientStartPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 1)]; break;

		case 5: // Lower left upper right

			[self setGradientStartPoint:CGPointMake(0, 1) endPoint:CGPointMake(1, 0)]; break;

		case 6: // Upper right lower left

			[self setGradientStartPoint:CGPointMake(1, 0) endPoint:CGPointMake(0, 1)]; break;

		case 7: // Lower right upper left

			[self setGradientStartPoint:CGPointMake(1, 1) endPoint:CGPointMake(0, 0)]; break;

		default: // Bottom to Top

			[self setGradientStartPoint:CGPointMake(0.5, 1) endPoint:CGPointMake(0.5, 0)]; break;

	}

	if(!prysmGradientAnimation) return;

	CABasicAnimation *animation = [CABasicAnimation animation];
	animation.keyPath = @"colors";
	animation.duration = 4.5;
	animation.fromValue = [NSArray arrayWithObjects:(id)firstColor.CGColor, (id)secondColor.CGColor, nil];
	animation.toValue = [NSArray arrayWithObjects:(id)secondColor.CGColor, (id)firstColor.CGColor, nil];
	animation.repeatCount = HUGE_VALF; // Loop the animation forever
	animation.autoreverses = YES;
	animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
	[prysmGradientView.layer addAnimation:animation forKey: @"gradientAnimation"];

}

static void new_setGradientStartAndEndPoint(PrysmCardBackgroundViewController *self, SEL _cmd, CGPoint startPoint, CGPoint endPoint) {

	prysmGradientView.layer.startPoint = startPoint;
	prysmGradientView.layer.endPoint = endPoint;

}

static void (*origTCDC)(UIScreen *self, SEL _cmd, UITraitCollection *);

static void overrideTCDC(UIScreen *self, SEL _cmd, UITraitCollection *previousTrait) {

	origTCDC(self, _cmd, previousTrait);
	[NSNotificationCenter.defaultCenter postNotificationName:@"traitCollectionDidChange" object:nil];

}

static void (*origVDLS)(PrysmCardBackgroundViewController *self, SEL _cmd);

static void overrideVDLS(PrysmCardBackgroundViewController *self, SEL _cmd) { // create notifications observers

	origVDLS(self, _cmd);
	new_setPrysmImage(self, _cmd);
	new_setPrysmGradient(self, _cmd);

	[NSDistributedNotificationCenter.defaultCenter removeObserver:self];
	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(setPrysmImage) name:@"prysmImageApplied" object:nil];
	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(setPrysmGradient) name:@"prysmGradientsApplied" object:nil];

	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(updatePrysmImage) name:@"traitCollectionDidChange" object:nil];

}

static void(*origADFL)(SpringBoard *self, SEL _cmd, id);

static void overrideADFL(SpringBoard *self, SEL _cmd, id app) {

	origADFL(self, _cmd, app);

	/*--- initialize the hooks when WE decide it, fuck dlopen, this is better :nfr: ---*/

	MSHookMessageEx(kClass(@"UIScreen"), @selector(traitCollectionDidChange:), (IMP) &overrideTCDC, (IMP *) &origTCDC);
	MSHookMessageEx(kClass(@"PrysmCardBackgroundViewController"), @selector(viewDidLayoutSubviews), (IMP) &overrideVDLS, (IMP *) &origVDLS);	

	class_addMethod(
		kClass(@"PrysmCardBackgroundViewController"),
		@selector(setPrysmImage),
		(IMP)&new_setPrysmImage,
		"v@:"
	);

	class_addMethod(
		kClass(@"PrysmCardBackgroundViewController"),
		@selector(updatePrysmImage),
		(IMP)&new_updatePrysmImage,
		"v@:"
	);

	class_addMethod(
		kClass(@"PrysmCardBackgroundViewController"),
		@selector(setPrysmGradient),
		(IMP)&new_setPrysmGradient,
		"v@:"
	);

	class_addMethod(
		kClass(@"PrysmCardBackgroundViewController"),
		@selector(setGradientStartPoint:endPoint:),
		(IMP)&new_setGradientStartAndEndPoint,
		"v@:@@"
	);

}


__attribute__((constructor)) static void init() {

	if(!kPrysmExists) return;
	loadWithoutAGoddamnRespring();
	MSHookMessageEx(kClass(@"SpringBoard"), @selector(applicationDidFinishLaunching:), (IMP) &overrideADFL, (IMP *) &origADFL);

}
