/**
 * @file
 * @author 单宝华
 * @date 2014-12-9
 */
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

/**
 * @enum kPrimitiveKind
 * @brief 图形类型
 * @author 单宝华
 * @date 2014-12-9
 */
typedef NS_ENUM(NSInteger, kPrimitiveKind) {
    /// @brief 直线
    kPrimitiveKindLineSegment = 0,
    
    /// @brief 矩形
    kPrimitiveKindRectangle,
    
    /// @brief 圆形
    kPrimitiveKindCircle,
    
    /// @brief 椭圆
    kPrimitiveKindEllips,
    
    /// @brief 弧形
    kPrimitiveKindArc,
    
    /// @brief 多边形
    kPrimitiveKindPolygon
};

/**
 * @class PrimitiveLayer
 * @brief 基础图元
 * @author 单宝华
 * @date 2014-12-9
 */
@interface PrimitiveLayer : CAShapeLayer

/// @brief 参与缩放的属性，数组当中都是当前类的KVC
@property (strong, nonatomic) NSArray *aspectProperties;

/// @brief 缩放的参照尺寸
/// @description 如果PrimitiveLayer子类的某些坐标、数值属性，是单元坐标系的，需要对照此参照尺寸进行缩放
- (void)aspectWithSize:(CGSize)size;

/**
 * @brief 在画板上画图
 * @param appearance 外观描述
 * @param board 画板
 */
+ (void)appearance:(NSString *)appearance drawWithBoard:(CALayer *)board;

/// @brief 创建基础图元
+ (PrimitiveLayer *)primitiveFromDictionaryRepresent:(NSDictionary *)dictionary;

/// @brief 读取字典中的信息
- (void)makeWithDictionaryRepresentation:(NSDictionary *)dictionary;

@end
