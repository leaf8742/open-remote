/**
 * @file
 * @author 单宝华
 * @date 2015-10-19
 */
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CoordinatingController.h"

/**
 * @class GroupLocationViewController
 * @brief 群组定位视图
 * @author 单宝华
 * @date 2015-10-19
 */
@interface GroupLocationViewController : UIViewController<CoordinatingControllerDelegate>

/// @brief 地图视图
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
