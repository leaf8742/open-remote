#import "LogoAnimateLayer.h"
#import "ArcLayer.h"
#import "PolygonLayer.h"
#import <pop/POP.h>
#import "CoordinatingController.h"
#import "SignInViewController.h"

@interface LogoAnimateLayer()

/// @brief 圆弧图层数组
@property (strong, nonatomic) NSMutableArray *circles;

/// @brief 多边形图层
@property (strong, nonatomic) PolygonLayer *polygon;

/// @brief 当前的圆动画，运行到第几个了
@property (assign, nonatomic) NSInteger currentAnimateCircleIndex;

@end


@implementation LogoAnimateLayer

- (instancetype)init {
    if (self = [super init]) {
        self.layerSize = CGSizeMake(1024, 1024);
        self.animated = YES;
    }
    return self;
}

- (void)skip:(id)sender {
    if (self.completionBlock) {
        self.completionBlock();
    }
}

- (void)beginAnimate {
    POPDecayAnimation *animation = [POPDecayAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
    animation.name = @"line";
    animation.delegate = self;
    animation.velocity = @2.1;
    animation.deceleration = 0.998;
    [self.polygon pop_addAnimation:animation forKey:kPOPShapeLayerStrokeEnd];
}

- (void)disappearHouse {
    POPBasicAnimation *animation = [POPBasicAnimation linearAnimation];
    animation.name = @"line";
    animation.property = [POPAnimatableProperty propertyWithName:kPOPShapeLayerStrokeStart];
    animation.toValue = @1;
    animation.duration = 0.8;
    [self.polygon pop_addAnimation:animation forKey:kPOPShapeLayerStrokeStart];
}

- (NSDictionary *)resourceObject {
    NSData *resourse = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LogoAnimateResource" ofType:@"json"]];
    NSDictionary *resourceObject = [NSJSONSerialization JSONObjectWithData:resourse options:NSJSONReadingMutableContainers error:nil];
    return resourceObject;
}

- (void)prepareCircle {
    self.circles = [NSMutableArray array];
    
    [[self resourceObject][@"circles"] enumerateObjectsUsingBlock:^(NSDictionary *circleItem, NSUInteger idx, BOOL *stop) {
        ArcLayer *arcLayer = [ArcLayer layer];
        arcLayer.aspectProperties = @[@"lineWidth", @"center", @"radius"];
        [arcLayer makeWithDictionaryRepresentation:circleItem];
        [arcLayer aspectWithSize:self.layerSize];
        arcLayer.lineWidth = 2;
        arcLayer.position = CGPointMake(self.layerSize.width / 2, self.layerSize.height / 2);
        if (idx == 0) {
            if (self.animated)
                arcLayer.fillColor = [UIColor clearColor].CGColor;
        } else {
            arcLayer.strokeEnd = self.animated ? 0 : 1;
        }
        [arcLayer setNeedsDisplay];
        [self addSublayer:arcLayer];
        [self.circles addObject:arcLayer];
    }];
}

- (void)preparePolygon {
    self.polygon = [PolygonLayer layer];
    self.polygon.aspectProperties = @[@"lineWidth", @"points"];
    [self.polygon makeWithDictionaryRepresentation:[self resourceObject]];
    [self.polygon aspectWithSize:self.layerSize];
    self.polygon.position = CGPointMake(self.layerSize.width / 2, self.layerSize.height / 2);
    self.polygon.close = NO;
    self.polygon.lineWidth = 4;
    self.polygon.strokeEnd = self.animated ? 0 : 1;
    [self.polygon setNeedsDisplay];
    
    // 房屋外层渐变效果
    CAGradientLayer *gradLayer = [CAGradientLayer layer ];
    gradLayer.frame = CGRectMake(0, 0, self.layerSize.width, self.layerSize.height);
    [gradLayer setColors:@[(id)[UIColor greenColor].CGColor,
                           (id)[UIColor yellowColor].CGColor]];
    [gradLayer setLocations:@[@0, @1]];
    [gradLayer setStartPoint:CGPointMake(0.5, 0)];
    [gradLayer setEndPoint:CGPointMake(0.5, 1)];
    [gradLayer setMask:self.polygon];
    
//    // 房屋内部的竖线，镂空
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake((self.view.frame.size.width - rectSize) / 2, (self.view.frame.size.height - rectSize) / 2, rectSize, rectSize) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(40, 40)];
//    [path appendPath:[UIBezierPath bezierPathWithRect:self.view.layer.frame]];
//    shapeLayer.path = path.CGPath;
//    shapeLayer.fillRule = kCAFillRuleEvenOdd;
//    
//    maskLayer.mask = shapeLayer;
    
    [self addSublayer:gradLayer];
}

- (void)timerHandler:(NSTimer *)sender {
    if (self.currentAnimateCircleIndex == [self.circles count]) {
        [sender invalidate];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self performSelectorOnMainThread:@selector(skip:) withObject:nil waitUntilDone:NO];
        });
        return;
    }
    
    if (self.currentAnimateCircleIndex == 0) {
        POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPShapeLayerFillColor];
        animation.name = @"circle";
        animation.toValue = [UIColor redColor];
        animation.springBounciness = 0;
        animation.springSpeed = 12;
        [self.circles[self.currentAnimateCircleIndex++] pop_addAnimation:animation forKey:kPOPShapeLayerStrokeEnd];
    } else {
        POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
        animation.name = @"circle";
        animation.toValue = @1;
        animation.springBounciness = 0;
        animation.springSpeed = 20 - fabs((self.currentAnimateCircleIndex - 6.5) / 13) * 18;
        [self.circles[self.currentAnimateCircleIndex++] pop_addAnimation:animation forKey:kPOPShapeLayerStrokeEnd];
    }
}

#pragma mark - POPAnimationDelegate
- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished {
    if ([anim.name isEqualToString:@"line"]) {
        self.currentAnimateCircleIndex = 0;
        NSTimer *timer = [NSTimer timerWithTimeInterval:0.2 target:self selector:@selector(timerHandler:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    }
}

@end
