#import "LineSegmentLayer.h"

@implementation LineSegmentLayer

- (void)makeWithDictionaryRepresentation:(NSDictionary *)dictionary {
    [super makeWithDictionaryRepresentation:dictionary];
    CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)[dictionary objectForKey:@"start"], &_start);
    CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)[dictionary objectForKey:@"end"], &_end);
}

- (void)aspectWithSize:(CGSize)size {
    [super aspectWithSize:size];
    if ([self.aspectProperties containsObject:@"start"]) {
        self.start = CGPointMake(self.start.x * size.width / 2, self.start.y * size.height / 2);
    }
    if ([self.aspectProperties containsObject:@"end"]) {
        self.end = CGPointMake(self.end.x * size.width / 2, self.end.y * size.height / 2);
    }
}

- (void)display{
    if (self.path) {
        CGPathRelease(self.path);
        self.path = nil;
    }
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, _start.x, _start.y);
    CGPathAddLineToPoint(path, NULL, _end.x, _end.y);
    self.path = path;
}

@end
