#import "Headers/Headers.h"
#import "Headers/Prefs.h"


static NSString *const kPrysmGradientFirstColor = @"prysmGradientFirstColor";
static NSString *const kPrysmGradientSecondColor = @"prysmGradientSecondColor";

static NSNotificationName const AriaTraitCollectionDidChangeNotification = @"AriaTraitCollectionDidChangeNotification";

static UIImage *prysmDarkImage;
static UIImage *prysmLightImage;
static UIImageView *prysmImageView;
static AriaGradientView *prysmGradientView;

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

	UIColor *firstColor = [GcColorPickerUtils colorFromDefaults:kDefaults withKey: kPrysmGradientFirstColor];
	UIColor *secondColor = [GcColorPickerUtils colorFromDefaults:kDefaults withKey: kPrysmGradientSecondColor];
	NSArray *gradientColors = @[(id)firstColor.CGColor, (id)secondColor.CGColor];

	self.overlayView.hidden = YES;
	self.backdropView.hidden = YES;

	prysmGradientView = [[AriaGradientView alloc] initWithFrame: self.view.bounds];
	prysmGradientView.tag = 2811;
	prysmGradientView.clipsToBounds = YES;
	prysmGradientView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	prysmGradientView.layer.colors = gradientColors;
	[self.view insertSubview:prysmGradientView atIndex:0];

	switch(prysmGradientDirection) {
		case 1: [self setGradientStartPoint:CGPointMake(0.5, 0) endPoint:CGPointMake(0.5, 1)]; break; // Top to bottom
		case 2: [self setGradientStartPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.5)]; break; // Left to right
		case 3: [self setGradientStartPoint:CGPointMake(1, 0.5) endPoint:CGPointMake(0, 0.5)]; break; // Right to left
		case 4: [self setGradientStartPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 1)]; break; // Upper left lower right
		case 5: [self setGradientStartPoint:CGPointMake(0, 1) endPoint:CGPointMake(1, 0)]; break; // Lower left upper right
		case 6: [self setGradientStartPoint:CGPointMake(1, 0) endPoint:CGPointMake(0, 1)]; break; // Upper right lower left
		case 7: [self setGradientStartPoint:CGPointMake(1, 1) endPoint:CGPointMake(0, 0)]; break; // Lower right upper left
		default: [self setGradientStartPoint:CGPointMake(0.5, 1) endPoint:CGPointMake(0.5, 0)]; break; // Bottom to top
	}

	if(!prysmGradientAnimation) return;

	CABasicAnimation *animation = [CABasicAnimation animation];
	animation.keyPath = @"colors";
	animation.duration = 4.5;
	animation.fromValue = @[(id)firstColor.CGColor, (id)secondColor.CGColor];
	animation.toValue = @[(id)secondColor.CGColor, (id)firstColor.CGColor];
	animation.repeatCount = HUGE_VALF; // Loop the animation forever
	animation.autoreverses = YES;
	animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
	[prysmGradientView.layer addAnimation:animation forKey: @"gradientAnimation"];

}

static void new_setGradientStartAndEndPoint(PrysmCardBackgroundViewController *self, SEL _cmd, CGPoint startPoint, CGPoint endPoint) {

	prysmGradientView.layer.startPoint = startPoint;
	prysmGradientView.layer.endPoint = endPoint;

}

static void (*origTCDC)(UIScreen *, SEL, UITraitCollection *);
static void overrideTCDC(UIScreen *self, SEL _cmd, UITraitCollection *previousTrait) {

	origTCDC(self, _cmd, previousTrait);
	[NSNotificationCenter.defaultCenter postNotificationName:AriaTraitCollectionDidChangeNotification object:nil];

}

static void (*origVDLS)(PrysmCardBackgroundViewController *, SEL);
static void overrideVDLS(PrysmCardBackgroundViewController *self, SEL _cmd) {

	origVDLS(self, _cmd);
	new_setPrysmImage(self, _cmd);
	new_setPrysmGradient(self, _cmd);

	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(setPrysmImage) name:AriaDidApplyPrysmImageNotification object:nil];
	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(setPrysmGradient) name:AriaDidApplyPrysmGradientsNotification object:nil];

	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(updatePrysmImage) name:AriaTraitCollectionDidChangeNotification object:nil];

}

static id observer;
static void appDidFinishLaunching() {

	observer = [NSNotificationCenter.defaultCenter addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {

		MSHookMessageEx(kClass(@"UIScreen"), @selector(traitCollectionDidChange:), (IMP) &overrideTCDC, (IMP *) &origTCDC);
		MSHookMessageEx(kClass(@"PrysmCardBackgroundViewController"), @selector(viewDidLayoutSubviews), (IMP) &overrideVDLS, (IMP *) &origVDLS);	

		class_addMethod(
			kClass(@"PrysmCardBackgroundViewController"),
			@selector(setPrysmImage),
			(IMP) &new_setPrysmImage,
			"v@:"
		);

		class_addMethod(
			kClass(@"PrysmCardBackgroundViewController"),
			@selector(updatePrysmImage),
			(IMP) &new_updatePrysmImage,
			"v@:"
		);

		class_addMethod(
			kClass(@"PrysmCardBackgroundViewController"),
			@selector(setPrysmGradient),
			(IMP) &new_setPrysmGradient,
			"v@:"
		);

		class_addMethod(
			kClass(@"PrysmCardBackgroundViewController"),
			@selector(setGradientStartPoint:endPoint:),
			(IMP) &new_setGradientStartAndEndPoint,
			"v@:@@"
		);

		[NSNotificationCenter.defaultCenter removeObserver: observer];

	}];

}

__attribute__((constructor)) static void init() {

	if(!kPrysmExists) return;
	loadWithoutAGoddamnRespring();
	appDidFinishLaunching();

}
