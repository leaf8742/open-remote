/**
 * @file
 * @author 单宝华
 * @date 2015-10-22
 */
#import "BaseStore.h"
@class DeviceModel;

/**
 * @class ModifyDeviceNameStore
 * @brief 设备改名网络组件
 * @author 单宝华
 * @date 2015-10-22
 */
@interface ModifyDeviceNameStore : BaseStore

/// @brief 设备的新名字
@property (copy, nonatomic) NSString *name;

/// @brief 要修改的设备
@property (strong, nonatomic) DeviceModel *device;

@end
