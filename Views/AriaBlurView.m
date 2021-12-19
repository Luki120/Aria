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

		if(!self.blurView) {

			_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];

			self.blurView = [[AriaBlurView alloc] initWithFrame:CGRectZero autosizesToFitSuperview:YES settings:settings];
			self.blurView.tag = 120;
			if(kIsPrysm) self.blurView.alpha = prysmAlpha;
			else self.blurView.alpha = alpha;
			self.blurView._blurQuality = @"high";
			self.blurView.blurRadiusSetOnce = NO;

		}

	}

	return self;

}


- (void)uselessMethodThatllNeverBeCalled { loadWithoutAGoddamnRespring(); }


@end
