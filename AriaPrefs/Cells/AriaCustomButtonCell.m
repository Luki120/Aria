#import "AriaCustomButtonCell.h"


@implementation AriaCustomButtonCell {

	UILabel *gaussianBlurLabel;
	UIButton *gaussianBlurInfoButton;

}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier {

	self = [super initWithStyle:style reuseIdentifier:identifier specifier:specifier];

	[self setupUI];

	return self;

}


- (void)setupUI {

	gaussianBlurLabel = [UILabel new];
	gaussianBlurLabel.font = [UIFont systemFontOfSize: 17];
	gaussianBlurLabel.text = @"Gaussian Blur";
	gaussianBlurLabel.textColor = UIColor.labelColor;
	gaussianBlurLabel.userInteractionEnabled = YES;
	gaussianBlurLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self.contentView addSubview: gaussianBlurLabel];

	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapLabel)];
	tapGesture.numberOfTapsRequired = 1;
	[gaussianBlurLabel addGestureRecognizer: tapGesture];

	UIImage *buttonImage = [UIImage systemImageNamed: @"info.circle"];

	gaussianBlurInfoButton = [UIButton new];
	gaussianBlurInfoButton.tintColor = kAriaTintColor;
	gaussianBlurInfoButton.translatesAutoresizingMaskIntoConstraints = NO;
	[gaussianBlurInfoButton setImage : buttonImage forState: UIControlStateNormal];
	[gaussianBlurInfoButton addTarget : self action:@selector(didTapButton) forControlEvents: UIControlEventTouchUpInside];
	[self.contentView addSubview: gaussianBlurInfoButton];

	[self activateConstraints];

}


- (void)activateConstraints {

	[gaussianBlurLabel.centerYAnchor constraintEqualToAnchor : self.contentView.centerYAnchor].active = YES;
	[gaussianBlurLabel.leadingAnchor constraintEqualToAnchor : self.contentView.leadingAnchor constant : 15].active = YES;

	[gaussianBlurInfoButton.centerYAnchor constraintEqualToAnchor : self.contentView.centerYAnchor].active = YES;
	[gaussianBlurInfoButton.trailingAnchor constraintEqualToAnchor : self.contentView.trailingAnchor constant : -20].active = YES;

}


- (void)didTapLabel {

	[[AriaImageManager sharedInstance] blurImageWithImage];

}


- (void)didTapButton {

	[self.delegate didTapGaussianBlurInfoButton];

}


@end
