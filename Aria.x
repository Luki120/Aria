#import <UIKit/UIKit.h>
#import "GcImagePickerUtils.h"




@interface NSDistributedNotificationCenter : NSNotificationCenter
+ (instancetype)defaultCenter;
- (void)postNotificationName:(NSString *)name object:(NSString *)object userInfo:(NSDictionary *)userInfo;
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




static void loadWithoutAGoddamnRespring() {


	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:takeMeToTheValues];
	NSMutableDictionary *prefs = dict ? [dict mutableCopy] : [NSMutableDictionary dictionary];
	giveMeTheImage = prefs[@"giveMeTheImage"] ? [prefs[@"giveMeTheImage"] boolValue] : NO;


}




%hook CCUIModularControlCenterOverlayViewController


%property (nonatomic, strong) UIImageView *hotGoodLookingImage;


- (void)viewWillAppear:(BOOL)animated {


	loadWithoutAGoddamnRespring();

	%orig(animated);

	[[self.view viewWithTag:120] removeFromSuperview];


	if(giveMeTheImage) {


		self.overlayBackgroundView.shouldCrossfade = YES;
		

		self.hotGoodLookingImage = [[UIImageView alloc] initWithFrame:self.overlayBackgroundView.bounds];
		self.hotGoodLookingImage.tag = 120;
		if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) self.hotGoodLookingImage.image = [GcImagePickerUtils imageFromDefaults:@"me.luki.ariaprefs" withKey:@"hotGoodLookingImage"];
		else self.hotGoodLookingImage.image = [GcImagePickerUtils imageFromDefaults:@"me.luki.ariaprefs" withKey:@"hotGoodLightLookingImage"];
		self.hotGoodLookingImage.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.overlayBackgroundView insertSubview:self.hotGoodLookingImage atIndex:0];


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




%hook MTMaterialView


- (void)_reduceTransparencyStatusDidChange {


	ancestor = [self _viewControllerForAncestor];


	if(![ancestor isKindOfClass:%c(CCUIModularControlCenterOverlayViewController)]) return;

	%orig;


}


%end




%ctor {


	loadWithoutAGoddamnRespring();


}