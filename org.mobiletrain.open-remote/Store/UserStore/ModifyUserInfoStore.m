#import "ModifyUserInfoStore.h"
#import "Model.h"
#import <AFNetworking/AFNetworking.h>

@implementation ModifyUserInfoStore

- (void)requestWithSuccess:(void (^)())success failure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{
                                 @"UserId":[UserModel currentUser].identity,
                                 @"PhoneNumber":self.mobile,
                                 @"EmailAddress":self.email,
                                 @"Alias":self.alias};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:[URLString stringByAppendingString:@"UserAction/UpdateUserInfoHandler.ashx"] parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSError *error = [BaseStore errorWithResponseObject:responseObject];
        if (error) {
            // 服务器返回失败，将失败信息反馈给上层调用者
            failure(error);
        } else {
            // 服务器返回成功
            UserModel *user = [UserModel currentUser];
//            [user mergeFromDictionary:responseObject useKeyMapping:YES error:nil];
            success();
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 网络请求失败，将失败信息反馈给上层调用者
        failure(error);
    }];
}

@end
