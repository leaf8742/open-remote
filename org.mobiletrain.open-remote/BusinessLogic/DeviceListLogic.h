/**
 * @file
 * @author 单宝华
 * @date 2015-10-11
 */
#import <Foundation/Foundation.h>

/**
 * @class DeviceListLogic
 * @brief 设备列表业务逻辑
 * @description 进入设备列表页后，先请求群组列表，再请求设备列表
 * @author 单宝华
 * @date 2015-10-11
 */
@interface DeviceListLogic : NSObject

- (void)operateWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure;

@end
