#import "Headers/Headers.h"


%group AriaStock


%hook CCUIModularControlCenterOverlayViewController


%property (nonatomic, strong) UIImageView *ariaImageView;
%property (nonatomic, strong) AriaGradientView *ariaGradientView;


- (void)viewDidLoad { // create a notification observer to force proper dark/light mode in the CC


	%orig;

	[NSNotificationCenter.defaultCenter removeObserver:self];
	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(unleashAriaImage) name:@"traitCollectionDidChange" object:nil];


}


- (void)viewWillAppear:(BOOL)animated {


	%orig(animated);

	[self unleashAriaImage];
	[self setAriaGradient];


}


- (void)_updatePresentationForTransitionState:(CCUIOverlayTransitionState *)state withCompletionHander:(id)handler {


	%orig;
	
	if(giveMeTheImage) {

		self.ariaImageView.alpha = state.clampedPresentationProgress;
		[AriaBlurView sharedInstance].blurView.alpha = state.clampedPresentationProgress * alpha;

	}

	else if(giveMeThoseGradients) self.ariaGradientView.alpha = state.clampedPresentationProgress;


}


%new


- (void)unleashAriaImage { // self explanatory


	loadWithoutAGoddamnRespring();

	[[[AriaBlurView sharedInstance].blurView viewWithTag:120] removeFromSuperview];

	if(!giveMeTheImage) return;

	if(!self.ariaImageView) {

		self.ariaImageView = [[UIImageView alloc] initWithFrame:self.overlayBackgroundView.bounds];
		self.ariaImageView.alpha = MSHookIvar<CCUIOverlayTransitionState*>(self, "_previousTransitionState").clampedPresentationProgress;
		self.ariaImageView.contentMode = UIViewContentModeScaleAspectFill;
		self.ariaImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.overlayBackgroundView insertSubview:self.ariaImageView atIndex:0];

	}

	[self.overlayBackgroundView insertSubview:[AriaBlurView sharedInstance].blurView atIndex:1];

	self.overlayBackgroundView.shouldCrossfade = YES;

	// Hot good looking transition between dark/light mode

	[UIView transitionWithView:self.ariaImageView duration:0.8 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{

		self.ariaImageView.image = (UIScreen.mainScreen.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) ? [GcImagePickerUtils imageFromDefaults:@"me.luki.ariaprefs" withKey:@"hotGoodLookingImage"] : [GcImagePickerUtils imageFromDefaults:@"me.luki.ariaprefs" withKey:@"hotGoodLightLookingImage"];

	} completion:nil];

}


%new


- (void)setAriaGradient {


	loadWithoutAGoddamnRespring();

	[[self.view viewWithTag:2811] removeFromSuperview];


	UIColor *firstColor = [GcColorPickerUtils colorFromDefaults:@"me.luki.ariaprefs" withKey:@"gradientFirstColor" fallback:@"ffffff"];
	UIColor *secondColor = [GcColorPickerUtils colorFromDefaults:@"me.luki.ariaprefs" withKey:@"gradientSecondColor" fallback:@"ffffff"];


	if(giveMeThoseGradients) {


		self.ariaGradientView = [[AriaGradientView alloc] initWithFrame:self.overlayBackgroundView.bounds];
		self.ariaGradientView.tag = 2811;
		self.ariaGradientView.alpha = MSHookIvar<CCUIOverlayTransitionState*>(self, "_previousTransitionState").clampedPresentationProgress;
		self.ariaGradientView.clipsToBounds = YES;
		self.ariaGradientView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.ariaGradientView.layer.colors = [NSArray arrayWithObjects:(id)firstColor.CGColor, (id)secondColor.CGColor, nil];
		self.ariaGradientView.layer.startPoint = CGPointMake(0.5,1); // Bottom to top, default
		self.ariaGradientView.layer.endPoint = CGPointMake(0.5,0);
		[self.overlayBackgroundView insertSubview:self.ariaGradientView atIndex:0];

		self.overlayBackgroundView.shouldCrossfade = YES;


	}


	if(neatGradientAnimation) {

			
		CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"colors"];
		animation.fromValue = [NSArray arrayWithObjects:(id)firstColor.CGColor, (id)secondColor.CGColor, nil];
		animation.toValue = [NSArray arrayWithObjects:(id)secondColor.CGColor, (id)firstColor.CGColor, nil];
		animation.fillMode = kCAFillModeBoth;
		animation.duration = 4.5;
		animation.repeatCount = HUGE_VALF; // Loop the animation forever
		animation.autoreverses = YES;
		animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
		animation.removedOnCompletion = NO;
		[self.ariaGradientView.layer addAnimation:animation forKey:@"animateGradient"];


	}


	switch(gradientDirection) {


		case 0: // Bottom to Top

			self.ariaGradientView.layer.startPoint = CGPointMake(0.5,1);
			self.ariaGradientView.layer.endPoint = CGPointMake(0.5,0);
			break;


		case 1: // Top to Bottom

			self.ariaGradientView.layer.startPoint = CGPointMake(0.5,0);
			self.ariaGradientView.layer.endPoint = CGPointMake(0.5,1);
			break;


		case 2: // Left to Right

			self.ariaGradientView.layer.startPoint = CGPointMake(0,0.5);
			self.ariaGradientView.layer.endPoint = CGPointMake(1,0.5);
			break;


		case 3: // Right to Left

			self.ariaGradientView.layer.startPoint = CGPointMake(1,0.5);
			self.ariaGradientView.layer.endPoint = CGPointMake(0,0.5);
			break;


		case 4: // Upper Left lower right

			self.ariaGradientView.layer.startPoint = CGPointMake(0,0);
			self.ariaGradientView.layer.endPoint = CGPointMake(1,1);
			break;


		case 5: // Lower left upper right

			self.ariaGradientView.layer.startPoint = CGPointMake(0,1);
			self.ariaGradientView.layer.endPoint = CGPointMake(1,0);
			break;


		case 6: // Upper right lower left

			self.ariaGradientView.layer.startPoint = CGPointMake(1,0);
			self.ariaGradientView.layer.endPoint = CGPointMake(0,1);
			break;


		case 7: // Lower right upper left

			self.ariaGradientView.layer.startPoint = CGPointMake(1,1);
			self.ariaGradientView.layer.endPoint = CGPointMake(0,0);
			break;


	}

}


%end




%hook UIScreen


- (void)traitCollectionDidChange:(id)previous {


	%orig;

	[NSNotificationCenter.defaultCenter postNotificationName:@"traitCollectionDidChange" object:nil];


}


%end
%end




%ctor {

	NSFileManager *fileM = [NSFileManager defaultManager];

	if([fileM fileExistsAtPath:@"Library/MobileSubstrate/DynamicLibraries/Prysm.dylib"]) return;

	loadWithoutAGoddamnRespring();

	%init(AriaStock);

}