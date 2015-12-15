/**
 * @file
 * @author 单宝华
 * @date 2013/09/25
 * @copyright 大连一丁芯智能技术有限公司
 */
#import "InputValidator.h"

/**
 * @class EmailInputValidator
 * @brief E-mail验证策略
 * @author 单宝华
 * @date 2013/09/25
 */
@interface EmailInputValidator : InputValidator

/// @brief 验证邮箱
+ (BOOL)validateEmail:(NSString*)email;

@end
