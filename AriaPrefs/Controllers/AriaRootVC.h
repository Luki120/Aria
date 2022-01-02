#import <spawn.h>
#import <Preferences/PSSpecifier.h>
#import <AudioToolbox/AudioServices.h>
#import <Preferences/PSListController.h>
#import "Headers/Common.h"
#import "../Cells/AriaGaussianBlurCell.h"


@interface PSListController (Private)
- (BOOL)containsSpecifier:(PSSpecifier *)arg1;
@end


@interface AriaRootVC : PSListController
@end


@interface AriaPrysmVC : PSListController
@end


@interface AriaStockVC : PSListController
@end


@interface AriaContributorsVC : PSListController
@end


@interface AriaLinksVC : PSListController
@end


@interface PSTableCell ()
- (void)setTitle:(NSString *)t;
@end


@interface AriaTintCell : PSTableCell
@end
