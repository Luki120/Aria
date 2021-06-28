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
- (id)_viewControllerForAncestor;
@end


@interface CCUIModularControlCenterOverlayViewController : UIViewController
@property (nonatomic, retain) MTMaterialView *overlayBackgroundView;
@property (nonatomic, strong) UIImageView *hotGoodLookingImage;
- (void)unleashThatHotGoodLookingImage;
@end


UIViewController *ancestor;


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


%property (nonatomic, strong) UIImageView *hotGoodLookingImage;


- (void)viewWillAppear:(BOOL)animated {


	%orig(animated);

	loadWithoutAGoddamnRespring();

	[[self.view viewWithTag:120] removeFromSuperview];
	[[self.view viewWithTag:1337] removeFromSuperview];


	if(giveMeTheImage) {


		self.overlayBackgroundView.shouldCrossfade = YES;
		

		self.hotGoodLookingImage = [[UIImageView alloc] initWithFrame:self.overlayBackgroundView.bounds];
		self.hotGoodLookingImage.tag = 120;

		if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) self.hotGoodLookingImage.image = [GcImagePickerUtils imageFromDefaults:@"me.luki.ariaprefs" withKey:@"hotGoodLookingImage"];
		else self.hotGoodLookingImage.image = [GcImagePickerUtils imageFromDefaults:@"me.luki.ariaprefs" withKey:@"hotGoodLightLookingImage"];
		
		self.hotGoodLookingImage.contentMode = UIViewContentModeScaleAspectFill;
		self.hotGoodLookingImage.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.overlayBackgroundView insertSubview:self.hotGoodLookingImage atIndex:0];


		_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];

		_UIBackdropView *blurView = [[_UIBackdropView alloc] initWithFrame:CGRectZero
		autosizesToFitSuperview:YES settings:settings];
		blurView.blurRadiusSetOnce = NO;
		blurView._blurRadius = 80.0;
		blurView._blurQuality = @"high";
		blurView.tag = 1337;
		blurView.alpha = alpha;
		[self.overlayBackgroundView insertSubview:blurView atIndex:1];

	
	}

}


- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {

 
	%orig(previousTraitCollection);


	if(previousTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark)


		self.hotGoodLookingImage.image = [GcImagePickerUtils imageFromDefaults:@"me.luki.ariaprefs" withKey:@"hotGoodLightLookingImage"];


	else


		self.hotGoodLookingImage.image = [GcImagePickerUtils imageFromDefaults:@"me.luki.ariaprefs" withKey:@"hotGoodLookingImage"];


}


%end




%ctor {


	loadWithoutAGoddamnRespring();


}