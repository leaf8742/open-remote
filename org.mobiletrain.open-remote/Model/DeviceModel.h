/**
 * @file
 * @author 单宝华
 * @date 2015-10-05
 */
#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>
#import <CoreLocation/CoreLocation.h>

/**
 * @enum kDeviceType
 * @brief 设备类型
 * @author 单宝华
 * @date 2015-10-17
 */
typedef NS_ENUM(NSInteger, kDeviceType) {
    /// @brief 开关、插座
    kDeviceTypePower = 1,
    
    /// @brief 空调
    kDeviceTypeAirConditioner = 3,
    
    /// @brief 冰箱
    kDeviceTypeRefrigerator = 4
};

/**
 * @class DeviceModel
 * @brief 设备模型
 * @author 单宝华
 * @date 2015-10-05
 */
@interface DeviceModel : JSONModel

/// @brief 设备唯一标识
@property (copy, nonatomic) NSString *identity;

/// @brief 设备类型
@property (copy, nonatomic) NSString *type;

/// @brief 设备类型
@property (assign, nonatomic) kDeviceType typeCode;

/// @brief 图片
@property (copy, nonatomic) NSString *image;

/// @brief 名称
@property (copy, nonatomic) NSString *name;

/// @brief 定位信息
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;

/// @brief 任务列表
@property (strong, nonatomic) NSMutableArray<Optional> *tasks;

/// @brief 设备开关状态
@property (assign, nonatomic) BOOL powerOn;

/// @brief 查找设备
+ (DeviceModel *)deviceWithIdentity:(NSString *)identity;

@end
