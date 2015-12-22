/**
 * @file
 * @author 单宝华
 * @date 2015-12-19
 */
#import <UIKit/UIKit.h>

/**
 * @class GroupMenuCell
 * @brief 群组cell
 * @author 单宝华
 * @date 2015-12-19
 */
@interface GroupMenuCell : UICollectionViewCell

/// @brief 图片
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

/// @brief 文字
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end
