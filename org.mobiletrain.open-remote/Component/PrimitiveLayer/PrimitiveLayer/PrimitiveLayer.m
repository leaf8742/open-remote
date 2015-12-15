#import "PrimitiveLayer.h"
#import "LineSegmentLayer.h"
#import "RectangleLayer.h"
#import "CircleLayer.h"
#import "EllipsLayer.h"
#import "ArcLayer.h"
#import "PolygonLayer.h"
#import <HexColors/HexColors.h>

@implementation PrimitiveLayer

- (instancetype)init {
    if (self = [super init]) {
        self.lineCap = kCALineCapRound;
        self.lineJoin = kCALineJoinRound;
    }
    return self;
}

- (void)aspectWithSize:(CGSize)size {
    if ([self.aspectProperties containsObject:@"lineWidth"]) {
        self.lineWidth *= size.width / 2 * self.lineWidth;
    }
}

+ (void)appearance:(NSString *)appearance drawWithBoard:(CALayer *)board {
    NSURL *path =  [[NSBundle mainBundle]URLForResource:@"Scheme" withExtension:@"plist"];
    NSDictionary *symbols = [NSDictionary dictionaryWithContentsOfURL:path];
    NSDictionary *symbol = [symbols objectForKey:appearance];
    NSArray *primitives = [symbol objectForKey:@"primitives"];
    
    for (NSDictionary *dictionary in primitives) {
        PrimitiveLayer *layer = [PrimitiveLayer primitiveFromDictionaryRepresent:dictionary];
        [board addSublayer:layer];
        [layer setNeedsDisplay];
    }
}

+ (PrimitiveLayer *)primitiveFromDictionaryRepresent:(NSDictionary *)dictionary {
    PrimitiveLayer *primitive;
    switch ([[dictionary objectForKey:@"kind"] integerValue]) {
        case kPrimitiveKindLineSegment: {
            primitive = [LineSegmentLayer layer];
        }
            break;
        case kPrimitiveKindRectangle: {
            primitive = [RectangleLayer layer];
        }
            break;
        case kPrimitiveKindCircle: {
            primitive = [CircleLayer layer];
        }
            break;
        case kPrimitiveKindEllips: {
            primitive = [EllipsLayer layer];
        }
            break;
        case kPrimitiveKindArc: {
            primitive = [ArcLayer layer];
        }
            break;
        case kPrimitiveKindPolygon: {
            primitive = [PolygonLayer layer];
        }
            break;
        default: {
            primitive = nil;
        }
            break;
    }
    
    // 读取属性
    [primitive makeWithDictionaryRepresentation:dictionary];
    return primitive;
}

- (void)makeWithDictionaryRepresentation:(NSDictionary *)dictionary {
    // 画笔颜色
    if ([dictionary objectForKey:@"strokeColor"]) {
        self.strokeColor = [HXColor hx_colorWithHexString:[dictionary objectForKey:@"strokeColor"]].CGColor;
    } else {
        self.strokeColor = [UIColor blackColor].CGColor;
    }
    
    // 填充颜色
    if ([dictionary objectForKey:@"fillColor"]) {
        self.fillColor = [HXColor hx_colorWithHexString:[dictionary objectForKey:@"fillColor"]].CGColor;
    } else {
        self.fillColor = [UIColor clearColor].CGColor;
    }
    
    // 画笔宽度
    if ([dictionary objectForKey:@"lineWidth"]) {
        self.lineWidth = [[dictionary objectForKey:@"lineWidth"] floatValue];
    } else {
        self.lineWidth = 0.5;
    }
}

@end
