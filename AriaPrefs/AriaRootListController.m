#include "AriaRootListController.h"




static NSString *takeMeToTheValues = @"/var/mobile/Library/Preferences/me.luki.ariaprefs.plist";


/*static void postNSNotification() {


    [NSDistributedNotificationCenter.defaultCenter postNotificationName:@"imageApplied" object:nil];


}*/




@implementation AriaRootListController


- (NSArray *)specifiers {

	if (!_specifiers) {

		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}


	return _specifiers;

}


- (void)viewDidLoad {
	
	[super viewDidLoad];

//	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)postNSNotification, CFSTR("me.luki.ariaprefs/imageAppliedSuccesfully"), NULL, 0);

}


- (id)readPreferenceValue:(PSSpecifier*)specifier {

    NSMutableDictionary *settings = [NSMutableDictionary dictionary];
    [settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:takeMeToTheValues]];
    return (settings[specifier.properties[@"key"]]) ?: specifier.properties[@"default"];

}


- (void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
    
    NSMutableDictionary *settings = [NSMutableDictionary dictionary];
    [settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:takeMeToTheValues]];
    [settings setObject:value forKey:specifier.properties[@"key"]];
    [settings writeToFile:takeMeToTheValues atomically:YES];

    [NSDistributedNotificationCenter.defaultCenter postNotificationName:@"imageAppliedSuccesfully" object:nil];

}

@end