/**
 * @file
 * @author 单宝华
 * @date 2015-10-05
 */
#import "BaseStore.h"
#import "UserModel.h"

/**
 * @class SignUpStore
 * @brief 注册网络组件
 * @author 单宝华
 * @date 2015-10-05
 */
@interface SignUpStore : BaseStore

/// @brief 用户手机号码
@property (copy, nonatomic) NSString *mobile;

/// @brief 用户邮箱
@property (copy, nonatomic) NSString *email;

/// @brief 用户昵称
@property (copy, nonatomic) NSString *alias;

/// @brief 用户密码
@property (copy, nonatomic) NSString *passwd;

/// @brief 性别
@property (assign, nonatomic) kGender gender;

@end
