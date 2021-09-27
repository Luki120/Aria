#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>




@interface AriaRootVC : PSListController
@property (nonatomic, strong) NSMutableDictionary *savedSpecifiers;
@end


@interface PSListController (Private)
- (BOOL)containsSpecifier:(PSSpecifier *)arg1;
@end


@interface AriaPrysmVC : PSListController
@property (nonatomic, strong) NSMutableDictionary *savedSpecifiers;
@end


@interface AriaLinksVC : PSListController
@end


@interface AriaContributorsVC : PSListController
@end


@interface AriaTableCell : PSTableCell
@end


@interface NSDistributedNotificationCenter : NSNotificationCenter
+ (instancetype)defaultCenter;
- (void)postNotificationName:(NSString *)name object:(NSString *)object userInfo:(NSDictionary *)userInfo;
@end