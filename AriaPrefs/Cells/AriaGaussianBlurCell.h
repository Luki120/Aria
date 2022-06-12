#import "Headers/Constants.h"
#import <Preferences/PSTableCell.h>


@protocol AriaGaussianBlurCellDelegate <NSObject>

@required
- (void)ariaGaussianBlurCellDidTapGaussianBlurButton;
- (void)ariaGaussianBlurCellDidTapGaussianBlurInfoButton;

@end


@interface AriaGaussianBlurCell : PSTableCell
@property (nonatomic, weak) id <AriaGaussianBlurCellDelegate> delegate;
@end
