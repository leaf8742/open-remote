#import "ArcLayer.h"

@implementation ArcLayer

- (void)makeWithDictionaryRepresentation:(NSDictionary *)dict {
    [super makeWithDictionaryRepresentation:dict];
    CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)[dict objectForKey : @"center"], &_center);
    CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)[dict objectForKey : @"initPoint"], &_initPoint);
    _startAngle = [(NSNumber *) [dict objectForKey : @"startAngle"] floatValue];
    _endAngle = [(NSNumber *) [dict objectForKey : @"endAngle"] floatValue];
    _radius = [(NSNumber *) [dict objectForKey : @"radius"] floatValue];
    _clockwised = [(NSNumber *)[dict objectForKey : @"clockwised"] boolValue];
}

- (void)aspectWithSize:(CGSize)size {
    [super aspectWithSize:size];
    if ([self.aspectProperties containsObject:@"radius"]) {
        self.radius *= size.width / 2;
    }
    if ([self.aspectProperties containsObject:@"center"]) {
        self.center = CGPointMake(self.center.x * size.width / 2, self.center.y * size.height / 2);
    }
}

- (void)display{
    if (self.path) {
        CGPathRelease(self.path);
        self.path = nil;
    }
    
    self.initPoint = CGPointMake(
                                 _center.x + cosf(M_PI * _startAngle) * _radius,
                                 _center.y + sinf(M_PI * _startAngle) * _radius);

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, _initPoint.x, _initPoint.y);
    CGPathAddArc(path, NULL, _center.x, _center.y, _radius, M_PI * _startAngle, M_PI * _endAngle, _clockwised);
    self.path = path;
}

@end
