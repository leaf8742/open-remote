/**
 * @file
 * @author 单宝华
 * @date 2013/09/15
 */
#import <UIKit/UIKit.h>

/**
 * @class GraphicsAssist
 * @brief 图形处理类
 * @author 单宝华
 * @date 2013/09/15
 */
@interface GraphicsAssist : NSObject

/// @brief 弧线裁剪图片
/// @param image 被裁剪的图片
/// @param center 弧线的圆心
/// @param radius 弧线的半径
/// @param startAngle 弧线的起始角度
/// @param endAngle 弧线的结束角度
/// @param clockwise 是否顺时针旋转
+ (UIImage *)trimImage:(UIImage *)image center:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise;

/// @brief 根据UIColor返回UIImage
+ (UIImage *)createImageWithColor:(UIColor *) color size:(CGSize)size;

/// @brief 根据UIColor返回UIImage
+ (UIImage *)createImageWithColor:(UIColor *) color;

/// @brief 将图片渲染为指定颜色
+ (UIImage *)maskImage:(UIImage *)image withColor:(UIColor *)color;

///// @brief 切割
//#warning 未完成
//+ (UIImage *)clipImage:(UIImage *)clipImage maskImage:(UIImage *)maskImage maskPoint:(CGPoint)point;

/// @brief 彩图变灰度图
+ (UIImage*)getGrayImage:(UIImage*)sourceImage;

/// @brief 压缩图片到指定大小
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;

/// @brief 圆心(0, 0)转换radian角度后在point点，求原位置
+ (CGPoint)reverseRotation:(CGFloat)radian center:(CGPoint)center point:(CGPoint)point;

@end
