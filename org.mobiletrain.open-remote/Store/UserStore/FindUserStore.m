#import "FindUserStore.h"
#import <AFNetworking/AFNetworking.h>
#import "Model.h"

@implementation FindUserStore

- (void)requestWithSuccess:(void (^)())success failure:(void (^)(NSError *))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[UserModel currentUser].token forKey:@"token"];
    if (self.user.mobile && ![self.user.mobile isEqualToString:@""]) {
        [parameters setValue:self.user.mobile forKey:@"mobile"];
    }
    if (self.user.email && ![self.user.email isEqualToString:@""]) {
        [parameters setValue:self.user.email forKey:@"email"];
    }
    if (self.user.identity && ![self.user.identity isEqualToString:@""]) {
        [parameters setValue:self.user.identity forKey:@"identity"];
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:[URLString stringByAppendingString:@"user/find_user"] parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error = [BaseStore errorWithResponseObject:responseObject];
        if (error) {
            failure(error);
        } else {
#warning 极有可能会出错！！！
            self.user.identity = responseObject[@"user_id"];
            self.user.mobile = responseObject[@"user_mobile"];
            self.user.email = responseObject[@"user_email"];
            self.user.alias = responseObject[@"user_title"];
            self.user.gender = responseObject[@"user_gender"];
            self.user.token = responseObject[@"user_token"];
            self.user.headerImage = responseObject[@"user_image"];

            success();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

@end
