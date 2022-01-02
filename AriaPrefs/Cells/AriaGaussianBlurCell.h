#import "Headers/Constants.h"
#import "Managers/AriaImageManager.h"
#import <Preferences/PSTableCell.h>


@protocol AriaGaussianBlurCellDelegate <NSObject>

@required - (void)didTapGaussianBlurButton;
@required - (void)didTapGaussianBlurInfoButton;

@end


@interface AriaGaussianBlurCell : PSTableCell
@property (nonatomic, weak) id <AriaGaussianBlurCellDelegate> delegate;
@end
