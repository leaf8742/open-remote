/**
 * @file
 * @author 单宝华
 * @date 2015-10-17
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * @enum kTransitionType
 * @brief 转场动画类别
 * @author 单宝华
 * @date 2015-10-17
 */
typedef NS_ENUM(NSInteger, kTransitionType) {
    /// @brief 出现动画
    kTransitionTypePresent,
    
    /// @brief 消失动画
    kTransitionTypeDismiss,
};

/**
 * @class GroupMenuTransitionAnimator
 * @brief 组别选择页面的转场动画
 * @author 单宝华
 * @date 2015-10-17
 */
@interface GroupMenuTransitionAnimator : NSObject<UIViewControllerAnimatedTransitioning>

/// @brief 动画类别
@property (assign, nonatomic) kTransitionType transitionType;

@end
