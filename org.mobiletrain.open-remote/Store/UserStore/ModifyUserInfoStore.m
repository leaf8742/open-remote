#import "ModifyUserInfoStore.h"
#import "Model.h"
#import <AFNetworking/AFNetworking.h>

@implementation ModifyUserInfoStore

- (void)requestWithSuccess:(void (^)())success failure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"UserId":[UserModel sharedInstance].identity,
                                 @"PhoneNumber":self.mobile,
                                 @"EmailAddress":self.email,
                                 @"Alias":self.alias};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:@"http://42.96.208.2:8080/UserAction/UpdateUserInfoHandler.ashx" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSError *error = [BaseStore errorWithResponseObject:responseObject];
        if (error) {
            // 服务器返回失败，将失败信息反馈给上层调用者
            failure(error);
        } else {
            // 服务器返回成功
            UserModel *user = [UserModel sharedInstance];
            [user mergeFromDictionary:responseObject useKeyMapping:YES];
            success();
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 网络请求失败，将失败信息反馈给上层调用者
        failure(error);
    }];
}

@end