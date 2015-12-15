/**
 * @file
 * @author 单宝华
 * @date 2015-10-17
 */
#import "BaseStore.h"

@class DeviceModel;
@class GroupModel;

/**
 * @class AddDeviceStore
 * @brief 添加设备网络组件
 * @author 单宝华
 * @date 2015-10-17
 */
@interface AddDeviceStore : BaseStore

/// @brief 被添加的设备
@property (strong, nonatomic) DeviceModel *device;

/// @brief 将设备添加到哪一个组别
@property (strong, nonatomic) GroupModel *group;

@end
