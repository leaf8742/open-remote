#import "BaseStore.h"
#import <EaseMobSDKFull/EaseMob.h>

NSString *const ResponseErrorDomain = @"ResponseErrorDomain";
NSInteger const ResponseErrorCode = 1890;
NSString *const URLString = @"http://112.74.198.103:8080/";

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

+ (NSDictionary *)dictWithoutNull:(NSDictionary *)dict {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:dict];
    NSMutableArray *removedKeys = [NSMutableArray array];
    for (id item in result) {
        if ([result[item] isKindOfClass:[NSNull class]]) {
            [removedKeys addObject:item];
        }
    }
    [result removeObjectsForKeys:removedKeys];
    return [result copy];
}

+ (NSError *)transformEMError:(EMError *)emerror {
    NSDictionary *errorUserInfo = @{NSLocalizedDescriptionKey:emerror.description, NSLocalizedFailureReasonErrorKey:emerror.description};
    
    NSError *error = [NSError errorWithDomain:@"环信出的错" code:emerror.errorCode userInfo:errorUserInfo];
    
    return error;
}

@end
