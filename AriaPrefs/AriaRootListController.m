#include "AriaRootListController.h"




static NSString *takeMeToTheValues = @"/var/mobile/Library/Preferences/me.luki.ariaprefs.plist";


#define tint [UIColor colorWithRed: 0.62 green: 0.36 blue: 0.91 alpha: 1.00]


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


@implementation AriaContributorsRootListController


- (NSArray *)specifiers {

    if (!_specifiers) {

        _specifiers = [self loadSpecifiersFromPlistName:@"AriaContributors" target:self];
    
    }

    return _specifiers;

}

@end




@implementation AriaLinksRootListController


- (NSArray *)specifiers {

    if (!_specifiers) {

        _specifiers = [self loadSpecifiersFromPlistName:@"AriaLinks" target:self];

    }

    return _specifiers;

}


- (void)discord {


    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://discord.gg/jbE3avwSHs"] options:@{} completionHandler:nil];


}


- (void)paypal {


    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://paypal.me/Luki120"] options:@{} completionHandler:nil];


}


- (void)github {


    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://github.com/Luki120/Aria"] options:@{} completionHandler:nil];


}


- (void)arizona {


    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://repo.twickd.com/get/com.twickd.luki120.arizona"] options:@{} completionHandler:nil];


}


- (void)elixir {


    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://luki120.github.io/"] options:@{} completionHandler:nil];


}


- (void)meredith {


    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://repo.twickd.com/get/com.twickd.luki120.meredith"] options:@{} completionHandler:nil];


}


@end


@implementation AriaTableCell


- (void)tintColorDidChange {

    [super tintColorDidChange];

    self.textLabel.textColor = tint;
    self.textLabel.highlightedTextColor = tint;

}


- (void)refreshCellContentsWithSpecifier:(PSSpecifier *)specifier {

    [super refreshCellContentsWithSpecifier:specifier];

    if ([self respondsToSelector:@selector(tintColor)]) {

        self.textLabel.textColor = tint;
        self.textLabel.highlightedTextColor = tint;

    }
}


@end