#import "QuitGroupStore.h"

@implementation QuitGroupStore

- (void)requestWithSuccess:(void (^)())success failure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"token":[UserModel currentUser].token,
                                 @"group_id":self.group.identity};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:[URLString stringByAppendingString:@"group/quit_group"] parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *responseError = [BaseStore errorWithResponseObject:responseObject];
        if (responseError == nil) {
            AuthorizationModel *auth = [self.group currentAuthorization];
            [self.group.authz removeObject:auth];
            success();
        } else {
            failure(responseError);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

@end
