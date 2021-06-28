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
@property (nonatomic, strong) UIImageView *hotGoodLookingImageView;
@property (nonatomic, strong) _UIBackdropView *blurView;
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


%hook UIScreen
-(void)traitCollectionDidChange:(id)previous{
	%orig;
	
	[NSNotificationCenter.defaultCenter postNotificationName:@"traitCollectionDidChange" object:NULL];
}
%end

%hook CCUIModularControlCenterOverlayViewController


%property (nonatomic, strong) UIImageView *hotGoodLookingImageView;
%property (nonatomic, strong) _UIBackdropView *blurView;

-(void)viewDidLoad{
	%orig;
	
	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(unleashThatHotGoodLookingImage) name:@"traitCollectionDidChange" object:NULL];
}

- (void)viewWillAppear:(BOOL)animated {


	%orig(animated);
	
	[self unleashThatHotGoodLookingImage];

}

%new
- (void)unleashThatHotGoodLookingImage{
	loadWithoutAGoddamnRespring();
	
	if(giveMeTheImage) {
		if(!self.hotGoodLookingImageView){
			self.hotGoodLookingImageView = [[UIImageView alloc] initWithFrame:self.overlayBackgroundView.bounds];
			self.hotGoodLookingImageView.contentMode = UIViewContentModeScaleAspectFill;
			self.hotGoodLookingImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
			[self.overlayBackgroundView insertSubview:self.hotGoodLookingImageView atIndex:0];
		}

		self.overlayBackgroundView.shouldCrossfade = YES;
		

		

		if (UIScreen.mainScreen.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) self.hotGoodLookingImageView.image = [GcImagePickerUtils imageFromDefaults:@"me.luki.ariaprefs" withKey:@"hotGoodLookingImage"];
		else self.hotGoodLookingImageView.image = [GcImagePickerUtils imageFromDefaults:@"me.luki.ariaprefs" withKey:@"hotGoodLightLookingImage"];
		
		
		if(!self.blurView){
			_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];

			self.blurView = [[_UIBackdropView alloc] initWithFrame:CGRectZero autosizesToFitSuperview:YES settings:settings];
			self.blurView.blurRadiusSetOnce = NO;
			self.blurView._blurRadius = 80.0;
			self.blurView._blurQuality = @"high";
			self.blurView.alpha = alpha;
			[self.overlayBackgroundView insertSubview:self.blurView atIndex:1];
		}

		

	
	} else{
		[self.hotGoodLookingImageView removeFromSuperview];
		self.hotGoodLookingImageView = NULL;
		
		[self.blurView removeFromSuperview];
		self.blurView = NULL;
	}
}


%end




%ctor {


	loadWithoutAGoddamnRespring();


}