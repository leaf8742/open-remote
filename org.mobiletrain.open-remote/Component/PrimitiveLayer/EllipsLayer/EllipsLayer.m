#import "EllipsLayer.h"

@implementation EllipsLayer

- (void)makeWithDictionaryRepresentation:(NSDictionary *)dict {
    [super makeWithDictionaryRepresentation:dict];
    CGRectMakeWithDictionaryRepresentation((CFDictionaryRef)[dict objectForKey : @"rect"], &_rect);
}

- (void)aspectWithSize:(CGSize)size {
    [super aspectWithSize:size];
    if ([self.aspectProperties containsObject:@"rect"]) {
        self.rect = CGRectMake(self.rect.origin.x * size.width / 2, self.rect.origin.y * size.height / 2, self.rect.size.width * size.width / 2, self.rect.size.height * size.height / 2);
    }
}

- (void)display {
    if (self.path) {
        CGPathRelease(self.path);
        self.path = nil;
    }

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddEllipseInRect(path, NULL, _rect);
    self.path = path;
}

@end
