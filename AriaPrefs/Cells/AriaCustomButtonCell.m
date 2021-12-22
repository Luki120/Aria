#import "AriaCustomButtonCell.h"


@implementation AriaCustomButtonCell {

	UIButton *gaussianBlurButton;
	UIButton *gaussianBlurInfoButton;

}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier {

	self = [super initWithStyle:style reuseIdentifier:identifier specifier:specifier];

	if(self) [self setupUI];

	return self;

}


- (void)setupUI {

	gaussianBlurButton = [UIButton new];
	gaussianBlurButton.titleLabel.font = [UIFont systemFontOfSize: 17];
	gaussianBlurButton.translatesAutoresizingMaskIntoConstraints = NO;
	[gaussianBlurButton setTitle : @"Gaussian Blur" forState: UIControlStateNormal];
	[gaussianBlurButton setTitleColor : UIColor.labelColor forState: UIControlStateNormal];
	[gaussianBlurButton addTarget : self action:@selector(didTapBlurButton) forControlEvents: UIControlEventTouchUpInside];
	[self.contentView addSubview: gaussianBlurButton];

	UIImage *buttonImage = [UIImage systemImageNamed: @"info.circle"];

	gaussianBlurInfoButton = [UIButton new];
	gaussianBlurInfoButton.tintColor = kAriaTintColor;
	gaussianBlurInfoButton.translatesAutoresizingMaskIntoConstraints = NO;
	[gaussianBlurInfoButton setImage : buttonImage forState: UIControlStateNormal];
	[gaussianBlurInfoButton addTarget : self action:@selector(didTapInfoButton) forControlEvents: UIControlEventTouchUpInside];
	[self.contentView addSubview: gaussianBlurInfoButton];

	[self activateConstraints];

}


- (void)activateConstraints {

	[gaussianBlurButton.centerYAnchor constraintEqualToAnchor : self.contentView.centerYAnchor].active = YES;
	[gaussianBlurButton.leadingAnchor constraintEqualToAnchor : self.contentView.leadingAnchor constant : 15].active = YES;

	[gaussianBlurInfoButton.centerYAnchor constraintEqualToAnchor : self.contentView.centerYAnchor].active = YES;
	[gaussianBlurInfoButton.trailingAnchor constraintEqualToAnchor : self.contentView.trailingAnchor constant : -20].active = YES;

}


- (void)didTapBlurButton {

	[self.delegate didTapGaussianBlurButton];

}


- (void)didTapInfoButton {

	[self.delegate didTapGaussianBlurInfoButton];

}


@end
