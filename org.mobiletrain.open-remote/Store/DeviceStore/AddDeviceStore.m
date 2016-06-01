#import "AddDeviceStore.h"

@implementation AddDeviceStore

- (void)requestWithSuccess:(void (^)())success failure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"group_id":self.group.identity,
                                 @"token":[UserModel currentUser].token,
                                 @"device_id":self.device.identity};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:[URLString stringByAppendingString:@"device/add_device"] parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSError *error = [BaseStore errorWithResponseObject:responseObject];
        if (error) {
            // 服务器返回失败，将失败信息反馈给上层调用者
            failure(error);
        } else {
            // 服务器返回成功
            [self.group insertDevie:self.device];
            success();
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 网络请求失败，将失败信息反馈给上层调用者
        failure(error);
    }];
}

@end
