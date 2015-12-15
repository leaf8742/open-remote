#import "InputValidator.h"

@implementation InputValidator

- (BOOL)shouldBeginEditing:(UITextField*)input {
    return TRUE;
}

// 验证策略
- (BOOL)validateInput:(UITextField*)input error:(NSError**)error {
    if (error) {
        *error = nil;
    }
    return NO;
}

// 编辑时验证策略
- (BOOL)validateInput:(UITextField *)input shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string error:(NSError **)error {
    if (error) {
        *error = nil;
    }
    return NO;
}

// 编辑结束时验证策略
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

@end
