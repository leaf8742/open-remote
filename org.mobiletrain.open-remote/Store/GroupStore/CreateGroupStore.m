#import "CreateGroupStore.h"

@implementation CreateGroupStore

- (void)requestWithSuccess:(void (^)())success failure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"token":[UserModel currentUser].token};

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:[URLString stringByAppendingString:@"group/create_group"] parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *responseError = [BaseStore errorWithResponseObject:responseObject];
        if (responseError == nil) {
            GroupModel *group = [GroupModel groupWithIdentity:responseObject[@"group_id"]];
            AuthorizationModel *auth = [group currentAuthorization];
            auth.authorization = kAuthorizationAdministrator;
            success();
        } else {
            failure(responseError);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

@end
