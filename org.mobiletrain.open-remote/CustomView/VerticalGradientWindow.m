//
//  VerticalGradientWindow.m
//  org.mobiletrain.open-remote
//
//  Created by LEAF on 15/10/26.
//
//

#import "VerticalGradientWindow.h"

@implementation VerticalGradientWindow

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    NSMutableArray *colors = [NSMutableArray array];
    CGFloat locations[2] = {0, 1};
    [colors addObject:(__bridge id)self.beginColor.CGColor];
    [colors addObject:(__bridge id)self.endColor.CGColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, locations);
    CGRect strokeRect = self.frame;
    CGPoint startPoint = CGPointMake(CGRectGetMidX(strokeRect), CGRectGetMinY(strokeRect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(strokeRect), CGRectGetMaxY(strokeRect));
    
    // 切割彩条
    CGContextSaveGState(context);
    CGContextAddRect(context, strokeRect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

@end
