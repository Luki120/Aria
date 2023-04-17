#import "Headers/Common.h"
@import Preferences.PSTableCell;


@class AriaGaussianBlurCell;

@protocol AriaGaussianBlurCellDelegate <NSObject>

@required
- (void)didTapGaussianBlurButtonInAriaGuassianBlurCell:(AriaGaussianBlurCell *)ariaGuassianBlurCell;
- (void)didTapGaussianBlurInfoButtonInAriaGaussianBlurCell:(AriaGaussianBlurCell *)ariaGuassianBlurCell;

@end


@interface AriaGaussianBlurCell : PSTableCell
@property (nonatomic, weak) id <AriaGaussianBlurCellDelegate> delegate;
@end
