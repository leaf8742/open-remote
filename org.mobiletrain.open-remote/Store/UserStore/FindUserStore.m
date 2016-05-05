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
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:[URLString stringByAppendingString:@"user/find_user"] parameters:parameters  progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error = [BaseStore errorWithResponseObject:responseObject];
        if (error) {
            failure(error);
        } else {
            [self.user mergeFromDictionary:responseObject useKeyMapping:YES error:nil];
            success();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

@end
