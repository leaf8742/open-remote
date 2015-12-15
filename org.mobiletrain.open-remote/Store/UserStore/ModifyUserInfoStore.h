/**
 * @file
 * @author 单宝华
 * @date 2015-10-05
 */
#import "BaseStore.h"

/**
 * @class ModifyUserInfoStore
 * @brief 更新用户信息网络组件
 * @author 单宝华
 * @date 2015-10-05
 */
@interface ModifyUserInfoStore : BaseStore

/// @brief 要修改的手机号码
@property (copy, nonatomic) NSString *mobile;

/// @brief 要修改的邮箱
@property (copy, nonatomic) NSString *email;

/// @brief 要修改的用户名
@property (copy, nonatomic) NSString *alias;

@end
