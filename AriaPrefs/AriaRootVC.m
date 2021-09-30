#include "AriaRootVC.h"




static NSString *takeMeToTheValues = @"/var/mobile/Library/Preferences/me.luki.ariaprefs.plist";


#define tint [UIColor colorWithRed: 0.62 green: 0.36 blue: 0.91 alpha: 1.00]


static void postNSNotification() {

	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"prysmImageApplied" object:nil];

}



@implementation AriaRootVC


- (NSArray *)specifiers {

	if(!_specifiers) {

		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];

		NSArray *chosenIDs = @[@"GroupCell1", @"DarkImage", @"LightImage", @"GroupCell3", @"BlurSlider", @"GroupCell5", @"AnimateGradientSwitch", @"GroupCell7", @"GFirstColor", @"GSecondColor", @"GroupCell8", @"GradientDirections"];

		self.savedSpecifiers = (self.savedSpecifiers) ?: [[NSMutableDictionary alloc] init];

		for(PSSpecifier *specifier in _specifiers)

			if([chosenIDs containsObject:[specifier propertyForKey:@"id"]])

				[self.savedSpecifiers setObject:specifier forKey:[specifier propertyForKey:@"id"]];


	}

	return _specifiers;

}


- (void)reloadSpecifiers { // Dynamic specifiers


	[super reloadSpecifiers];


	if(![[self readPreferenceValue:[self specifierForID:@"ImageSwitch"]] boolValue])

		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell1"], self.savedSpecifiers[@"DarkImage"], self.savedSpecifiers[@"LightImage"], self.savedSpecifiers[@"GroupCell3"], self.savedSpecifiers[@"BlurSlider"]] animated:NO];


	else if(![self containsSpecifier:self.savedSpecifiers[@"GroupCell1"]])

		[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell1"], self.savedSpecifiers[@"DarkImage"], self.savedSpecifiers[@"LightImage"], self.savedSpecifiers[@"GroupCell3"], self.savedSpecifiers[@"BlurSlider"]] afterSpecifierID:@"ImageSwitch" animated:NO];


	if(![[self readPreferenceValue:[self specifierForID:@"GradientSwitch"]] boolValue])

		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell5"], self.savedSpecifiers[@"AnimateGradientSwitch"], self.savedSpecifiers[@"GroupCell7"], self.savedSpecifiers[@"GFirstColor"], self.savedSpecifiers[@"GSecondColor"], self.savedSpecifiers[@"GroupCell8"], self.savedSpecifiers[@"GradientDirections"]] animated:NO];


	else if(![self containsSpecifier:self.savedSpecifiers[@"GroupCell5"]])

		[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell5"], self.savedSpecifiers[@"AnimateGradientSwitch"], self.savedSpecifiers[@"GroupCell7"], self.savedSpecifiers[@"GFirstColor"], self.savedSpecifiers[@"GSecondColor"], self.savedSpecifiers[@"GroupCell8"], self.savedSpecifiers[@"GradientDirections"]] afterSpecifierID:@"GradientSwitch" animated:NO];


}


- (void)viewDidLoad {


	[super viewDidLoad];
	[self reloadSpecifiers];


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
	
	NSString *key = [specifier propertyForKey:@"key"];


	if([key isEqualToString:@"giveMeTheImage"]) {


		if(![value boolValue])

			[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell1"], self.savedSpecifiers[@"DarkImage"], self.savedSpecifiers[@"LightImage"], self.savedSpecifiers[@"GroupCell3"], self.savedSpecifiers[@"BlurSlider"]] animated:YES];


		else if(![self containsSpecifier:self.savedSpecifiers[@"GroupCell1"]])

			[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell1"], self.savedSpecifiers[@"DarkImage"], self.savedSpecifiers[@"LightImage"], self.savedSpecifiers[@"GroupCell3"], self.savedSpecifiers[@"BlurSlider"]] afterSpecifierID:@"ImageSwitch" animated:YES];


	}


	if([key isEqualToString:@"giveMeThoseGradients"]) {


		if(![[self readPreferenceValue:[self specifierForID:@"GradientSwitch"]] boolValue])

			[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell5"], self.savedSpecifiers[@"AnimateGradientSwitch"], self.savedSpecifiers[@"GroupCell7"], self.savedSpecifiers[@"GFirstColor"], self.savedSpecifiers[@"GSecondColor"], self.savedSpecifiers[@"GroupCell8"], self.savedSpecifiers[@"GradientDirections"]] animated:YES];


		else if (![self containsSpecifier:self.savedSpecifiers[@"GroupCell5"]])

			[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell5"], self.savedSpecifiers[@"AnimateGradientSwitch"], self.savedSpecifiers[@"GroupCell7"], self.savedSpecifiers[@"GFirstColor"], self.savedSpecifiers[@"GSecondColor"], self.savedSpecifiers[@"GroupCell8"], self.savedSpecifiers[@"GradientDirections"]] afterSpecifierID:@"GradientSwitch" animated:YES];


	}

}


@end


@implementation AriaPrysmVC


- (NSArray *)specifiers {

	if (!_specifiers) {

		_specifiers = [self loadSpecifiersFromPlistName:@"AriaPrysm" target:self];

		NSArray *chosenIDs = @[@"GroupCell-1", @"DarkPrysmImage", @"GroupCell-2", @"PrysmBlur"];

		self.savedSpecifiers = (self.savedSpecifiers) ?: [[NSMutableDictionary alloc] init];

		for(PSSpecifier *specifier in _specifiers)

			if([chosenIDs containsObject:[specifier propertyForKey:@"id"]])

				[self.savedSpecifiers setObject:specifier forKey:[specifier propertyForKey:@"id"]];
	
	}

	return _specifiers;

}


- (void)reloadSpecifiers { // Dynamic specifiers


	[super reloadSpecifiers];


	if(![[self readPreferenceValue:[self specifierForID:@"PrysmSwitch"]] boolValue])

		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell-1"], self.savedSpecifiers[@"DarkPrysmImage"], self.savedSpecifiers[@"GroupCell-2"], self.savedSpecifiers[@"PrysmBlur"]] animated:NO];


	else if(![self containsSpecifier:self.savedSpecifiers[@"GroupCell-1"]])

		[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell-1"], self.savedSpecifiers[@"DarkPrysmImage"], self.savedSpecifiers[@"GroupCell-2"], self.savedSpecifiers[@"PrysmBlur"]] afterSpecifierID:@"PrysmSwitch" animated:NO];


}


- (void)viewDidLoad {


	[super viewDidLoad];
	[self reloadSpecifiers];

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)postNSNotification, CFSTR("me.luki.ariaprefs/prysmImageChanged"), NULL, 0);

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

	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"prysmImageApplied" object:nil];

	NSString *key = [specifier propertyForKey:@"key"];

	if([key isEqualToString:@"isPrysmImage"]) {


		if(![[self readPreferenceValue:[self specifierForID:@"PrysmSwitch"]] boolValue])

			[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell-1"], self.savedSpecifiers[@"DarkPrysmImage"], self.savedSpecifiers[@"GroupCell-2"], self.savedSpecifiers[@"PrysmBlur"]] animated:YES];


		else if(![self containsSpecifier:self.savedSpecifiers[@"GroupCell-1"]])

			[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell-1"], self.savedSpecifiers[@"DarkPrysmImage"], self.savedSpecifiers[@"GroupCell-2"], self.savedSpecifiers[@"PrysmBlur"]] afterSpecifierID:@"PrysmSwitch" animated:YES];


	}

}


@end


@implementation AriaContributorsVC


- (NSArray *)specifiers {

	if (!_specifiers) {

		_specifiers = [self loadSpecifiersFromPlistName:@"AriaContributors" target:self];
	
	}

	return _specifiers;

}

@end




@implementation AriaLinksVC


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


- (void)elixir {


	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://luki120.github.io/depictions/web/?p=me.luki.elixir"] options:@{} completionHandler:nil];


}


- (void)marie {


	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://luki120.github.io/depictions/web/?p=me.luki.marie"] options:@{} completionHandler:nil];


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