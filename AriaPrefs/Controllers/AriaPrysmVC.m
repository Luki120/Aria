#import "AriaPrysmVC.h"

// ! Constants 

static const char *aria_prysm_image_changed = "me.luki.ariaprefs/prysmImageChanged";
static const char *aria_prysm_gradient_changed = "me.luki.ariaprefs/prysmGradientColorsChanged";

@interface AriaPrysmVC () <AriaGaussianBlurCellDelegate>
@end


@implementation AriaPrysmVC {

	NSMutableDictionary *savedSpecifiers;

}

// ! Lifecycle

- (NSArray *)specifiers {

	if(_specifiers) return nil;
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

	savedSpecifiers = savedSpecifiers ?: [NSMutableDictionary new];

	for(PSSpecifier *specifier in _specifiers)

		if([chosenIDs containsObject:[specifier propertyForKey:@"id"]])

			[savedSpecifiers setObject:specifier forKey:[specifier propertyForKey:@"id"]];

	return _specifiers;

}


- (id)init {

	self = [super init];
	if(!self) return nil;

	[UISlider appearanceWhenContainedInInstancesOfClasses:@[[self class]]].minimumTrackTintColor = kAriaTintColor;
	[UISwitch appearanceWhenContainedInInstancesOfClasses:@[[self class]]].onTintColor = kAriaTintColor;

	[self setupObservers];

	return self;

}


- (void)setupObservers {

	int register_token = 0;
	notify_register_dispatch(aria_prysm_image_changed, &register_token, dispatch_get_main_queue(), ^(int token) {
		[NSDistributedNotificationCenter.defaultCenter postNotificationName:AriaDidApplyPrysmImageNotification object:nil];
	});
	notify_register_dispatch(aria_prysm_gradient_changed, &register_token, dispatch_get_main_queue(), ^(int token) {
		[NSDistributedNotificationCenter.defaultCenter postNotificationName:AriaDidApplyPrysmGradientsNotification object:nil];
	});

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

// ! UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	AriaGaussianBlurCell *cell = (AriaGaussianBlurCell *)[super tableView:tableView cellForRowAtIndexPath: indexPath];
	if([cell isKindOfClass: [AriaGaussianBlurCell class]]) cell.delegate = self;
	return cell;

}

// ! Preferences

- (id)readPreferenceValue:(PSSpecifier *)specifier {

	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile: kPath]];
	return settings[specifier.properties[@"key"]] ?: specifier.properties[@"default"];

}


- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {

	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile: kPath]];
	[settings setObject:value forKey:specifier.properties[@"key"]];	
	[settings writeToFile:kPath atomically:YES];

	[super setPreferenceValue:value specifier:specifier];

	[NSDistributedNotificationCenter.defaultCenter postNotificationName:AriaDidApplyPrysmImageNotification object:nil];
	[NSDistributedNotificationCenter.defaultCenter postNotificationName:AriaDidApplyPrysmGradientsNotification object:nil];

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

// ! AriaGaussianBlurCellDelegate

- (void)didTapGaussianBlurButtonInAriaGuassianBlurCell:(AriaGaussianBlurCell *)ariaGuassianBlurCell {

	[[AriaImageManager sharedInstance] blurImage];

}


- (void)didTapGaussianBlurInfoButtonInAriaGaussianBlurCell:(AriaGaussianBlurCell *)ariaGuassianBlurCell {

	[[AriaImageManager sharedInstance] presentInfoAlertController];

}

@end
