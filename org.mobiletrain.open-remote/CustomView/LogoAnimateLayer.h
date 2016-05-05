/**
 * @file
 * @author 单宝华
 * @date 2015-11-25
 */
#import <QuartzCore/QuartzCore.h>

/**
 * @class LogoAnimateLayer
 * @brief 产品logo动画图层
 * @author 单宝华
 * @date 2015-11-25
 */
@interface LogoAnimateLayer : CALayer

/// @brief 是否需要动画载入，默认值为YES
@property (assign, nonatomic) BOOL animated;

/// @brief 图层尺寸，默认1024x1024
@property (assign, nonatomic) CGSize layerSize;

/// @brief 动画结束block
@property (copy, nonatomic) void(^completionBlock)();

/// @brief 准备房子多边形
- (void)preparePolygon;

/// @brief 准备指纹/信号弧线
- (void)prepareCircle;

/// @brief 开始动画
- (void)beginAnimate;

/// @brief 房子消失的动画
- (void)disappearHouse;

@end
