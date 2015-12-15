/**
 * @file
 * @author 单宝华
 * @date 2014-12-9
 */
#import "PrimitiveLayer.h"

/**
 * @class PolygonLayer
 * @brief 多边形图元
 * @author 单宝华
 * @date 2014-12-9
 */
@interface PolygonLayer : PrimitiveLayer

/// @brief 坐标点(NSValue CGPoint)
@property (retain, nonatomic) NSMutableArray* points;

/// @brief 是否闭合，默认为YES
@property (assign, nonatomic) BOOL close;

@end
