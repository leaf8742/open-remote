#import "ModifyDeviceNameStore.h"
#import <AFNetworking/AFNetworking.h>
#import "Model.h"

@implementation ModifyDeviceNameStore

- (void)requestWithSuccess:(void (^)())success failure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"DeviceId":self.device.identity,
                                 @"DeviceName":self.name};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:@"http://42.96.208.2:8080/DeviceAction/UpdateDeviceNameHandler.ashx" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSError *error = [BaseStore errorWithResponseObject:responseObject];
        if (error) {
            // 服务器返回失败，将失败信息反馈给上层调用者
            failure(error);
        } else {
            self.device.name = self.name;
            success();
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 网络请求失败，将失败信息反馈给上层调用者
        failure(error);
    }];
}

@end
