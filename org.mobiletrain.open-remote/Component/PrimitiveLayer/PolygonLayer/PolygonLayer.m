#import "PolygonLayer.h"

@implementation PolygonLayer

- (id)init {
    if (self = [super init]) {
        self.points = [NSMutableArray array];
        self.close = YES;
    }
    return self;
}

- (void)aspectWithSize:(CGSize)size {
    [super aspectWithSize:size];
    if ([self.aspectProperties containsObject:@"points"]) {
        NSMutableArray *aspectPoints = [NSMutableArray array];
        for (NSValue *pointValue in self.points) {
            CGPoint point = [pointValue CGPointValue];
            point = CGPointMake(point.x * size.width / 2, point.y * size.height / 2);
            [aspectPoints addObject:[NSValue valueWithCGPoint:point]];
        }
        self.points = aspectPoints;
    }
}

- (void)makeWithDictionaryRepresentation:(NSDictionary *)dict {
    [super makeWithDictionaryRepresentation:dict];
    NSArray* pointsArray = [dict objectForKey:@"points"];
    
    for (NSDictionary* pointsDict in pointsArray) {
        CGPoint point;
        CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)pointsDict, &point);
        [self.points addObject : [NSValue valueWithCGPoint:point]];
    }
    
    if (dict[@"close"]) {
        self.close = [dict[@"close"] boolValue];
    }
}

- (void)display{
    if (self.path) {
        CGPathRelease(self.path);
        self.path = nil;
    }
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPoint begin = [[self.points firstObject] CGPointValue];
    CGPathMoveToPoint(path, NULL, begin.x, begin.y);
    for (NSInteger idx = 1; idx < [self.points count]; idx++) {
        CGPoint point   = [(NSValue *)[self.points objectAtIndex:idx] CGPointValue];
        CGPathAddLineToPoint(path, NULL, point.x, point.y);
    }
    if (self.close) {
        CGPathAddLineToPoint(path, NULL, begin.x, begin.y);
    }
    
    self.path = path;
}

@end
