/**
 * @file
 * @author 单宝华
 * @date 2014-12-9
 */
#import "PrimitiveLayer.h"

/**
 * @class RectangleLayer
 * @brief 矩形图元
 * @author 单宝华
 * @date 2014-12-9
 */
@interface RectangleLayer : PrimitiveLayer

/// @brief 矩形
@property (assign, nonatomic) CGRect rect;

/// @bref 圆角半径
@property (assign, nonatomic) CGFloat rectCornerRadius;

/// @brief 隐藏左上角圆角
@property (assign, nonatomic) BOOL hideLU;

/// @brief 隐藏右上角圆角
@property (assign, nonatomic) BOOL hideRU;

/// @brief 隐藏左下角圆角
@property (assign, nonatomic) BOOL hideLB;

/// @brief 隐藏右下角圆角
@property (assign, nonatomic) BOOL hideRB;

@end
