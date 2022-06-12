#import "AriaBlurView.h"


@implementation AriaBlurView

- (id)init {

	self = [super init];
	if(!self) return nil;

	self.tag = 120;
	self._blurQuality = @"high";
	self.blurRadiusSetOnce = NO;

	return self;

}

@end
