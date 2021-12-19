#import "AriaRootVC.h"


@implementation AriaRootVC


- (NSArray *)specifiers {

	if(!_specifiers) _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];

	return _specifiers;

}


- (void)shatterThePrefsToPieces {

	AudioServicesPlaySystemSound(1521);

	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Aria" message:@"Do you want to start fresh?" preferredStyle:UIAlertControllerStyleAlert];

	UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Shoot" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {

		NSFileManager *fileM = [NSFileManager defaultManager];

		[fileM removeItemAtPath:@"/var/mobile/Library/Preferences/me.luki.ariaprefs/" error:nil];
		[fileM removeItemAtPath:@"/var/mobile/Library/Preferences/me.luki.ariaprefs.plist" error:nil];

		[self crossDissolveBlur];

	}];

	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Meh" style:UIAlertActionStyleCancel handler:nil];

	[alertController addAction:confirmAction];
	[alertController addAction:cancelAction];

	[self presentViewController:alertController animated:YES completion:nil];

}


- (void)crossDissolveBlur {

	_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];

	_UIBackdropView *backdropView = [[_UIBackdropView alloc] initWithSettings:settings];
	backdropView.alpha = 0;
	backdropView.frame = self.view.bounds;
	backdropView.clipsToBounds = YES;
	backdropView.layer.masksToBounds = YES;
	[self.view addSubview:backdropView];

	[UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{

		backdropView.alpha = 1;

	} completion:^(BOOL finished) { [self launchRespring]; }];

}


- (void)launchRespring {

	pid_t pid;
	const char* args[] = {"sbreload", NULL, NULL, NULL};
	posix_spawn(&pid, "/usr/bin/sbreload", NULL, NULL, (char* const*)args, NULL);

}


@end


@implementation AriaPrysmVC


- (NSArray *)specifiers {

	if(!_specifiers) {

		_specifiers = [self loadSpecifiersFromPlistName:@"AriaPrysm" target:self];

		NSArray *chosenIDs = @[

			@"GroupCell-1",
			@"DarkPrysmImage",
			@"LightPrysmImage",
			@"GroupCell-2",
			@"PrysmBlurSlider",
			@"PRYGaussianGroupCell",
			@"PRYGaussianBlurButton",
			@"GroupCell-3",
			@"PRYAnimateGradientSwitch",
			@"GroupCell-4",
			@"PRYGFirstColor",
			@"PRYGSecondColor",
			@"GroupCell-5",
			@"PRYGradientDirection"

		];

		self.savedSpecifiers = (self.savedSpecifiers) ?: [NSMutableDictionary new];

		for(PSSpecifier *specifier in _specifiers)

			if([chosenIDs containsObject:[specifier propertyForKey:@"id"]])

				[self.savedSpecifiers setObject:specifier forKey:[specifier propertyForKey:@"id"]];

	}

	return _specifiers;

}


- (id)init {

	self = [super init];

	if(self) {

		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)postNSNotification, CFSTR("me.luki.ariaprefs/prysmImageChanged"), NULL, 0);
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)postNSNotification, CFSTR("me.luki.ariaprefs/prysmGradientColorsChanged"), NULL, 0);

	}

	return self;

}


- (void)viewDidLoad {

	[super viewDidLoad];
	[self reloadSpecifiers];

}


- (void)reloadSpecifiers { // Dynamic specifiers

	[super reloadSpecifiers];

	if(![[self readPreferenceValue:[self specifierForID:@"PrysmSwitch"]] boolValue])

		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell-1"], self.savedSpecifiers[@"DarkPrysmImage"], self.savedSpecifiers[@"LightPrysmImage"], self.savedSpecifiers[@"GroupCell-2"], self.savedSpecifiers[@"PrysmBlurSlider"], self.savedSpecifiers[@"PRYGaussianGroupCell"], self.savedSpecifiers[@"PRYGaussianBlurButton"]] animated:NO];

	else if(![self containsSpecifier:self.savedSpecifiers[@"GroupCell-1"]])

		[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell-1"], self.savedSpecifiers[@"DarkPrysmImage"], self.savedSpecifiers[@"LightPrysmImage"], self.savedSpecifiers[@"GroupCell-2"], self.savedSpecifiers[@"PrysmBlurSlider"], self.savedSpecifiers[@"PRYGaussianGroupCell"], self.savedSpecifiers[@"PRYGaussianBlurButton"]] afterSpecifierID:@"PrysmSwitch" animated:NO];

	if(![[self readPreferenceValue:[self specifierForID:@"PRYGradientSwitch"]] boolValue])

		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell-3"], self.savedSpecifiers[@"PRYAnimateGradientSwitch"], self.savedSpecifiers[@"GroupCell-4"], self.savedSpecifiers[@"PRYGFirstColor"], self.savedSpecifiers[@"PRYGSecondColor"], self.savedSpecifiers[@"GroupCell-5"], self.savedSpecifiers[@"PRYGradientDirection"]] animated:NO];

	else if(![self containsSpecifier:[self specifierForID:@"GroupCell-3"]])

		[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell-3"], self.savedSpecifiers[@"PRYAnimateGradientSwitch"], self.savedSpecifiers[@"GroupCell-4"], self.savedSpecifiers[@"PRYGFirstColor"], self.savedSpecifiers[@"PRYGSecondColor"], self.savedSpecifiers[@"GroupCell-5"], self.savedSpecifiers[@"PRYGradientDirection"]] afterSpecifierID:@"PRYGradientSwitch" animated:NO];

}


- (void)didTapSaveBlurredImageButton { [[AriaImageManager sharedInstance] blurImageWithImage]; }


static void postNSNotification() {

	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"prysmImageApplied" object:nil];
	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"prysmGradientsApplied" object:nil];

}


- (id)readPreferenceValue:(PSSpecifier *)specifier {

	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:kPATH]];
	return (settings[specifier.properties[@"key"]]) ?: specifier.properties[@"default"];

}


- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {

	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:kPATH]];
	[settings setObject:value forKey:specifier.properties[@"key"]];	
	[settings writeToFile:kPATH atomically:YES];

	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"prysmImageApplied" object:nil];
	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"prysmGradientsApplied" object:nil];

	NSString *key = [specifier propertyForKey:@"key"];

	if([key isEqualToString:@"isPrysmImage"]) {

		if(![[self readPreferenceValue:[self specifierForID:@"PrysmSwitch"]] boolValue])

			[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell-1"], self.savedSpecifiers[@"DarkPrysmImage"], self.savedSpecifiers[@"LightPrysmImage"], self.savedSpecifiers[@"GroupCell-2"], self.savedSpecifiers[@"PrysmBlurSlider"], self.savedSpecifiers[@"PRYGaussianGroupCell"], self.savedSpecifiers[@"PRYGaussianBlurButton"]] animated:YES];

		else if(![self containsSpecifier:self.savedSpecifiers[@"GroupCell-1"]])

			[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell-1"], self.savedSpecifiers[@"DarkPrysmImage"], self.savedSpecifiers[@"LightPrysmImage"], self.savedSpecifiers[@"GroupCell-2"], self.savedSpecifiers[@"PrysmBlurSlider"], self.savedSpecifiers[@"PRYGaussianGroupCell"], self.savedSpecifiers[@"PRYGaussianBlurButton"]] afterSpecifierID:@"PrysmSwitch" animated:YES];

	}


	if([key isEqualToString:@"prysmGradients"]) {

		if(![[self readPreferenceValue:[self specifierForID:@"PRYGradientSwitch"]] boolValue])

			[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell-3"], self.savedSpecifiers[@"PRYAnimateGradientSwitch"], self.savedSpecifiers[@"GroupCell-4"], self.savedSpecifiers[@"PRYGFirstColor"], self.savedSpecifiers[@"PRYGSecondColor"], self.savedSpecifiers[@"GroupCell-5"], self.savedSpecifiers[@"PRYGradientDirection"]] animated:YES];

		else if(![self containsSpecifier:[self specifierForID:@"GroupCell-3"]])

			[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell-3"], self.savedSpecifiers[@"PRYAnimateGradientSwitch"], self.savedSpecifiers[@"GroupCell-4"], self.savedSpecifiers[@"PRYGFirstColor"], self.savedSpecifiers[@"PRYGSecondColor"], self.savedSpecifiers[@"GroupCell-5"], self.savedSpecifiers[@"PRYGradientDirection"]] afterSpecifierID:@"PRYGradientSwitch" animated:YES];

	}

}


@end


@implementation AriaStockVC


- (NSArray *)specifiers {

	if(!_specifiers) {

		_specifiers = [self loadSpecifiersFromPlistName:@"AriaStock" target:self];

		NSArray *chosenIDs = @[

			@"GroupCell1",
			@"DarkImage",
			@"LightImage",
			@"GroupCell2",
			@"BlurSlider",
			@"GaussianGroupCell",
			@"GaussianBlurButton",
			@"GroupCell3",
			@"AnimateGradientSwitch",
			@"GroupCell4",
			@"GFirstColor",
			@"GSecondColor",
			@"GroupCell5",
			@"GradientDirections"

		];

		self.savedSpecifiers = (self.savedSpecifiers) ?: [NSMutableDictionary new];

		for(PSSpecifier *specifier in _specifiers)

			if([chosenIDs containsObject:[specifier propertyForKey:@"id"]])

				[self.savedSpecifiers setObject:specifier forKey:[specifier propertyForKey:@"id"]];

	}

	return _specifiers;

}


- (id)init {

	self = [super init];

	if(self) [self setupNavBarButton];

	return self;

}


- (void)viewDidLoad {

	[super viewDidLoad];
	[self reloadSpecifiers];

}


- (void)reloadSpecifiers { // Dynamic specifiers

	[super reloadSpecifiers];

	if(![[self readPreferenceValue:[self specifierForID:@"ImageSwitch"]] boolValue])

		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell1"], self.savedSpecifiers[@"DarkImage"], self.savedSpecifiers[@"LightImage"], self.savedSpecifiers[@"GroupCell2"], self.savedSpecifiers[@"BlurSlider"], self.savedSpecifiers[@"GaussianGroupCell"], self.savedSpecifiers[@"GaussianBlurButton"]] animated:NO];


	else if(![self containsSpecifier:self.savedSpecifiers[@"GroupCell1"]])

		[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell1"], self.savedSpecifiers[@"DarkImage"], self.savedSpecifiers[@"LightImage"], self.savedSpecifiers[@"GroupCell2"], self.savedSpecifiers[@"BlurSlider"], self.savedSpecifiers[@"GaussianGroupCell"], self.savedSpecifiers[@"GaussianBlurButton"]] afterSpecifierID:@"ImageSwitch" animated:NO];


	if(![[self readPreferenceValue:[self specifierForID:@"GradientSwitch"]] boolValue])

		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell3"], self.savedSpecifiers[@"AnimateGradientSwitch"], self.savedSpecifiers[@"GroupCell4"], self.savedSpecifiers[@"GFirstColor"], self.savedSpecifiers[@"GSecondColor"], self.savedSpecifiers[@"GroupCell5"], self.savedSpecifiers[@"GradientDirections"]] animated:NO];


	else if(![self containsSpecifier:self.savedSpecifiers[@"GroupCell3"]])

		[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell3"], self.savedSpecifiers[@"AnimateGradientSwitch"], self.savedSpecifiers[@"GroupCell4"], self.savedSpecifiers[@"GFirstColor"], self.savedSpecifiers[@"GSecondColor"], self.savedSpecifiers[@"GroupCell5"], self.savedSpecifiers[@"GradientDirections"]] afterSpecifierID:@"GradientSwitch" animated:NO];

}


- (void)setupNavBarButton {

	UIImage *buttonImage = [UIImage systemImageNamed:@"infinity"];

	UIButton *infoButton =  [UIButton buttonWithType:UIButtonTypeCustom];
	infoButton.tintColor = kAriaTintColor;
	[infoButton setImage : buttonImage forState:UIControlStateNormal];
	[infoButton addTarget : self action:@selector(didTapInfoButton) forControlEvents:UIControlEventTouchUpInside];

	UIBarButtonItem *changelogButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
	self.navigationItem.rightBarButtonItem = changelogButtonItem;

}


- (void)didTapInfoButton {

	AudioServicesPlaySystemSound(1521);

	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Aria" message:@"The options you enable here will only inject if you either don't have Prysm installed or disabled it only with iCleaner Pro." preferredStyle:UIAlertControllerStyleAlert];

	UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Gotcha" style:UIAlertActionStyleCancel handler:nil];

	[alertController addAction:dismissAction];

	[self presentViewController:alertController animated:YES completion:nil];

}


- (void)didTapSaveBlurredImageButton { [[AriaImageManager sharedInstance] blurImageWithImage]; }


- (id)readPreferenceValue:(PSSpecifier *)specifier {

	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:kPATH]];
	return (settings[specifier.properties[@"key"]]) ?: specifier.properties[@"default"];

}


- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {

	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:kPATH]];
	[settings setObject:value forKey:specifier.properties[@"key"]];	
	[settings writeToFile:kPATH atomically:YES];

	NSString *key = [specifier propertyForKey:@"key"];

	if([key isEqualToString:@"giveMeTheImage"]) {

		if(![value boolValue])

			[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell1"], self.savedSpecifiers[@"DarkImage"], self.savedSpecifiers[@"LightImage"], self.savedSpecifiers[@"GroupCell2"], self.savedSpecifiers[@"BlurSlider"], self.savedSpecifiers[@"GaussianGroupCell"], self.savedSpecifiers[@"GaussianBlurButton"]] animated:YES];

		else if(![self containsSpecifier:self.savedSpecifiers[@"GroupCell1"]])

			[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell1"], self.savedSpecifiers[@"DarkImage"], self.savedSpecifiers[@"LightImage"], self.savedSpecifiers[@"GroupCell2"], self.savedSpecifiers[@"BlurSlider"], self.savedSpecifiers[@"GaussianGroupCell"], self.savedSpecifiers[@"GaussianBlurButton"]] afterSpecifierID:@"ImageSwitch" animated:YES];

	}

	if([key isEqualToString:@"giveMeThoseGradients"]) {

		if(![[self readPreferenceValue:[self specifierForID:@"GradientSwitch"]] boolValue])

			[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell3"], self.savedSpecifiers[@"AnimateGradientSwitch"], self.savedSpecifiers[@"GroupCell4"], self.savedSpecifiers[@"GFirstColor"], self.savedSpecifiers[@"GSecondColor"], self.savedSpecifiers[@"GroupCell5"], self.savedSpecifiers[@"GradientDirections"]] animated:YES];

		else if (![self containsSpecifier:self.savedSpecifiers[@"GroupCell3"]])

			[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell3"], self.savedSpecifiers[@"AnimateGradientSwitch"], self.savedSpecifiers[@"GroupCell4"], self.savedSpecifiers[@"GFirstColor"], self.savedSpecifiers[@"GSecondColor"], self.savedSpecifiers[@"GroupCell5"], self.savedSpecifiers[@"GradientDirections"]] afterSpecifierID:@"GradientSwitch" animated:YES];

	}

}


- (void)uselessMethodThatllNeverBeCalled { loadWithoutAGoddamnRespring(); }


@end


@implementation AriaContributorsVC


- (NSArray *)specifiers {

	if(!_specifiers) _specifiers = [self loadSpecifiersFromPlistName:@"AriaContributors" target:self];

	return _specifiers;

}


@end


@implementation AriaLinksVC


- (NSArray *)specifiers {

	if(!_specifiers) _specifiers = [self loadSpecifiersFromPlistName:@"AriaLinks" target:self];

	return _specifiers;

}


- (void)launchDiscord {

	[UIApplication.sharedApplication openURL:[NSURL URLWithString: @"https://discord.gg/jbE3avwSHs"] options:@{} completionHandler:nil];

}


- (void)launchPayPal {

	[UIApplication.sharedApplication openURL:[NSURL URLWithString: @"https://paypal.me/Luki120"] options:@{} completionHandler:nil];

}


- (void)launchGitHub {

	[UIApplication.sharedApplication openURL:[NSURL URLWithString: @"https://github.com/Luki120/Aria"] options:@{} completionHandler:nil];

}


- (void)launchElixir {

	[UIApplication.sharedApplication openURL:[NSURL URLWithString: @"https://luki120.github.io/depictions/web/?p=me.luki.elixir"] options:@{} completionHandler:nil];

}


- (void)launchMarie {

	[UIApplication.sharedApplication openURL:[NSURL URLWithString: @"https://luki120.github.io/depictions/web/?p=me.luki.marie"] options:@{} completionHandler:nil];

}


@end


@implementation AriaTintCell


- (void)setTitle:(NSString *)t {

	[super setTitle:t];

	self.titleLabel.textColor = kAriaTintColor;

}


@end
