#import "Headers/Headers.h"
#import "Headers/Prefs.h"


%group AriaStock


%hook CCUIModularControlCenterOverlayViewController


%property (nonatomic, strong) UIImageView *ariaImageView;
%property (nonatomic, strong) AriaGradientView *ariaGradientView;


- (void)viewDidLoad { // create a notification observer to force proper dark/light mode in the CC

	%orig;

	_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle: 2];
	ariaBlurView = [[AriaBlurView alloc] initWithFrame:CGRectZero autosizesToFitSuperview:YES settings:settings];

	[NSNotificationCenter.defaultCenter removeObserver:self];
	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(unleashAriaImage) name:@"traitCollectionDidChange" object:nil];

}


- (void)viewWillAppear:(BOOL)animated {

	%orig(animated);

	[self unleashAriaImage];
	[self unleashAriaGradients];

}


- (void)_updatePresentationForTransitionState:(CCUIOverlayTransitionState *)state withCompletionHander:(id)handler {

	%orig;

	if(giveMeTheImage) {
		self.ariaImageView.alpha = state.clampedPresentationProgress;
		ariaBlurView.alpha = state.clampedPresentationProgress * alpha;
	}

	else if(giveMeThoseGradients) self.ariaGradientView.alpha = state.clampedPresentationProgress;

}


%new

- (void)unleashAriaImage { // self explanatory

	loadWithoutAGoddamnRespring();

	[[ariaBlurView viewWithTag: 120] removeFromSuperview];

	if(!giveMeTheImage) return;

	UIImage *stockDarkImage = [GcImagePickerUtils imageFromDefaults:kDefaults withKey: kStockDarkImage];
	UIImage *stockLightImage = [GcImagePickerUtils imageFromDefaults:kDefaults withKey: kStockLightImage];

	if(!self.ariaImageView) {

		self.ariaImageView = [[UIImageView alloc] initWithFrame: self.overlayBackgroundView.bounds];
		self.ariaImageView.alpha = MSHookIvar<CCUIOverlayTransitionState *>(self, "_previousTransitionState").clampedPresentationProgress;
		self.ariaImageView.contentMode = UIViewContentModeScaleAspectFill;
		self.ariaImageView.clipsToBounds = YES;
		self.ariaImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.overlayBackgroundView insertSubview:self.ariaImageView atIndex:0];

	}

	self.overlayBackgroundView.shouldCrossfade = YES;

	// Clean af transition between dark/light mode

	[UIView transitionWithView:self.ariaImageView duration:0.8 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{

		self.ariaImageView.image = kUserInterfaceStyle ? stockDarkImage : stockLightImage;

	} completion:nil];

	ariaBlurView.alpha = alpha;
	[self.overlayBackgroundView insertSubview:ariaBlurView atIndex:1];

}


%new

- (void)unleashAriaGradients {

	loadWithoutAGoddamnRespring();

	[[self.view viewWithTag: 2811] removeFromSuperview];

	if(!giveMeThoseGradients) return;

	UIColor *firstColor = [GcColorPickerUtils colorFromDefaults:kDefaults withKey:kStockGradientFirstColor fallback:@"ffffff"];
	UIColor *secondColor = [GcColorPickerUtils colorFromDefaults:kDefaults withKey:kStockGradientSecondColor fallback:@"ffffff"];
	NSArray *gradientColors = [NSArray arrayWithObjects:(id)firstColor.CGColor, (id)secondColor.CGColor, nil];

	self.ariaGradientView = [[AriaGradientView alloc] initWithFrame: self.view.bounds];
	self.ariaGradientView.tag = 2811;
	self.ariaGradientView.alpha = MSHookIvar<CCUIOverlayTransitionState *>(self, "_previousTransitionState").clampedPresentationProgress;
	self.ariaGradientView.clipsToBounds = YES;
	self.ariaGradientView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.ariaGradientView.layer.colors = gradientColors;
	[self.overlayBackgroundView insertSubview:self.ariaGradientView atIndex:0];

	self.overlayBackgroundView.shouldCrossfade = YES;

	switch(gradientDirection) {

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

	if(!neatGradientAnimation) return;

	CABasicAnimation *animation = [CABasicAnimation animation];
	animation.keyPath = @"colors";
	animation.duration =  4.5;
	animation.fromValue = [NSArray arrayWithObjects:(id)firstColor.CGColor, (id)secondColor.CGColor, nil];
	animation.toValue = [NSArray arrayWithObjects:(id)secondColor.CGColor, (id)firstColor.CGColor, nil];
	animation.repeatCount = HUGE_VALF; // Loop the animation forever
	animation.autoreverses = YES;
	animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
	[self.ariaGradientView.layer addAnimation:animation forKey: @"gradientAnimation"];

}


%new

- (void)setGradientStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {

	self.ariaGradientView.layer.startPoint = startPoint;
	self.ariaGradientView.layer.endPoint = endPoint;

}


%end


%hook UIScreen


- (void)traitCollectionDidChange:(UITraitCollection *)previousTrait {

	%orig;
	[NSNotificationCenter.defaultCenter postNotificationName:@"traitCollectionDidChange" object:nil];

}


%end
%end


%ctor {

	if(kPrysmExists) return;
	loadWithoutAGoddamnRespring();
	%init(AriaStock);

}
