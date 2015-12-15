/**
 * @file
 * @author 单宝华
 * @date 2015-10-19
 */
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Model.h"

/**
 * @class DeviceAnnotation
 * @brief 设备地图信息
 * @author 单宝华
 * @date 2015-10-19
 */
@interface DeviceAnnotation : NSObject <MKAnnotation>

//@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
//
//@property (nonatomic, readonly, copy) NSString *title;
//@property (nonatomic, readonly, copy) NSString *subtitle;
//
//- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

- (instancetype)initWithDevice:(DeviceModel *)device;

@end
