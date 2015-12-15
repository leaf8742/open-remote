/**
 * @file
 * @author 单宝华
 * @date 2015-10-17
 */
#import <UIKit/UIKit.h>

/**
 * @class OverlayView
 * @brief 遮罩罢，点击时响应block内的消息
 * @author 单宝华
 * @date 2015-10-17
 */
@interface OverlayViewManager : NSObject

//@property (copy, nonatomic)

+ (void)setOverlayView:(UIView *)overlayView;

+ (void)generateTouchEvent:(void (^)())touchEvent;

@end
