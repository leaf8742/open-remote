/*
 * @file
 * @author 单宝华
 * @date 2015-10-12
 */
#import <UIKit/UIKit.h>
#import "CoordinatingController.h"

/**
 * @enum kScanType
 * @brief 要扫描的类型
 * @author 单宝华
 * @date 2015-12-27
 */
typedef NS_ENUM(NSInteger, kScanType) {
    /// @brief 扫描智能设备
    kScanTypeDevice,
    
    /// @brief 扫描用户
    kScanTypeUser,
};

/**
 * @class ScanViewController
 * @brief 二维码扫描页面
 * @author 单宝华
 * @date 2015-10-12
 */
@interface ScanViewController : UIViewController<CoordinatingControllerDelegate>

@property (assign, nonatomic) kScanType scanType;

@end
