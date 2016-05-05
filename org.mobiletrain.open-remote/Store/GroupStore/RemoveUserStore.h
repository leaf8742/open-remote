/**
 * @file
 * @author 单宝华
 * @date 2016-05-04
 */
#import "BaseStore.h"
@class GroupModel;
@class UserModel;

/**
 * @class RemoveUserStore
 * @brief 群组删除用户网络组件
 * @author 单宝华
 * @date 2016-05-04
 */
@interface RemoveUserStore : BaseStore

/// @brief 要踢人的群组
@property (strong, nonatomic) GroupModel *group;

/// @brief 要踢的人
@property (strong, nonatomic) UserModel *user;

@end
