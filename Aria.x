#import <UIKit/UIKit.h>
#import "GcImagePickerUtils.h"




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
- (void)unleashThatHotGoodLookingImage;
@end


static NSString *takeMeToTheValues = @"/var/mobile/Library/Preferences/me.luki.ariaprefs.plist";

static BOOL giveMeTheImage;

float alpha = 1.0f;


static void loadWithoutAGoddamnRespring() {


	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:takeMeToTheValues];
	NSMutableDictionary *prefs = dict ? [dict mutableCopy] : [NSMutableDictionary dictionary];
	
	giveMeTheImage = prefs[@"giveMeTheImage"] ? [prefs[@"giveMeTheImage"] boolValue] : NO;
	alpha = prefs[@"alpha"] ? [prefs[@"alpha"] floatValue] : 1.0f;


}




%hook CCUIModularControlCenterOverlayViewController


%property (nonatomic, strong) UIImageView *hotGoodLookingImageView;
%property (nonatomic, strong) _UIBackdropView *blurView;


- (void)viewDidLoad { // create a notification observer to force dark/light mode in the CC


	%orig;
	
	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(unleashThatHotGoodLookingImage) name:@"traitCollectionDidChange" object:nil];


}


- (void)viewWillAppear:(BOOL)animated {


	%orig(animated);
	
	[self unleashThatHotGoodLookingImage];


}


%new


- (void)unleashThatHotGoodLookingImage { // self explanatory
	

	loadWithoutAGoddamnRespring();

	[[self.blurView viewWithTag:120] removeFromSuperview];


	if(giveMeTheImage) {


		if(!self.hotGoodLookingImageView) {


			self.hotGoodLookingImageView = [[UIImageView alloc] initWithFrame:self.overlayBackgroundView.bounds];
			self.hotGoodLookingImageView.contentMode = UIViewContentModeScaleAspectFill;
			self.hotGoodLookingImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
			[self.overlayBackgroundView insertSubview:self.hotGoodLookingImageView atIndex:0];

		
		}


		self.overlayBackgroundView.shouldCrossfade = YES;
		

		// Hot good looking transition between dark/light mode

		[UIView transitionWithView:self.hotGoodLookingImageView duration:0.8 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{


			if (UIScreen.mainScreen.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) self.hotGoodLookingImageView.image = [GcImagePickerUtils imageFromDefaults:@"me.luki.ariaprefs" withKey:@"hotGoodLookingImage"];
			else self.hotGoodLookingImageView.image = [GcImagePickerUtils imageFromDefaults:@"me.luki.ariaprefs" withKey:@"hotGoodLightLookingImage"];
		
		
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
