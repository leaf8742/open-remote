/**
 * @file
 * @author 单宝华
 * @date 2015-10-10
 */
#import <UIKit/UIKit.h>
#import "CoordinatingController.h"

/**
 * @class SignInViewController
 * @brief 登录页面
 * @author 单宝华
 * @date 2015-10-10
 */
@interface SignInViewController : UIViewController<CoordinatingControllerDelegate>

/// @brief 用户名输入框
@property (weak, nonatomic) IBOutlet UITextField *account;

/// @brief 密码输入框
@property (weak, nonatomic) IBOutlet UITextField *passwd;

/// @brief 注册
@property (weak, nonatomic) IBOutlet UIButton *signUp;

/// @brief 忘记密码
@property (weak, nonatomic) IBOutlet UIButton *forgetPasswd;

- (IBAction)signUp:(id)sender;

- (IBAction)backgroundTap:(id)sender;

@end
