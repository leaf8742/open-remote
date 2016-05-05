/**
 * @file
 * @author 单宝华
 * @date 2016-05-04
 */
#import "BaseStore.h"
@class GroupModel;
@class UserModel;

/**
 * @class AddUserStore
 * @brief 群组添加用户网络组件
 * @author 单宝华
 * @date 2016-05-04
 */
@interface AddUserStore : BaseStore

/// @brief 向哪个群组当中添加用户
@property (strong, nonatomic) GroupModel *group;

/// @brief 要添加哪个用户
@property (strong, nonatomic) UserModel *user;

@end
