#import "AriaStockVC.h"


@interface AriaStockVC () <AriaGaussianBlurCellDelegate>
@end


@implementation AriaStockVC {

	NSMutableDictionary *savedSpecifiers;

}

// ! Lifecycle

- (NSArray *)specifiers {

	if(_specifiers) return nil;
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

	[self setupNavBarButton];

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

	UIButton *infoButton = [UIButton new];
	infoButton.tintColor = kAriaTintColor;
	[infoButton setImage:[UIImage systemImageNamed: @"infinity"] forState: UIControlStateNormal];
	[infoButton addTarget:self action:@selector(didTapNavBarInfoButton) forControlEvents: UIControlEventTouchUpInside];

	UIBarButtonItem *infoButtonItem = [[UIBarButtonItem alloc] initWithCustomView: infoButton];
	self.navigationItem.rightBarButtonItem = infoButtonItem;

}

// ! Selectors

- (void)didTapNavBarInfoButton {

	AudioServicesPlaySystemSound(1521);

	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Aria" message:@"The options you enable here won't inject unless you either disable Prysm (with iCleaner Pro) or you uninstall it." preferredStyle: UIAlertControllerStyleAlert];
	UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Gotcha" style:UIAlertActionStyleCancel handler:nil];
	[alertController addAction: dismissAction];

	[self presentViewController:alertController animated:YES completion: nil];

}

// ! UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	AriaGaussianBlurCell *cell = (AriaGaussianBlurCell *)[super tableView:tableView cellForRowAtIndexPath: indexPath];
	if([cell isKindOfClass: AriaGaussianBlurCell.class]) cell.delegate = self;
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

// ! AriaGaussianBlurCellDelegate

- (void)didTapGaussianBlurButtonInAriaGuassianBlurCell:(AriaGaussianBlurCell *)ariaGuassianBlurCell {

	[[AriaImageManager sharedInstance] blurImage];

}


- (void)didTapGaussianBlurInfoButtonInAriaGaussianBlurCell:(AriaGaussianBlurCell *)ariaGuassianBlurCell {

	[[AriaImageManager sharedInstance] presentInfoAlertController];

}

@end
