@import Preferences.PSSpecifier;
@import Preferences.PSListController;
#import <notify.h>
#import "Managers/AriaImageManager.h"
#import "../Cells/AriaGaussianBlurCell.h"


@interface AriaPrysmVC : PSListController
@end


@interface PSListController ()
- (BOOL)containsSpecifier:(PSSpecifier *)specifier;
@end
