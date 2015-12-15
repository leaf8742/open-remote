#import "EmailInputValidator.h"

@implementation EmailInputValidator

- (BOOL)validateInput:(UITextField *)input error:(NSError **)error {
    // 邮箱最少4位，且有@和.
    if (![EmailInputValidator validateEmail:input.text]) {
        if (error != nil) {
            NSString *description = NSLocalizedString(nil, @"");
            NSString *reason = NSLocalizedString(@"邮箱错误", @"");
            if (input.text.length == 0) {
                reason = NSLocalizedString(@"请输入邮箱", @"");
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
    NSString *result = [input.text stringByReplacingCharactersInRange:range withString:string];
    // 邮箱最多40字符
    if (result.length > 40) {
        if (error != nil) {
            NSString *description = NSLocalizedString(@"拼写检查错误", @"");
            NSString *reason = NSLocalizedString(@"大于40", @"");
            NSArray *objArray = [NSArray arrayWithObjects:description, reason, nil];
            NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey, NSLocalizedFailureReasonErrorKey, nil];

            NSDictionary *userInfo = [NSDictionary dictionaryWithObjects:objArray forKeys:keyArray];
            *error = [NSError errorWithDomain:InputValidationErrorDomain code:1001 userInfo:userInfo];
        }
        return NO;
    }
    return YES;
}

+ (BOOL)validateEmail:(NSString*)email {
    if (!email) return NO;
    // 正则表达式限制(string@string.string)[a-z0-9A-Z-_.]+
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[a-z0-9A-Z-_.]+@[a-z0-9A-Z-_]+\\.[a-zA-Z]+$" options:NSRegularExpressionAnchorsMatchLines error:nil];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:email options:NSMatchingAnchored range:NSMakeRange(0, email.length)];
    return numberOfMatches != 0;
}

@end
