#import "DeviceOperationStore.h"

@implementation DeviceOperationStore

- (void)requestWithSuccess:(void (^)())success failure:(void (^)(NSError *))failure {
    NSString *boolString = self.powerOn ? @"true" : @"false";
    
    NSDictionary *parameters = @{@"token":[UserModel currentUser].token,
                                 @"device_id":self.device.identity,
                                 @"device_status": [NSString stringWithFormat:@"{\"power_on\":%@}", boolString], };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:[URLString stringByAppendingString:@"device/device_operation"] parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSError *error = [BaseStore errorWithResponseObject:responseObject];
        if (error) {
            // 服务器返回失败，将失败信息反馈给上层调用者
            failure(error);
        } else {
            self.device.powerOn = self.powerOn;
            success();
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 网络请求失败，将失败信息反馈给上层调用者
        failure(error);
    }];
}

@end
