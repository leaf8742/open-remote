/**
 * @file
 * @author 单宝华
 * @date 2015-10-05
 */
#import "BaseStore.h"

/**
 * @class SignInStore
 * @brief 登录网络组件
 * @author 单宝华
 * @date 2015-10-05
 */
@interface SignInStore : BaseStore

/// @brief 登录用户名，可以是手机号码，可以是邮箱
@property (copy, nonatomic) NSString *account;

/// @brief 登录密码
@property (copy, nonatomic) NSString *passwd;

@end
