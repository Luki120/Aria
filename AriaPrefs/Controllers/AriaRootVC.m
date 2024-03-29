#import "AriaRootVC.h"


static NSString *const kImagesPath = rootlessPathNS(@"/var/mobile/Library/Preferences/me.luki.aprilprefs/");


@implementation AriaRootVC {

	OBWelcomeController *changelogController;

}

// ! Lifecycle

- (NSArray *)specifiers {

	if(!_specifiers) _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	return _specifiers;

}


- (id)init {

	self = [super init];
	if(!self) return nil;

	static dispatch_once_t token;
	dispatch_once(&token, ^{ registerAriaTintCellClass(); });

	[self setupUI];

	return self;

}


- (void)setupUI {

	UIButton *changelogButton = [UIButton new];
	changelogButton.tintColor = kAriaTintColor;
	[changelogButton setImage:[UIImage systemImageNamed: @"atom"] forState:UIControlStateNormal];
	[changelogButton addTarget:self action:@selector(showWtfChangedInThisVersion) forControlEvents:UIControlEventTouchUpInside];

	UIBarButtonItem *changelogButtonItem = [[UIBarButtonItem alloc] initWithCustomView: changelogButton];
	self.navigationItem.rightBarButtonItem = changelogButtonItem;

}

// ! Selectors

- (void)showWtfChangedInThisVersion {

	AudioServicesPlaySystemSound(1521);

	UIImage *tweakImage = [UIImage imageWithContentsOfFile:rootlessPathNS(@"/Library/PreferenceBundles/AriaPrefs.bundle/Assets/AriaIcon.png")];
	UIImage *checkmarkImage = [UIImage systemImageNamed:@"checkmark.circle.fill"];

	if(changelogController) { [self presentViewController:changelogController animated:YES completion:nil]; return; }
	changelogController = [[OBWelcomeController alloc] initWithTitle:@"Aria" detailText:@"0.9.8~RC" icon:tweakImage];
	[changelogController addBulletedListItemWithTitle:@"Code" description:@"Refactoring ⇝ everything works the same, but better." image:checkmarkImage];
	[changelogController addBulletedListItemWithTitle:@"Tweak" description:@"Images saved using the Gaussian blur option will be added to a custom \"Aria\" album in the Photos app." image:checkmarkImage];

	_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];

	_UIBackdropView *backdropView = [[_UIBackdropView alloc] initWithFrame:CGRectZero autosizesToFitSuperview:YES settings:settings];
	backdropView.clipsToBounds = YES;
	[changelogController.viewIfLoaded insertSubview:backdropView atIndex:0];

	changelogController.viewIfLoaded.backgroundColor = UIColor.clearColor;
	changelogController.view.tintColor = kAriaTintColor;
	changelogController.modalInPresentation = NO;
	changelogController.modalPresentationStyle = UIModalPresentationPageSheet;

	[self presentViewController:changelogController animated:YES completion:nil];

}


- (void)shatterThePrefsToPieces {

	AudioServicesPlaySystemSound(1521);

	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Aria" message:@"Do you want to start fresh?" preferredStyle: UIAlertControllerStyleAlert];
	UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Shoot" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

		[[NSFileManager defaultManager] removeItemAtPath:kPath error:nil];
		[[NSFileManager defaultManager] removeItemAtPath:kImagesPath error:nil];

		[self crossDissolveBlur];

	}];

	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Meh" style:UIAlertActionStyleDefault handler:nil];

	[alertController addAction: confirmAction];
	[alertController addAction: cancelAction];

	[self presentViewController:alertController animated:YES completion:nil];

}


- (void)crossDissolveBlur {

	_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle: 2];

	_UIBackdropView *backdropView = [[_UIBackdropView alloc] initWithFrame:CGRectZero autosizesToFitSuperview:YES settings:settings];
	backdropView.alpha = 0;
	backdropView.clipsToBounds = YES;
	[self.view addSubview: backdropView];

	[UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{

		backdropView.alpha = 1;

	} completion:^(BOOL finished) { [self launchRespring]; }];

}


- (void)launchRespring {

	pid_t pid;
	const char* args[] = {"killall", "backboardd", NULL};
	posix_spawn(&pid, rootlessPathC("/usr/bin/killall"), NULL, NULL, (char* const*)args, NULL);

}

// ! Dark juju

static void aria_setTitle(PSTableCell *self, SEL _cmd, NSString *title) {

	struct objc_super superSetTitle = {
		self,
		[self superclass]
	};

	id (*superCall)(struct objc_super *, SEL, NSString *) = (void *)objc_msgSendSuper;
	superCall(&superSetTitle, _cmd, title);

	self.titleLabel.textColor = kAriaTintColor;
	self.titleLabel.highlightedTextColor = kAriaTintColor;

}

static void registerAriaTintCellClass() {

	Class AriaTintCellClass = objc_allocateClassPair([PSTableCell class], "AriaTintCell", 0);
	Method method = class_getInstanceMethod([PSTableCell class], @selector(setTitle:));
	const char *typeEncoding = method_getTypeEncoding(method);
	class_addMethod(AriaTintCellClass, @selector(setTitle:), (IMP) aria_setTitle, typeEncoding);

	objc_registerClassPair(AriaTintCellClass);

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


- (void)launchDiscord { [self launchURL: [NSURL URLWithString: @"https://discord.gg/jbE3avwSHs"]]; }
- (void)launchGitHub { [self launchURL: [NSURL URLWithString: @"https://github.com/Luki120/Aria"]]; }
- (void)launchPayPal { [self launchURL: [NSURL URLWithString: @"https://paypal.me/Luki120"]]; }
- (void)launchElixir { [self launchURL: [NSURL URLWithString:@"https://luki120.github.io/depictions/web/?p=me.luki.elixir"]]; }
- (void)launchMarie { [self launchURL: [NSURL URLWithString: @"https://luki120.github.io/depictions/web/?p=me.luki.marie"]]; }

- (void)launchURL:(NSURL *)url { [UIApplication.sharedApplication openURL:url options:@{} completionHandler:nil]; }

@end
