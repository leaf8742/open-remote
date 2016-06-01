#import "UserListStore.h"

@implementation UserListStore

- (void)requestWithSuccess:(void (^)())success failure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"token":[UserModel currentUser].token,
                                 @"group_id":self.group.identity};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:[URLString stringByAppendingString:@"group/user_list"] parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error = [BaseStore errorWithResponseObject:responseObject];
        if (error) {
            failure(error);
        } else {
            for (NSDictionary *userItem in responseObject[@"users"]) {
                UserModel *user = [UserModel userWithIdentity:userItem[@"user_id"]];
                user.mobile = responseObject[@"user_mobile"];
                user.email = responseObject[@"user_email"];
                user.alias = responseObject[@"user_title"];
                user.gender = responseObject[@"user_gender"];
                user.token = responseObject[@"user_token"];
                user.headerImage = responseObject[@"user_image"];
                
                AuthorizationModel *auth = [self.group authorizationWithUser:user];
                auth.authorization = authorizationWithString(userItem[@"authorization"]);
            }
            success();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

@end
