#include "AriaRootListController.h"




static NSString *takeMeToTheValues = @"/var/mobile/Library/Preferences/me.luki.ariaprefs.plist";


#define tint [UIColor colorWithRed: 0.62 green: 0.36 blue: 0.91 alpha: 1.00]


@implementation AriaRootListController


- (NSArray *)specifiers {

    if (!_specifiers) {

        _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
        NSArray *chosenIDs = @[@"GroupCell1", @"EnableTransitionSwitch", @"GroupCell2", @"DarkImage", @"LightImage", @"GroupCell3", @"BlurSlider", @"GroupCell5", @"GTransitionSwitch", @"GroupCell6", @"AnimateGradientSwitch", @"GroupCell7", @"GFirstColor", @"GSecondColor", @"GroupCell8", @"GradientDirections"];
        self.savedSpecifiers = (self.savedSpecifiers) ?: [[NSMutableDictionary alloc] init];
        for(PSSpecifier *specifier in _specifiers) {
            if([chosenIDs containsObject:[specifier propertyForKey:@"id"]]) {
                [self.savedSpecifiers setObject:specifier forKey:[specifier propertyForKey:@"id"]];
            }
      
        }

    }

    return _specifiers;

}


- (void)reloadSpecifiers { // Dynamic specifiers

    [super reloadSpecifiers];


    if (![[self readPreferenceValue:[self specifierForID:@"ImageSwitch"]] boolValue]) {

        [self removeSpecifier:self.savedSpecifiers[@"GroupCell1"] animated:NO];
        [self removeSpecifier:self.savedSpecifiers[@"EnableTransitionSwitch"] animated:NO];
        [self removeSpecifier:self.savedSpecifiers[@"GroupCell2"] animated:NO];
        [self removeSpecifier:self.savedSpecifiers[@"DarkImage"] animated:NO];
        [self removeSpecifier:self.savedSpecifiers[@"LightImage"] animated:NO];
        [self removeSpecifier:self.savedSpecifiers[@"GroupCell3"] animated:NO];
        [self removeSpecifier:self.savedSpecifiers[@"BlurSlider"] animated:NO];

    }


    else if (![self containsSpecifier:self.savedSpecifiers[@"GroupCell1"]]) {

        [self insertSpecifier:self.savedSpecifiers[@"GroupCell1"] afterSpecifierID:@"ImageSwitch" animated:NO];
        [self insertSpecifier:self.savedSpecifiers[@"EnableTransitionSwitch"] afterSpecifierID:@"GroupCell1" animated:NO];
        [self insertSpecifier:self.savedSpecifiers[@"GroupCell2"] afterSpecifierID:@"EnableTransitionSwitch" animated:NO];
        [self insertSpecifier:self.savedSpecifiers[@"DarkImage"] afterSpecifierID:@"GroupCell2" animated:NO];
        [self insertSpecifier:self.savedSpecifiers[@"LightImage"] afterSpecifierID:@"DarkImage" animated:NO];
        [self insertSpecifier:self.savedSpecifiers[@"GroupCell3"] afterSpecifierID:@"LightImage" animated:NO];
        [self insertSpecifier:self.savedSpecifiers[@"BlurSlider"] afterSpecifierID:@"GroupCell3" animated:NO];

    }


    if (![[self readPreferenceValue:[self specifierForID:@"GradientSwitch"]] boolValue]) {

        [self removeSpecifier:self.savedSpecifiers[@"GroupCell5"] animated:NO];
        [self removeSpecifier:self.savedSpecifiers[@"GTransitionSwitch"] animated:NO];
        [self removeSpecifier:self.savedSpecifiers[@"GroupCell6"] animated:NO];
        [self removeSpecifier:self.savedSpecifiers[@"AnimateGradientSwitch"] animated:NO];
        [self removeSpecifier:self.savedSpecifiers[@"GroupCell7"] animated:NO];
        [self removeSpecifier:self.savedSpecifiers[@"GFirstColor"] animated:NO];
        [self removeSpecifier:self.savedSpecifiers[@"GSecondColor"] animated:NO];
        [self removeSpecifier:self.savedSpecifiers[@"GroupCell8"] animated:NO];
        [self removeSpecifier:self.savedSpecifiers[@"GradientDirections"] animated:NO];

    }


    else if (![self containsSpecifier:self.savedSpecifiers[@"GroupCell5"]]) {

        [self insertSpecifier:self.savedSpecifiers[@"GroupCell5"] afterSpecifierID:@"GradientSwitch" animated:NO];
        [self insertSpecifier:self.savedSpecifiers[@"GTransitionSwitch"] afterSpecifierID:@"GroupCell5" animated:NO];
        [self insertSpecifier:self.savedSpecifiers[@"GroupCell6"] afterSpecifierID:@"GTransitionSwitch" animated:NO];
        [self insertSpecifier:self.savedSpecifiers[@"AnimateGradientSwitch"] afterSpecifierID:@"GroupCell6" animated:NO];
        [self insertSpecifier:self.savedSpecifiers[@"GroupCell7"] afterSpecifierID:@"AnimateGradientSwitch" animated:NO];
        [self insertSpecifier:self.savedSpecifiers[@"GFirstColor"] afterSpecifierID:@"GroupCell7" animated:NO];
        [self insertSpecifier:self.savedSpecifiers[@"GSecondColor"] afterSpecifierID:@"GFirstColor" animated:NO];
        [self insertSpecifier:self.savedSpecifiers[@"GroupCell8"] afterSpecifierID:@"GSecondColor" animated:NO];
        [self insertSpecifier:self.savedSpecifiers[@"GradientDirections"] afterSpecifierID:@"GroupCell8" animated:NO];
    
    }

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

        
        if (![value boolValue]) {


            [self removeSpecifier:self.savedSpecifiers[@"GroupCell1"] animated:YES];
            [self removeSpecifier:self.savedSpecifiers[@"EnableTransitionSwitch"] animated:YES];
            [self removeSpecifier:self.savedSpecifiers[@"GroupCell2"] animated:YES];
            [self removeSpecifier:self.savedSpecifiers[@"DarkImage"] animated:YES];
            [self removeSpecifier:self.savedSpecifiers[@"LightImage"] animated:YES];
            [self removeSpecifier:self.savedSpecifiers[@"GroupCell3"] animated:YES];
            [self removeSpecifier:self.savedSpecifiers[@"BlurSlider"] animated:YES];


        }


        else if (![self containsSpecifier:self.savedSpecifiers[@"GroupCell1"]]) {


            [self insertSpecifier:self.savedSpecifiers[@"GroupCell1"] afterSpecifierID:@"ImageSwitch" animated:YES];
            [self insertSpecifier:self.savedSpecifiers[@"EnableTransitionSwitch"] afterSpecifierID:@"GroupCell1" animated:YES];
            [self insertSpecifier:self.savedSpecifiers[@"GroupCell2"] afterSpecifierID:@"EnableTransitionSwitch" animated:YES];
            [self insertSpecifier:self.savedSpecifiers[@"DarkImage"] afterSpecifierID:@"GroupCell2" animated:YES];
            [self insertSpecifier:self.savedSpecifiers[@"LightImage"] afterSpecifierID:@"DarkImage" animated:YES];
            [self insertSpecifier:self.savedSpecifiers[@"GroupCell3"] afterSpecifierID:@"LightImage" animated:YES];
            [self insertSpecifier:self.savedSpecifiers[@"BlurSlider"] afterSpecifierID:@"GroupCell3" animated:YES];


        }

    }


    if([key isEqualToString:@"giveMeThoseGradients"]) {


        if (![[self readPreferenceValue:[self specifierForID:@"GradientSwitch"]] boolValue]) {

            [self removeSpecifier:self.savedSpecifiers[@"GroupCell5"] animated:YES];
            [self removeSpecifier:self.savedSpecifiers[@"GTransitionSwitch"] animated:YES];
            [self removeSpecifier:self.savedSpecifiers[@"GroupCell6"] animated:YES];
            [self removeSpecifier:self.savedSpecifiers[@"AnimateGradientSwitch"] animated:YES];
            [self removeSpecifier:self.savedSpecifiers[@"GroupCell7"] animated:YES];
            [self removeSpecifier:self.savedSpecifiers[@"GFirstColor"] animated:YES];
            [self removeSpecifier:self.savedSpecifiers[@"GSecondColor"] animated:YES];
            [self removeSpecifier:self.savedSpecifiers[@"GroupCell8"] animated:YES];
            [self removeSpecifier:self.savedSpecifiers[@"GradientDirections"] animated:YES];

        }


        else if (![self containsSpecifier:self.savedSpecifiers[@"GroupCell5"]]) {

            [self insertSpecifier:self.savedSpecifiers[@"GroupCell5"] afterSpecifierID:@"GradientSwitch" animated:YES];
            [self insertSpecifier:self.savedSpecifiers[@"GTransitionSwitch"] afterSpecifierID:@"GroupCell5" animated:YES];
            [self insertSpecifier:self.savedSpecifiers[@"GroupCell6"] afterSpecifierID:@"GTransitionSwitch" animated:YES];
            [self insertSpecifier:self.savedSpecifiers[@"AnimateGradientSwitch"] afterSpecifierID:@"GroupCell6" animated:YES];
            [self insertSpecifier:self.savedSpecifiers[@"GroupCell7"] afterSpecifierID:@"AnimateGradientSwitch" animated:YES];
            [self insertSpecifier:self.savedSpecifiers[@"GFirstColor"] afterSpecifierID:@"GroupCell7" animated:YES];
            [self insertSpecifier:self.savedSpecifiers[@"GSecondColor"] afterSpecifierID:@"GFirstColor" animated:YES];
            [self insertSpecifier:self.savedSpecifiers[@"GroupCell8"] afterSpecifierID:@"GSecondColor" animated:YES];
            [self insertSpecifier:self.savedSpecifiers[@"GradientDirections"] afterSpecifierID:@"GroupCell8" animated:YES];
    
        }

    }

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