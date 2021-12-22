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


@interface AriaPrysmVC () <AriaCustomButtonCellDelegate>
@end


@implementation AriaPrysmVC {

	NSMutableDictionary *savedSpecifiers;

}


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

		savedSpecifiers = (savedSpecifiers) ?: [NSMutableDictionary new];

		for(PSSpecifier *specifier in _specifiers)

			if([chosenIDs containsObject:[specifier propertyForKey:@"id"]])

				[savedSpecifiers setObject:specifier forKey:[specifier propertyForKey:@"id"]];

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

		[self removeContiguousSpecifiers:@[savedSpecifiers[@"GroupCell-1"], savedSpecifiers[@"DarkPrysmImage"], savedSpecifiers[@"LightPrysmImage"], savedSpecifiers[@"GroupCell-2"], savedSpecifiers[@"PrysmBlurSlider"], savedSpecifiers[@"PRYGaussianGroupCell"], savedSpecifiers[@"PRYGaussianBlurButton"]] animated:NO];

	else if(![self containsSpecifier:savedSpecifiers[@"GroupCell-1"]])

		[self insertContiguousSpecifiers:@[savedSpecifiers[@"GroupCell-1"], savedSpecifiers[@"DarkPrysmImage"], savedSpecifiers[@"LightPrysmImage"], savedSpecifiers[@"GroupCell-2"], savedSpecifiers[@"PrysmBlurSlider"], savedSpecifiers[@"PRYGaussianGroupCell"], savedSpecifiers[@"PRYGaussianBlurButton"]] afterSpecifierID:@"PrysmSwitch" animated:NO];

	if(![[self readPreferenceValue:[self specifierForID:@"PRYGradientSwitch"]] boolValue])

		[self removeContiguousSpecifiers:@[savedSpecifiers[@"GroupCell-3"], savedSpecifiers[@"PRYAnimateGradientSwitch"], savedSpecifiers[@"GroupCell-4"], savedSpecifiers[@"PRYGFirstColor"], savedSpecifiers[@"PRYGSecondColor"], savedSpecifiers[@"GroupCell-5"], savedSpecifiers[@"PRYGradientDirection"]] animated:NO];

	else if(![self containsSpecifier:[self specifierForID:@"GroupCell-3"]])

		[self insertContiguousSpecifiers:@[savedSpecifiers[@"GroupCell-3"], savedSpecifiers[@"PRYAnimateGradientSwitch"], savedSpecifiers[@"GroupCell-4"], savedSpecifiers[@"PRYGFirstColor"], savedSpecifiers[@"PRYGSecondColor"], savedSpecifiers[@"GroupCell-5"], savedSpecifiers[@"PRYGradientDirection"]] afterSpecifierID:@"PRYGradientSwitch" animated:NO];

}


- (void)didTapGaussianBlurButton {

	[[AriaImageManager sharedInstance] blurImageWithImage];

}


- (void)didTapGaussianBlurInfoButton {

	AudioServicesPlaySystemSound(1521);

	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Aria" message:@"The gaussian blur is an actual blur applied to the image, rather than an overlay view, like the epic one. This means you can save any image you want with the blur applied, and with any intensity you want. Since generating the blur takes quite some resources, including it directly as an option wouldn't be the best performance wise without sacrificing on the fly preferences. However, you can save any image you want and then come back here and apply it." preferredStyle: UIAlertControllerStyleAlert];

	UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Got it" style:UIAlertActionStyleCancel handler:nil];

	[alertController addAction: dismissAction];

	[self presentViewController:alertController animated:YES completion: nil];

}


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

			[self removeContiguousSpecifiers:@[savedSpecifiers[@"GroupCell-1"], savedSpecifiers[@"DarkPrysmImage"], savedSpecifiers[@"LightPrysmImage"], savedSpecifiers[@"GroupCell-2"], savedSpecifiers[@"PrysmBlurSlider"], savedSpecifiers[@"PRYGaussianGroupCell"], savedSpecifiers[@"PRYGaussianBlurButton"]] animated:YES];

		else if(![self containsSpecifier:savedSpecifiers[@"GroupCell-1"]])

			[self insertContiguousSpecifiers:@[savedSpecifiers[@"GroupCell-1"], savedSpecifiers[@"DarkPrysmImage"], savedSpecifiers[@"LightPrysmImage"], savedSpecifiers[@"GroupCell-2"], savedSpecifiers[@"PrysmBlurSlider"], savedSpecifiers[@"PRYGaussianGroupCell"], savedSpecifiers[@"PRYGaussianBlurButton"]] afterSpecifierID:@"PrysmSwitch" animated:YES];

	}

	if([key isEqualToString:@"prysmGradients"]) {

		if(![[self readPreferenceValue:[self specifierForID:@"PRYGradientSwitch"]] boolValue])

			[self removeContiguousSpecifiers:@[savedSpecifiers[@"GroupCell-3"], savedSpecifiers[@"PRYAnimateGradientSwitch"], savedSpecifiers[@"GroupCell-4"], savedSpecifiers[@"PRYGFirstColor"], savedSpecifiers[@"PRYGSecondColor"], savedSpecifiers[@"GroupCell-5"], savedSpecifiers[@"PRYGradientDirection"]] animated:YES];

		else if(![self containsSpecifier:[self specifierForID:@"GroupCell-3"]])

			[self insertContiguousSpecifiers:@[savedSpecifiers[@"GroupCell-3"], savedSpecifiers[@"PRYAnimateGradientSwitch"], savedSpecifiers[@"GroupCell-4"], savedSpecifiers[@"PRYGFirstColor"], savedSpecifiers[@"PRYGSecondColor"], savedSpecifiers[@"GroupCell-5"], savedSpecifiers[@"PRYGradientDirection"]] afterSpecifierID:@"PRYGradientSwitch" animated:YES];

	}

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	AriaCustomButtonCell *cell = (AriaCustomButtonCell *)[super tableView:tableView cellForRowAtIndexPath: indexPath];

	if([cell isKindOfClass: AriaCustomButtonCell.class]) cell.delegate = self;

	return cell;

}


@end


@interface AriaStockVC () <AriaCustomButtonCellDelegate>
@end


@implementation AriaStockVC {

	NSMutableDictionary *savedSpecifiers;

}


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

		savedSpecifiers = (savedSpecifiers) ?: [NSMutableDictionary new];

		for(PSSpecifier *specifier in _specifiers)

			if([chosenIDs containsObject:[specifier propertyForKey:@"id"]])

				[savedSpecifiers setObject:specifier forKey:[specifier propertyForKey:@"id"]];

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

		[self removeContiguousSpecifiers:@[savedSpecifiers[@"GroupCell1"], savedSpecifiers[@"DarkImage"], savedSpecifiers[@"LightImage"], savedSpecifiers[@"GroupCell2"], savedSpecifiers[@"BlurSlider"], savedSpecifiers[@"GaussianGroupCell"], savedSpecifiers[@"GaussianBlurButton"]] animated:NO];

	else if(![self containsSpecifier:savedSpecifiers[@"GroupCell1"]])

		[self insertContiguousSpecifiers:@[savedSpecifiers[@"GroupCell1"], savedSpecifiers[@"DarkImage"], savedSpecifiers[@"LightImage"], savedSpecifiers[@"GroupCell2"], savedSpecifiers[@"BlurSlider"], savedSpecifiers[@"GaussianGroupCell"], savedSpecifiers[@"GaussianBlurButton"]] afterSpecifierID:@"ImageSwitch" animated:NO];

	if(![[self readPreferenceValue:[self specifierForID:@"GradientSwitch"]] boolValue])

		[self removeContiguousSpecifiers:@[savedSpecifiers[@"GroupCell3"], savedSpecifiers[@"AnimateGradientSwitch"], savedSpecifiers[@"GroupCell4"], savedSpecifiers[@"GFirstColor"], savedSpecifiers[@"GSecondColor"], savedSpecifiers[@"GroupCell5"], savedSpecifiers[@"GradientDirections"]] animated:NO];

	else if(![self containsSpecifier:savedSpecifiers[@"GroupCell3"]])

		[self insertContiguousSpecifiers:@[savedSpecifiers[@"GroupCell3"], savedSpecifiers[@"AnimateGradientSwitch"], savedSpecifiers[@"GroupCell4"], savedSpecifiers[@"GFirstColor"], savedSpecifiers[@"GSecondColor"], savedSpecifiers[@"GroupCell5"], savedSpecifiers[@"GradientDirections"]] afterSpecifierID:@"GradientSwitch" animated:NO];

}


- (void)setupNavBarButton {

	UIImage *buttonImage = [UIImage systemImageNamed:@"infinity"];

	UIButton *infoButton =  [UIButton buttonWithType:UIButtonTypeCustom];
	infoButton.tintColor = kAriaTintColor;
	[infoButton setImage : buttonImage forState:UIControlStateNormal];
	[infoButton addTarget : self action:@selector(didTapNavBarInfoButton) forControlEvents:UIControlEventTouchUpInside];

	UIBarButtonItem *changelogButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
	self.navigationItem.rightBarButtonItem = changelogButtonItem;

}


- (void)didTapNavBarInfoButton {

	AudioServicesPlaySystemSound(1521);

	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Aria" message:@"The options you enable here won't inject unless you either disable Prysm (with iCleaner Pro) or you uninstall it." preferredStyle:UIAlertControllerStyleAlert];

	UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Gotcha" style:UIAlertActionStyleCancel handler:nil];

	[alertController addAction: dismissAction];

	[self presentViewController:alertController animated:YES completion: nil];

}


- (void)didTapGaussianBlurButton {

	[[AriaImageManager sharedInstance] blurImageWithImage];

}


- (void)didTapGaussianBlurInfoButton {

	AudioServicesPlaySystemSound(1521);

	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Aria" message:@"The gaussian blur is an actual blur applied to the image, rather than an overlay view, like the epic one. This means you can save any image you want with the blur applied, and with any intensity you want. Since generating the blur takes quite some resources, including it directly as an option wouldn't be the best performance wise without sacrificing on the fly preferences. However, you can save any image you want and then come back here and apply it." preferredStyle: UIAlertControllerStyleAlert];

	UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Got it" style:UIAlertActionStyleCancel handler:nil];

	[alertController addAction: dismissAction];

	[self presentViewController:alertController animated:YES completion: nil];

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

	NSString *key = [specifier propertyForKey:@"key"];

	if([key isEqualToString:@"giveMeTheImage"]) {

		if(![value boolValue])

			[self removeContiguousSpecifiers:@[savedSpecifiers[@"GroupCell1"], savedSpecifiers[@"DarkImage"], savedSpecifiers[@"LightImage"], savedSpecifiers[@"GroupCell2"], savedSpecifiers[@"BlurSlider"], savedSpecifiers[@"GaussianGroupCell"], savedSpecifiers[@"GaussianBlurButton"]] animated:YES];

		else if(![self containsSpecifier:savedSpecifiers[@"GroupCell1"]])

			[self insertContiguousSpecifiers:@[savedSpecifiers[@"GroupCell1"], savedSpecifiers[@"DarkImage"], savedSpecifiers[@"LightImage"], savedSpecifiers[@"GroupCell2"], savedSpecifiers[@"BlurSlider"], savedSpecifiers[@"GaussianGroupCell"], savedSpecifiers[@"GaussianBlurButton"]] afterSpecifierID:@"ImageSwitch" animated:YES];

	}

	if([key isEqualToString:@"giveMeThoseGradients"]) {

		if(![[self readPreferenceValue:[self specifierForID:@"GradientSwitch"]] boolValue])

			[self removeContiguousSpecifiers:@[savedSpecifiers[@"GroupCell3"], savedSpecifiers[@"AnimateGradientSwitch"], savedSpecifiers[@"GroupCell4"], savedSpecifiers[@"GFirstColor"], savedSpecifiers[@"GSecondColor"], savedSpecifiers[@"GroupCell5"], savedSpecifiers[@"GradientDirections"]] animated:YES];

		else if (![self containsSpecifier:savedSpecifiers[@"GroupCell3"]])

			[self insertContiguousSpecifiers:@[savedSpecifiers[@"GroupCell3"], savedSpecifiers[@"AnimateGradientSwitch"], savedSpecifiers[@"GroupCell4"], savedSpecifiers[@"GFirstColor"], savedSpecifiers[@"GSecondColor"], savedSpecifiers[@"GroupCell5"], savedSpecifiers[@"GradientDirections"]] afterSpecifierID:@"GradientSwitch" animated:YES];

	}

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	AriaCustomButtonCell *cell = (AriaCustomButtonCell *)[super tableView:tableView cellForRowAtIndexPath: indexPath];

	if([cell isKindOfClass: AriaCustomButtonCell.class]) cell.delegate = self;

	return cell;

}


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
