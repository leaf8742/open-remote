/**
 * @file
 * @author 单宝华
 * @date 2015-10-11
 */
#import "BaseStore.h"

@class GroupModel;

/**
 * @class DeviceListStore
 * @brief 获取设备列表网络组件
 * @author 单宝华
 * @date 2015-10-11
 */
@interface DeviceListStore : BaseStore

/// @brief 设备唯一标识
@property (strong, nonatomic) GroupModel *group;

@end
