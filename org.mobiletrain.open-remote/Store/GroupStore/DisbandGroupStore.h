/**
 * @file
 * @author 单宝华
 * @date 2016-05-04
 */
#import "BaseStore.h"
@class GroupModel;

/**
 * @class DisbandGroupStore
 * @brief 解散用户网络组件
 * @author 单宝华
 * @date 2016-05-04
 */
@interface DisbandGroupStore : BaseStore

/// @brief 要解散的群组
@property (strong, nonatomic) GroupModel *group;

@end
