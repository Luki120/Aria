#import "spawn.h"
#import "Headers/Headers.h"
#import "Constants/Constants.h"
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>
#import "Managers/AriaImageManager.h"
#import <AudioToolbox/AudioServices.h>
#import <Preferences/PSListController.h>
#import <GcUniversal/GcImagePickerUtils.h>


@interface PSListController (Private)
- (BOOL)containsSpecifier:(PSSpecifier *)arg1;
@end


@interface AriaRootVC : PSListController
@end


@interface AriaPrysmVC : PSListController
@property (nonatomic, strong) NSMutableDictionary *savedSpecifiers;
@end


@interface AriaStockVC : PSListController
@property (nonatomic, strong) NSMutableDictionary *savedSpecifiers;
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
