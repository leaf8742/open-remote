#import "GroupLocationViewController.h"
#import "DeviceAnnotation.h"

@interface GroupLocationViewController ()<CLLocationManagerDelegate, MKMapViewDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation GroupLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    [self.locationManager requestWhenInUseAuthorization];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.locationManager startUpdatingLocation];
    });
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    // 获得定位到的经纬度
    CLLocation *location = [locations objectAtIndex:0];
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    // 设置缩放比例，MKCoordinateSpanMake第1个参数：经度缩放比例；第2个参数：纬度缩放比例
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
    
    // 计算显示区域
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
    
    // 设置显示区域
    [self.mapView setRegion:region animated:YES];
    
    DeviceAnnotation *annotation = [[DeviceAnnotation alloc] initWithDevice:[GroupListModel sharedInstance].selectedGroup.selectedDevice];
    
    [self.mapView addAnnotation:annotation];
    
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
}

#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
}

#pragma mark - CoordinatingControllerDelegate
+ (instancetype)buildViewController {
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [main instantiateViewControllerWithIdentifier:@"GroupLocationViewController"];
}

#pragma mark - Memory Management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
