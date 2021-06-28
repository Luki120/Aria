#include "AriaRootListController.h"




static NSString *takeMeToTheValues = @"/var/mobile/Library/Preferences/me.luki.ariaprefs.plist";




@implementation AriaRootListController


- (NSArray *)specifiers {

	if (!_specifiers) {

		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}


	return _specifiers;

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

}

@end