/**
 * @file
 * @author 单宝华
 * @date 2016-05-04
 */
#import "BaseStore.h"
@class GroupModel;

/**
 * @class UserListStore
 * @brief 群组用户列表网络组件
 * @author 单宝华
 * @date 2016-05-04
 */
@interface UserListStore : BaseStore

/// @brief 要获取的是哪个群组的用户列表
@property (strong, nonatomic) GroupModel *group;

@end
