#import "DisbandGroupStore.h"

@implementation DisbandGroupStore

- (void)requestWithSuccess:(void (^)())success failure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"token":[UserModel currentUser].token,
                                 @"group_id":self.group.identity};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:[URLString stringByAppendingString:@"group/disband_group"] parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *responseError = [BaseStore errorWithResponseObject:responseObject];
        if (responseError == nil) {
            [self.group.authz removeAllObjects];
            success();
        } else {
            failure(responseError);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

@end
