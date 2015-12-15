/**
 * @file
 * @author 单宝华
 * @date 2014-12-9
 */
#import "PrimitiveLayer.h"

/**
 * @class LineSegmentLayer
 * @brief 直线图元
 * @author 单宝华
 * @date 2014-12-9
 */
@interface LineSegmentLayer : PrimitiveLayer

/// @brief start point
@property (assign, nonatomic) CGPoint start;

/// @brief end point
@property (assign, nonatomic) CGPoint end;

@end
