/**
 * @file
 * @author 单宝华
 * @date 2013-09-25
 */
#import <UIKit/UIKit.h>
static NSString * const InputValidationErrorDomain = @"InputValidationErrorDomain";

/**
 * @class InputValidator
 * @brief 验证策略共同基类
 * @author 单宝华
 * @date 2013-09-25
 */
@interface InputValidator : NSObject

/// @brief 验证策略
- (BOOL)validateInput:(UITextField *)input error:(NSError**)error;

/// @brief 运行时验证策略
- (BOOL)validateInput:(UITextField *)input shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string error:(NSError **)error;

/// @brief 编辑结束时验证策略
- (void)textFieldDidEndEditing:(UITextField *)textField;

@end
