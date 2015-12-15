#import "GetUserInfoStore.h"
#import "Model.h"
#import <AFNetworking/AFNetworking.h>

@implementation GetUserInfoStore

- (void)requestWithSuccess:(void (^)())success failure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"UserId":self.userId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:@"http://42.96.208.2:8080/UserAction/GetUserInfoHandler.ashx" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSError *error = [BaseStore errorWithResponseObject:responseObject];
        if (error) {
            // 服务器返回失败，将失败信息反馈给上层调用者
            failure(error);
        } else {
            // 服务器返回成功
            UserModel *user = [UserModel userWithIdentity:self.userId];
            [user mergeFromDictionary:responseObject useKeyMapping:YES];
            success();
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 网络请求失败，将失败信息反馈给上层调用者
        failure(error);
    }];
}

@end
