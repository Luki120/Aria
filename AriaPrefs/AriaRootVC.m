#include "AriaRootVC.h"




static NSString *takeMeToTheValues = @"/var/mobile/Library/Preferences/me.luki.ariaprefs.plist";


#define tint [UIColor colorWithRed: 0.62 green: 0.36 blue: 0.91 alpha: 1.00]


static void postNSNotification() {

	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"prysmImageApplied" object:nil];
	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"prysmGradientsApplied" object:nil];

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


- (id)init {

	self = [super init];

	if(self) {

		UIButton *infoButton =  [UIButton buttonWithType:UIButtonTypeCustom];
		infoButton.frame = CGRectMake(0,0,30,30);
		infoButton.tintColor = [UIColor colorWithRed: 0.62 green: 0.36 blue: 0.91 alpha: 1.00];
		infoButton.layer.cornerRadius = infoButton.frame.size.height / 2;
		infoButton.layer.masksToBounds = YES;
		[infoButton setImage:[UIImage systemImageNamed:@"infinity"] forState:UIControlStateNormal];
		[infoButton addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];

		UIBarButtonItem *changelogButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
		self.navigationItem.rightBarButtonItem = changelogButtonItem;

	}

	return self;

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


- (void)buttonTapped {

	AudioServicesPlaySystemSound(1521);

	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Aria" message:@"The options you enable here will only inject if you either don't have Prysm installed or disabled it only with iCleaner Pro." preferredStyle:UIAlertControllerStyleAlert];

	UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Gotcha" style:UIAlertActionStyleCancel handler:nil];

	[alert addAction:dismissAction];

	[self presentViewController:alert animated:YES completion:nil];

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

	if(!_specifiers) {

		_specifiers = [self loadSpecifiersFromPlistName:@"AriaPrysm" target:self];

		NSArray *chosenIDs = @[@"GroupCell-1", @"DarkPrysmImage", @"GroupCell-2", @"PrysmBlur", @"GroupCell-3", @"PRYAnimateGradientSwitch", @"GroupCell-4", @"PRYGFirstColor", @"PRYGSecondColor", @"GroupCell-5", @"PRYGradientDirection"];

		self.savedSpecifiers = (self.savedSpecifiers) ?: [NSMutableDictionary new];

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


	if(![[self readPreferenceValue:[self specifierForID:@"PRYGradientSwitch"]] boolValue])

		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell-3"], self.savedSpecifiers[@"PRYAnimateGradientSwitch"], self.savedSpecifiers[@"GroupCell-4"], self.savedSpecifiers[@"PRYGFirstColor"], self.savedSpecifiers[@"PRYGSecondColor"], self.savedSpecifiers[@"GroupCell-5"], self.savedSpecifiers[@"PRYGradientDirection"]] animated:NO];


	else if(![[self readPreferenceValue:[self specifierForID:@"GroupCell-3"]] boolValue])

		[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell-3"], self.savedSpecifiers[@"PRYAnimateGradientSwitch"], self.savedSpecifiers[@"GroupCell-4"], self.savedSpecifiers[@"PRYGFirstColor"], self.savedSpecifiers[@"PRYGSecondColor"], self.savedSpecifiers[@"GroupCell-5"], self.savedSpecifiers[@"PRYGradientDirection"]] afterSpecifierID:@"PRYGradientSwitch" animated:NO];


}


- (void)viewDidLoad {


	[super viewDidLoad];
	[self reloadSpecifiers];

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)postNSNotification, CFSTR("me.luki.ariaprefs/prysmImageChanged"), NULL, 0);
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)postNSNotification, CFSTR("me.luki.ariaprefs/prysmGradientColorsChanged"), NULL, 0);

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
	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"prysmGradientsApplied" object:nil];

	NSString *key = [specifier propertyForKey:@"key"];

	if([key isEqualToString:@"isPrysmImage"]) {


		if(![[self readPreferenceValue:[self specifierForID:@"PrysmSwitch"]] boolValue])

			[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell-1"], self.savedSpecifiers[@"DarkPrysmImage"], self.savedSpecifiers[@"GroupCell-2"], self.savedSpecifiers[@"PrysmBlur"]] animated:YES];


		else if(![self containsSpecifier:self.savedSpecifiers[@"GroupCell-1"]])

			[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell-1"], self.savedSpecifiers[@"DarkPrysmImage"], self.savedSpecifiers[@"GroupCell-2"], self.savedSpecifiers[@"PrysmBlur"]] afterSpecifierID:@"PrysmSwitch" animated:YES];


	}


	if([key isEqualToString:@"prysmGradients"]) {


		if(![[self readPreferenceValue:[self specifierForID:@"PRYGradientSwitch"]] boolValue])

		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell-3"], self.savedSpecifiers[@"PRYAnimateGradientSwitch"], self.savedSpecifiers[@"GroupCell-4"], self.savedSpecifiers[@"PRYGFirstColor"], self.savedSpecifiers[@"PRYGSecondColor"], self.savedSpecifiers[@"GroupCell-5"], self.savedSpecifiers[@"PRYGradientDirection"]] animated:YES];


		else if(![[self readPreferenceValue:[self specifierForID:@"GroupCell-3"]] boolValue])

		[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell-3"], self.savedSpecifiers[@"PRYAnimateGradientSwitch"], self.savedSpecifiers[@"GroupCell-4"], self.savedSpecifiers[@"PRYGFirstColor"], self.savedSpecifiers[@"PRYGSecondColor"], self.savedSpecifiers[@"GroupCell-5"], self.savedSpecifiers[@"PRYGradientDirection"]] afterSpecifierID:@"PRYGradientSwitch" animated:YES];


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