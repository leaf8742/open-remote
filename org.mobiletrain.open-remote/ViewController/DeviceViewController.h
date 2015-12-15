/**
 * @file
 * @author 单宝华
 * @date 2015-10-17
 */
#import <UIKit/UIKit.h>
#import "CoordinatingController.h"

/**
 * @class DeviceViewController
 * @brief 设备操作页面
 * @author 单宝华
 * @date 2015-10-17
 */
@interface DeviceViewController : UIViewController<CoordinatingControllerDelegate>

/// @brief 开关设备
@property (weak, nonatomic) IBOutlet UISwitch *powerOn;

/// @brief 开关设备
- (IBAction)powerSwitch:(UISwitch *)sender;

/// @brief 定位
- (IBAction)locate:(UIButton *)sender;

/// @brief 任务列表
- (IBAction)taskList:(UIButton *)sender;

/// @brief 设置
- (IBAction)setting:(UIButton *)sender;

@end
