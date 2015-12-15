/**
 * @file
 * @author 单宝华
 * @date 2015-10-10
 */
#import <UIKit/UIKit.h>
#import "CoordinatingController.h"

/**
 * @class ProfileViewController
 * @brief 主页面的左侧滑动菜单
 * @author 单宝华
 * @date 2015-10-10
 */
@interface ProfileViewController : UIViewController<CoordinatingControllerDelegate>
- (IBAction)signOut:(UIButton *)sender;

@end
