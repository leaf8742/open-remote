/**
 * @file
 * @author 单宝华
 * @date 2015-10-10
 */
#import <UIKit/UIKit.h>
#import <RESideMenu/RESideMenu.h>
#import "CoordinatingController.h"

@class DeviceListViewController;
@class GroupListViewController;
@class EaseMessageViewController;

/**
 * @class HomePageViewController
 * @brief 主页面，其中包括(家居、群组2个Tab页面)
 * @author 单宝华
 * @date 2015-10-10
 */
@interface HomePageViewController : RESideMenu<CoordinatingControllerDelegate>

/// @brief 家居页面
@property (strong, nonatomic) DeviceListViewController *deviceListVC;

/// @brief 群组页面
@property (strong, nonatomic) EaseMessageViewController *chatViewController;

@end
