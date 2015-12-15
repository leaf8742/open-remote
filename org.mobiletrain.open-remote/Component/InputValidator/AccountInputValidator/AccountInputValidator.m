#import "AccountInputValidator.h"
#import "MobileInputValidator.h"
#import "EmailInputValidator.h"

@implementation AccountInputValidator

- (BOOL)validateInput:(UITextField *)input error:(NSError **)error {
    BOOL result = YES;
    // 手机格式和e-mail格式都不满足，返回错误信息
    if (![MobileInputValidator validateMobile:input.text] && ![EmailInputValidator validateEmail:input.text]) {
        if (error != nil) {
            NSString *description = NSLocalizedString(nil, @"");
            NSString *reason = NSLocalizedString(@"邮箱或者手机号码不正确", @"");
            if (input.text.length == 0) {
                reason = NSLocalizedString(@"请输入邮箱或手机号码", @"");
            }
            NSArray *objArray = [NSArray arrayWithObjects:description, reason, nil];
            NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey, NSLocalizedFailureReasonErrorKey, nil];
            
            NSDictionary *userInfo = [NSDictionary dictionaryWithObjects:objArray forKeys:keyArray];
            *error = [NSError errorWithDomain:InputValidationErrorDomain code:1001 userInfo:userInfo];
        }
        result = NO;
    }
    return result;
}

- (BOOL)validateInput:(UITextField *)input shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string error:(NSError **)error {
    // @brief 手机格式和e-mail只要满足一个即可
    MobileInputValidator *mobileValidator = [[MobileInputValidator alloc] init];
    EmailInputValidator *emailValidator = [[EmailInputValidator alloc] init];
    BOOL result = [mobileValidator validateInput:input shouldChangeCharactersInRange:range replacementString:string error:error] ||
                  [emailValidator validateInput:input shouldChangeCharactersInRange:range replacementString:string error:error];
    return result;
}

// 获取根据什么帐户类型登录的
//+ (kAccountType)getAccountType:(NSString *)account {
//    kAccountType result;
//	if ([MobileInputValidator validateMobile:account]) {
//        result = kAccountTypeMobile;
//    } else {
//        result = kAccountTypeEmail;
//    }
//    return result;
//}

@end
