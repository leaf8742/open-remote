/**
 * @file
 * @author 单宝华
 * @date 2013/09/25
 * @copyright 大连一丁芯智能技术有限公司
 */
#import "InputValidator.h"

/**
 * @class MobileInputValidator
 * @brief 手机号码验证策略
 * @author 单宝华
 * @date 2013/09/25
 */
@interface MobileInputValidator : InputValidator

/// @brief 验证手机号
+ (BOOL)validateMobile:(NSString *)mobile;

@end
