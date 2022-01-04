#import "Headers/Headers.h"


static void new_setPrysmImage(PrysmCardBackgroundViewController *self, SEL _cmd) {

	loadWithoutAGoddamnRespring();

	if(prysmGradients) return;

	[[self.view viewWithTag: 10000] removeFromSuperview];
	[[[AriaBlurView sharedInstance]->blurView viewWithTag: 120] removeFromSuperview];

	self.overlayView.hidden = NO;
	self.backdropView.hidden = NO;

	if(!isPrysmImage) return;

	prysmDarkImage = [GcImagePickerUtils imageFromDefaults:kDefaults withKey: kPrysmDarkImage];
	prysmLightImage = [GcImagePickerUtils imageFromDefaults:kDefaults withKey: kPrysmLightImage];

	self.overlayView.hidden = YES;
	self.backdropView.hidden = YES;

	prysmImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
	prysmImageView.tag = 10000;
	prysmImageView.image = kUserInterfaceStyle ? prysmDarkImage : prysmLightImage;
	prysmImageView.contentMode = UIViewContentModeScaleAspectFill;
	prysmImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view insertSubview:prysmImageView atIndex:0];

	[AriaBlurView sharedInstance]->blurView.alpha = prysmAlpha;
	[prysmImageView addSubview:[AriaBlurView sharedInstance]->blurView];

}

static void new_updatePrysmImage(PrysmCardBackgroundViewController *self, SEL _cmd) {

	[UIView transitionWithView:self.view duration:0.8 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{

		prysmImageView.image = kUserInterfaceStyle ? prysmDarkImage : prysmLightImage;

	} completion:nil];

}

static void new_setPrysmGradient(PrysmCardBackgroundViewController *self, SEL _cmd) {

	loadWithoutAGoddamnRespring();

	if(isPrysmImage) return;

	[[self.view viewWithTag:2811] removeFromSuperview];

	self.overlayView.hidden = NO;
	self.backdropView.hidden = NO;

	if(!prysmGradients) return;

	UIColor *firstColor = [GcColorPickerUtils colorFromDefaults:kDefaults withKey:kPrysmGradientFirstColor fallback:@"ffffff"];
	UIColor *secondColor = [GcColorPickerUtils colorFromDefaults:kDefaults withKey:kPrysmGradientSecondColor fallback:@"ffffff"];
	NSArray *gradientColors = [NSArray arrayWithObjects:(id)firstColor.CGColor, (id)secondColor.CGColor, nil];

	self.overlayView.hidden = YES;
	self.backdropView.hidden = YES;

	AriaGradientView *prysmGradientView = [[AriaGradientView alloc] initWithFrame:self.view.bounds];
	prysmGradientView.tag = 2811;
	prysmGradientView.clipsToBounds = YES;
	prysmGradientView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	prysmGradientView.layer.colors = gradientColors;
	[self.view insertSubview:prysmGradientView atIndex:0];

	switch(prysmGradientDirection) {

		case 1: // Top to Bottom

			prysmGradientView.layer.startPoint = CGPointMake(0.5,0);
			prysmGradientView.layer.endPoint = CGPointMake(0.5,1);
			break;

		case 2: // Left to Right

			prysmGradientView.layer.startPoint = CGPointMake(0,0.5);
			prysmGradientView.layer.endPoint = CGPointMake(1,0.5);
			break;

		case 3: // Right to Left

			prysmGradientView.layer.startPoint = CGPointMake(1,0.5);
			prysmGradientView.layer.endPoint = CGPointMake(0,0.5);
			break;

		case 4: // Upper Left lower right

			prysmGradientView.layer.startPoint = CGPointMake(0,0);
			prysmGradientView.layer.endPoint = CGPointMake(1,1);
			break;

		case 5: // Lower left upper right

			prysmGradientView.layer.startPoint = CGPointMake(0,1);
			prysmGradientView.layer.endPoint = CGPointMake(1,0);
			break;

		case 6: // Upper right lower left

			prysmGradientView.layer.startPoint = CGPointMake(1,0);
			prysmGradientView.layer.endPoint = CGPointMake(0,1);
			break;

		case 7: // Lower right upper left

			prysmGradientView.layer.startPoint = CGPointMake(1,1);
			prysmGradientView.layer.endPoint = CGPointMake(0,0);
			break;

		default: // Bottom to Top

			prysmGradientView.layer.startPoint = CGPointMake(0.5,1);
			prysmGradientView.layer.endPoint = CGPointMake(0.5,0);
			break;

	}

	if(!prysmGradientAnimation) return;

	CABasicAnimation *animation = [CABasicAnimation animation];
	animation.keyPath = @"colors";
	animation.fillMode = kCAFillModeBoth;
	animation.duration = 4.5;
	animation.fromValue = [NSArray arrayWithObjects:(id)firstColor.CGColor, (id)secondColor.CGColor, nil];
	animation.toValue = [NSArray arrayWithObjects:(id)secondColor.CGColor, (id)firstColor.CGColor, nil];
	animation.repeatCount = HUGE_VALF; // Loop the animation forever
	animation.autoreverses = YES;
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	animation.removedOnCompletion = NO;
	[prysmGradientView.layer addAnimation:animation forKey:@"animateGradient"];

}

static void (*origTCDC)(UIScreen *self, SEL _cmd, id previousTrait);

static void overrideTCDC(UIScreen *self, SEL _cmd, id previousTrait) {

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

static void(*origADFL)(SpringBoard *self, SEL _cmd, id app);

static void overrideADFL(SpringBoard *self, SEL _cmd, id app) {

	origADFL(self, _cmd, app);

	/*--- initialize the hooks when WE decide it, fuck dlopen, this is better :nfr: ---*/

	MSHookMessageEx(Class(@"UIScreen"), @selector(traitCollectionDidChange:), (IMP) &overrideTCDC, (IMP *) &origTCDC);
	MSHookMessageEx(Class(@"PrysmCardBackgroundViewController"), @selector(viewDidLayoutSubviews), (IMP) &overrideVDLS, (IMP *) &origVDLS);	

	class_addMethod (

		Class(@"PrysmCardBackgroundViewController"),
		@selector(setPrysmImage),
		(IMP)&new_setPrysmImage,
		"v@:"

	);

	class_addMethod (

		Class(@"PrysmCardBackgroundViewController"),
		@selector(updatePrysmImage),
		(IMP)&new_updatePrysmImage,
		"v@:"

	);

	class_addMethod (

		Class(@"PrysmCardBackgroundViewController"),
		@selector(setPrysmGradient),
		(IMP)&new_setPrysmGradient,
		"v@:"

	);

}


__attribute__((constructor)) static void init() {

	if(!kIsPrysm) return;

	loadWithoutAGoddamnRespring();

	MSHookMessageEx(Class(@"SpringBoard"), @selector(applicationDidFinishLaunching:), (IMP) &overrideADFL, (IMP *) &origADFL);

}
