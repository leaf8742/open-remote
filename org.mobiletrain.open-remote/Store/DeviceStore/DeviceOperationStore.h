/**
 * @file
 * @author 单宝华
 * @date 2015-10-22
 */
#import "BaseStore.h"
@class DeviceModel;

/**
 * @class DeviceOperationStore
 * @brief 设备操作网络组件
 * @author 单宝华
 * @date 2015-10-22
 */
@interface DeviceOperationStore : BaseStore

/// @brief 设置设备的开关状态
@property (assign, nonatomic) BOOL powerOn;

/// @brief 要设置的是哪一个设备
@property (strong, nonatomic) DeviceModel *device;

@end
