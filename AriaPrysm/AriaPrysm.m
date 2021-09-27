#import "Headers/Headers.h"


void new_setPrysmImage(PrysmCardBackgroundViewController *self, SEL _cmd) {

	loadWithoutAGoddamnRespring();

	[[self.view viewWithTag:10000] removeFromSuperview];
	[[[AriaBlurView sharedInstance].blurView viewWithTag:120] removeFromSuperview];

	if(isPrysmImage) {

		self.overlayView.hidden = YES;
		self.backdropView.hidden = YES;

		UIImageView *prysmImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
		prysmImageView.tag = 10000;
		prysmImageView.image = [GcImagePickerUtils imageFromDefaults:@"me.luki.ariaprefs" withKey:@"prysmImage"];
		prysmImageView.contentMode = UIViewContentModeScaleAspectFill;
		prysmImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.view insertSubview:prysmImageView atIndex:0];
		[prysmImageView addSubview:[AriaBlurView sharedInstance].blurView];
	
	} else {

		self.overlayView.hidden = NO;
		self.backdropView.hidden = NO;

	}

}


void (*origVDLS)(PrysmCardBackgroundViewController *self, SEL _cmd);

void overrideVDLS(PrysmCardBackgroundViewController *self, SEL _cmd) {

	origVDLS(self, _cmd);

	new_setPrysmImage(self, _cmd);

	[NSDistributedNotificationCenter.defaultCenter removeObserver:self];
	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(setPrysmImage) name:@"prysmImageApplied" object:nil];


}


void(*origApplicationDidFinishLaunching)(SpringBoard *self, SEL _cmd, id app);

void overrideApplicationDidFinishLaunching(SpringBoard *self, SEL _cmd, id app) {

	origApplicationDidFinishLaunching(self, _cmd, app);

	MSHookMessageEx(NSClassFromString(@"PrysmCardBackgroundViewController"), @selector(viewDidLayoutSubviews), (IMP) &overrideVDLS, (IMP *) &origVDLS);

	class_addMethod (
		
		NSClassFromString(@"PrysmCardBackgroundViewController"),
		@selector(setPrysmImage),
		(IMP)&new_setPrysmImage,
		"v@:"

	);

}


__attribute__((constructor)) static void init() {

	NSFileManager *fileM = [NSFileManager defaultManager];

	if(![fileM fileExistsAtPath:@"Library/MobileSubstrate/DynamicLibraries/Prysm.dylib"]) return;

	loadWithoutAGoddamnRespring();

	MSHookMessageEx(NSClassFromString(@"SpringBoard"), @selector(applicationDidFinishLaunching:), (IMP) &overrideApplicationDidFinishLaunching, (IMP *) &origApplicationDidFinishLaunching);

}
