/**
 * @file
 * @author 单宝华
 * @date 2016-05-04
 */
#import "BaseStore.h"
@class GroupModel;

/**
 * @class QuitGroupStore
 * @brief 退出群组网络组件
 * @author 单宝华
 * @date 2016-05-04
 */
@interface QuitGroupStore : BaseStore

/// @brief 要退出的群组
@property (strong, nonatomic) GroupModel *group;

@end
