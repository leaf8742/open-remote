/**
 * @file
 * @author 单宝华
 * @date 2014-12-9
 */
#import "PrimitiveLayer.h"

/**
 * @class ArcLayer
 * @brief 弧线图元
 * @author 单宝华
 * @date 2014-12-9
 */
@interface ArcLayer : PrimitiveLayer

@property (assign, nonatomic) CGPoint	center;
@property (assign, nonatomic) CGPoint	initPoint;
@property (assign, nonatomic) CGFloat	startAngle;
@property (assign, nonatomic) CGFloat	endAngle;
@property (assign, nonatomic) CGFloat	radius;
@property (assign, nonatomic) BOOL		clockwised;

@end
