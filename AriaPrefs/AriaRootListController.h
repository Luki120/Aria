#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>




@interface AriaTableCell : PSTableCell
@end


@interface PSListController (Private)
- (BOOL)containsSpecifier:(PSSpecifier *)arg1;
@end


@interface AriaRootListController : PSListController
@property (nonatomic, retain) NSMutableDictionary *savedSpecifiers;
@end


@interface AriaPrysmRootListController : PSListController
@end


@interface AriaLinksRootListController : PSListController
@end


@interface AriaContributorsRootListController : PSListController
@end


@interface NSDistributedNotificationCenter : NSNotificationCenter
+ (instancetype)defaultCenter;
- (void)postNotificationName:(NSString *)name object:(NSString *)object userInfo:(NSDictionary *)userInfo;
@end