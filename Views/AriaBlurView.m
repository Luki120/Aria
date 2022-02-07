#import "AriaBlurView.h"


@implementation AriaBlurView


+ (AriaBlurView *)sharedInstance {

	static AriaBlurView *sharedInstance = nil;
	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{ sharedInstance = [[self alloc] initPrivate]; });

	return sharedInstance;

}


- (id)initPrivate {

	self = [super init];

	if(self) {

		if(blurView) return self;

		_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];

		blurView = [[AriaBlurView alloc] initWithFrame:CGRectZero autosizesToFitSuperview:YES settings:settings];
		blurView.tag = 120;
		if(kIsPrysm) blurView.alpha = prysmAlpha;
		else blurView.alpha = alpha;
		blurView._blurQuality = @"high";
		blurView.blurRadiusSetOnce = NO;

	}

	return self;

}


- (void)uselessMethodThatllNeverBeCalled { loadWithoutAGoddamnRespring(); }


@end
