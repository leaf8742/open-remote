#import "CircleLayer.h"

@implementation CircleLayer

- (void)makeWithDictionaryRepresentation:(NSDictionary *)dict {
    [super makeWithDictionaryRepresentation:dict];
    CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)[dict objectForKey : @"center"], &_center);
    _radius = [(NSNumber *) [dict objectForKey: @"radius"] floatValue];
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

- (void)display {
    if (self.path) {
        CGPathRelease(self.path); self.path = nil;
        self.path = nil;
    }

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, _center.x + _radius, _center.y);
    CGPathAddArc(path, NULL, _center.x, _center.y, _radius, 0.0, M_PI * 2, false);
    self.path = path;
}

@end
