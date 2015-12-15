/**
 * @file
 * @author 单宝华
 * @date 2014-12-9
 */
#import "PrimitiveLayer.h"

/**
 * @class CircleLayer
 * @brief 圆形图元
 * @author 单宝华
 * @date 2014-12-9
 */
@interface CircleLayer : PrimitiveLayer

/// @brief 中心点
@property (assign, nonatomic) CGPoint center;

/// @brief 半径
@property (assign, nonatomic) CGFloat radius;

@end
