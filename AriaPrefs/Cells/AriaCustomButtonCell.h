#import "Constants/Constants.h"
#import "Managers/AriaImageManager.h"
#import <Preferences/PSTableCell.h>


@protocol AriaCustomButtonCellDelegate <NSObject>

@required - (void)didTapGaussianBlurInfoButton;

@end


@interface AriaCustomButtonCell : PSTableCell
@property (nonatomic, weak) id <AriaCustomButtonCellDelegate> delegate;
- (void)didTapButton;
@end
