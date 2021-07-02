#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>




@interface AriaTableCell : PSTableCell
@end


@interface AriaRootListController : PSListController
@end


@interface AriaLinksRootListController : PSListController
@end


@interface AriaContributorsRootListController : PSListController
@end


@interface NSDistributedNotificationCenter : NSNotificationCenter
+ (instancetype)defaultCenter;
- (void)postNotificationName:(NSString *)name object:(NSString *)object userInfo:(NSDictionary *)userInfo;
@end