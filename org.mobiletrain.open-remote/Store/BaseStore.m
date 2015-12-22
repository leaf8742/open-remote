#import "BaseStore.h"
NSString *const ResponseErrorDomain = @"ResponseErrorDomain";
NSInteger const ResponseErrorCode = 1890;
NSString *const URLString = @"http://localhost:8080/";

@implementation BaseStore

- (void)requestWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure {
    
}

+ (NSError *)errorWithResponseObject:(NSDictionary *)responseObject {
    if ([responseObject[@"code"] integerValue] == 0) {
        return nil;
    } else {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey:responseObject[@"message"], NSLocalizedFailureReasonErrorKey:responseObject[@"message"]};
        NSError *error = [NSError errorWithDomain:ResponseErrorDomain code:ResponseErrorCode userInfo:userInfo];
        return error;
    }
}

@end
