/**
 * @file
 * @author 单宝华
 * @date 2015-10-10
 */
#import <UIKit/UIKit.h>
#import "CoordinatingController.h"

/**
 * @class SignUpViewController
 * @brief 注册页面
 * @author 单宝华
 * @date 2015-10-10
 */
@interface SignUpViewController : UIViewController<CoordinatingControllerDelegate>

/// @brief 手机号码输入框
@property (weak, nonatomic) IBOutlet UITextField *mobile;

/// @brief 邮箱输入框
@property (weak, nonatomic) IBOutlet UITextField *email;

/// @brief 昵称输入框
@property (weak, nonatomic) IBOutlet UITextField *alias;

/// @brief 密码输入框
@property (weak, nonatomic) IBOutlet UITextField *passwd;

/// @brief 确认密码输入框
@property (weak, nonatomic) IBOutlet UITextField *confirm;

@end
