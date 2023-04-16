#import "Headers/Common.h"
@import Preferences.PSTableCell;


@protocol AriaGaussianBlurCellDelegate <NSObject>

@required
- (void)ariaGaussianBlurCellDidTapGaussianBlurButton;
- (void)ariaGaussianBlurCellDidTapGaussianBlurInfoButton;

@end


@interface AriaGaussianBlurCell : PSTableCell
@property (nonatomic, weak) id <AriaGaussianBlurCellDelegate> delegate;
@end
