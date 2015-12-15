/**
 * @file
 * @author 单宝华
 * @date 2013-09-25
 * @copyright 大连一丁芯智能技术有限公司
 */
#import "InputValidator.h"

/**
 * @class ConfirmInputValidator
 * @brief 密码确认验证策略
 * @author 单宝华
 * @date 2013-09-25
 */
@interface ConfirmInputValidator : InputValidator

/// @brief 对应的密码框
@property (weak, nonatomic) IBOutlet UITextField *password;

@end
