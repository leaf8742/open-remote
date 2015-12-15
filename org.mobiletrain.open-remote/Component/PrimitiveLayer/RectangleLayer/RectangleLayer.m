#import "RectangleLayer.h"

@implementation RectangleLayer

- (void)makeWithDictionaryRepresentation : (NSDictionary*) dict{
    [super makeWithDictionaryRepresentation:dict];
    CGRectMakeWithDictionaryRepresentation((CFDictionaryRef)[dict objectForKey:@"rect"], &_rect);
    _rectCornerRadius = [(NSNumber*)[dict objectForKey:@"cornerRadius"] floatValue];
    _hideLU = [(NSNumber *)[dict objectForKey:@"hideLU"] boolValue];
    _hideRU = [(NSNumber *)[dict objectForKey:@"hideRU"] boolValue];
    _hideLB = [(NSNumber *)[dict objectForKey:@"hideLB"] boolValue];
    _hideRB = [(NSNumber *)[dict objectForKey:@"hideRB"] boolValue];
}

- (void)aspectWithSize:(CGSize)size {
    [super aspectWithSize:size];
    if ([self.aspectProperties containsObject:@"rect"]) {
        self.rect = CGRectMake(self.rect.origin.x * size.width / 2, self.rect.origin.y * size.height / 2, self.rect.size.width * size.width / 2, self.rect.size.height * size.height / 2);
    }
}

- (void) display{
    if (self.path) {
        CGPathRelease(self.path);
        self.path = nil;
    }
    
    CGMutablePathRef path = CGPathCreateMutable();
    if (!_hideLU) {
        CGPathMoveToPoint(path, NULL, CGRectGetMinX(_rect) + _rectCornerRadius, CGRectGetMinY(_rect));
    } else {
        CGPathMoveToPoint(path, NULL, CGRectGetMinX(_rect), CGRectGetMinY(_rect));
    }
    
    if (!_hideRU) {
        CGPathAddArc(path, NULL, CGRectGetMaxX(_rect) - _rectCornerRadius, CGRectGetMinY(_rect) + _rectCornerRadius, _rectCornerRadius, M_PI * 1.5, 0.0, false);
    } else {
        CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(_rect), CGRectGetMinY(_rect));
    }
    
    if (!_hideRB) {
        CGPathAddArc(path, NULL, CGRectGetMaxX(_rect) - _rectCornerRadius, CGRectGetMaxY(_rect) - _rectCornerRadius, _rectCornerRadius, 0.0, M_PI * 0.5, false);
    } else {
        CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(_rect), CGRectGetMaxY(_rect));
    }
    
    if (!_hideLB) {
        CGPathAddArc(path, NULL, CGRectGetMinX(_rect) + _rectCornerRadius, CGRectGetMaxY(_rect) - _rectCornerRadius, _rectCornerRadius, M_PI * 0.5, M_PI, false);
    } else {
        CGPathAddLineToPoint(path, NULL, CGRectGetMinX(_rect), CGRectGetMaxY(_rect));
    }
    
    if (!_hideLU) {
        CGPathAddArc(path, NULL, CGRectGetMinX(_rect) + _rectCornerRadius, CGRectGetMinY(_rect) + _rectCornerRadius, _rectCornerRadius, M_PI, M_PI * 1.5, false);
    } else {
        CGPathAddLineToPoint(path, NULL, CGRectGetMinX(_rect), CGRectGetMinY(_rect));
    }
    
    self.path = path;
}

@end
