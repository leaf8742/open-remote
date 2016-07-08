/**
 * @file
 * @author 单宝华
 * @date 2015-11-28
 */
#import <UIKit/UIKit.h>
#import "InputValidator.h"

/**
 * @Category UITextField(InputValidator)
 * @brief 文本输入框验证策略
 * @author 单宝华
 * @date 2015-11-28
 */
@interface UITextField (InputValidator)

/// @brief 验证策略组件
@property (retain, nonatomic) IBOutlet InputValidator *inputValidator;

/// @brief 验证
- (BOOL)validateWithError:(NSError **)error;

/// @brief 运行时验证策略
- (BOOL)shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end
