#import "PasswordInputValidator.h"

@implementation PasswordInputValidator

- (BOOL)validateInput:(UITextField *)input error:(NSError **)error {
    // 最少6位
    if (input.text.length < 6) {
        if (error != nil) {
            NSString *description = NSLocalizedString(nil, @"");
            NSString *reason = NSLocalizedString(@"密码长度6-18位", @"");
            if ([input.text length] == 0) {
                reason = NSLocalizedString(@"请输入密码", @"");
            }
            NSArray *objArray = [NSArray arrayWithObjects:description, reason, nil];
            NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey, NSLocalizedFailureReasonErrorKey, nil];

            NSDictionary *userInfo = [NSDictionary dictionaryWithObjects:objArray forKeys:keyArray];
            *error = [NSError errorWithDomain:InputValidationErrorDomain code:1001 userInfo:userInfo];
        }
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)validateInput:(UITextField *)input shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string error:(NSError **)error {
    // 最多18位
    NSString *result = [input.text stringByReplacingCharactersInRange:range withString:string];

    if (result.length > 18) {
        if (error != nil) {
            NSString *description = NSLocalizedString(@"拼写检查错误", @"");
            NSString *reason = NSLocalizedString(@"大于18个字符", @"");
            NSArray *objArray = [NSArray arrayWithObjects:description, reason, nil];
            NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey, NSLocalizedFailureReasonErrorKey, nil];

            NSDictionary *userInfo = [NSDictionary dictionaryWithObjects:objArray forKeys:keyArray];
            *error = [NSError errorWithDomain:InputValidationErrorDomain code:1001 userInfo:userInfo];
        }
        return NO;
    }
    return YES;
}

@end
