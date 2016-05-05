/**
 * @file
 * @author 单宝华
 * @date 2016-05-04
 */
#import "BaseStore.h"
@class UserModel;

/**
 * @class FindUserStore
 * @brief 查找用户网络组件
 * @author 单宝华
 * @date 2016-05-04
 */
@interface FindUserStore : BaseStore

/// @brief 要查找的用户
@property (strong, nonatomic) UserModel *user;

@end
