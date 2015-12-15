#import "BaseStore.h"
NSString *const ResponseErrorDomain = @"ResponseErrorDomain";
NSInteger const ResponseErrorCode = 1890;

@implementation BaseStore

- (void)requestWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure {
    
}

+ (NSError *)errorWithResponseObject:(NSDictionary *)responseObject {
    if ([responseObject[@"ResultCode"] integerValue] == 0) {
        return nil;
    } else {
//        NSString *description = NSLocalizedString(@"", @"");
//        NSString *reason = NSLocalizedString(@"", @"");
//        NSArray *objArray = [NSArray arrayWithObjects:description, reason, nil];
//        NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey, NSLocalizedFailureReasonErrorKey, nil];
//
//        NSDictionary *userInfo = [NSDictionary dictionaryWithObjects:objArray forKeys:keyArray];
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey:responseObject[@"Message"], NSLocalizedFailureReasonErrorKey:responseObject[@"Message"]};
        NSError *error = [NSError errorWithDomain:ResponseErrorDomain code:ResponseErrorCode userInfo:userInfo];
        return error;
    }
}

@end
