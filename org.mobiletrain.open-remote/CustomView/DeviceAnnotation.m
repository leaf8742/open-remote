#import "DeviceAnnotation.h"

@interface DeviceAnnotation()

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end


@implementation DeviceAnnotation

- (instancetype)initWithDevice:(DeviceModel *)device {
    if (self = [self init]) {
        self.title = device.name;
        self.subtitle = device.identity;
        [self setCoordinate:device.coordinate];
    }
    return self;
}


- (instancetype)init {
    if (self = [super init]) {
        self.title = @"主标题";
        self.subtitle = @"辅标题";
    }
    return self;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    _coordinate = newCoordinate;
}

@end
