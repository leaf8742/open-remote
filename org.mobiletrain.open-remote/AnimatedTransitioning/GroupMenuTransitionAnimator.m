#import "GroupMenuTransitionAnimator.h"
#import "OverlayViewManager.h"

@implementation GroupMenuTransitionAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.5f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGRect endFrame = CGRectMake(20, 68, screenSize.width - 40, 100);
    
    if (self.transitionType == kTransitionTypePresent) {
//        [OverlayViewManager generateTouchEvent:^{
//            [toViewController dismissViewControllerAnimated:YES completion:^{
//            }];
//        }];
//        [OverlayViewManager setOverlayView:toViewController.view];
        
//        fromViewController.view.userInteractionEnabled = NO;
        
        [transitionContext.containerView addSubview:toViewController.view];
        
        CGRect startFrame = endFrame;
        startFrame.origin.x += 320;
        
        toViewController.view.frame = startFrame;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromViewController.view.alpha = 0.5;
//            fromViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
            toViewController.view.frame = endFrame;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    } else {
        endFrame.origin.x -= 320;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            toViewController.view.alpha = 1;
//            toViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
            fromViewController.view.frame = endFrame;
        } completion:^(BOOL finished) {
//            toViewController.view.userInteractionEnabled = YES;
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
}
@end
