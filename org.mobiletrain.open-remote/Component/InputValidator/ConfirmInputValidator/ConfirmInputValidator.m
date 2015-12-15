#import "ConfirmInputValidator.h"

@implementation ConfirmInputValidator

- (BOOL)validateInput:(UITextField*)input error:(NSError**)error {
    // 只要满足和password的字符串相等即可
    if (![input.text isEqualToString:_password.text]) {
        if (error != nil) {
            NSString *description = NSLocalizedString(nil, @"");
            NSString *reason = NSLocalizedString(@"密码和确认密码不一致", @"");
            if ([input.text length] == 0) {
                reason = NSLocalizedString(@"请输入确认密码", @"");
            }
            NSArray *objArray = [NSArray arrayWithObjects:description, reason, nil];
            NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey, NSLocalizedFailureReasonErrorKey, nil];

            NSDictionary *userInfo = [NSDictionary dictionaryWithObjects:objArray forKeys:keyArray];
            *error = [NSError errorWithDomain:InputValidationErrorDomain code:1001 userInfo:userInfo];
        }
        return NO;
    }
    return YES;
}

- (BOOL)validateInput:(UITextField *)input shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string error:(NSError **)error {
    // 最多18字符
    NSString *result = [input.text stringByReplacingCharactersInRange:range withString:string];
    
    if (result.length > 18) {
        if (error != nil) {
            NSString *description = NSLocalizedString(nil, @"");
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
