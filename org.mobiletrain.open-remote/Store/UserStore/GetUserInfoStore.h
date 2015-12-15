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
@interface GetUserInfoStore : BaseStore

/// @brief 要获取的用户的用户ID
@property (copy, nonatomic) NSString *userId;

@end
