#import "MobileInputValidator.h"

@implementation MobileInputValidator

- (BOOL)validateInput:(UITextField *)input error:(NSError **)error {
    if (![MobileInputValidator validateMobile:input.text]) {
        if (error != nil) {
            NSString *description = NSLocalizedString(nil, @"");
            NSString *reason = NSLocalizedString(@"请正确填写手机号", @"");
            if ([input.text length] == 0) {
                reason = NSLocalizedString(@"请输入手机号码", @"");
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
    // 字数限制
    if (result.length > 11) {
        if (error != nil) {
            NSString *description = NSLocalizedString(@"手机号码错误", @"");
            NSString *reason = NSLocalizedString(@"手机号码错误，请重新填写", @"");
            NSArray *objArray = [NSArray arrayWithObjects:description, reason, nil];
            NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey, NSLocalizedFailureReasonErrorKey, nil];

            NSDictionary *userInfo = [NSDictionary dictionaryWithObjects:objArray forKeys:keyArray];
            *error = [NSError errorWithDomain:InputValidationErrorDomain code:1001 userInfo:userInfo];
        }
        return NO;
    }
    return YES;
}

+ (BOOL)validateMobile:(NSString *)mobile {
    if (!mobile) return NO;
    // 正则表达式限制(11位纯数字)
    NSString *regexString = @"1[3578][0-9]{9}$";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString options:NSRegularExpressionAnchorsMatchLines error:nil];
    NSArray *matches = [regex matchesInString:mobile options:NSMatchingAnchored range:NSMakeRange(0, [mobile length])];
    return [matches count] != 0;
}

@end
