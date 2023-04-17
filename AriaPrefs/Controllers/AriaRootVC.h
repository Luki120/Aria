@import AudioToolbox.AudioServices;
@import ObjectiveC.message;
@import Preferences.PSSpecifier;
@import Preferences.PSListController;
#import <spawn.h>
#import "Headers/Common.h"


@interface OBWelcomeController : UIViewController
- (id)initWithTitle:(id)arg1 detailText:(id)arg2 icon:(id)arg3;
- (void)addBulletedListItemWithTitle:(id)arg1 description:(id)arg2 image:(id)arg3;
@end


@interface AriaRootVC : PSListController
@end


@interface AriaContributorsVC : PSListController
@end


@interface AriaLinksVC : PSListController
@end
