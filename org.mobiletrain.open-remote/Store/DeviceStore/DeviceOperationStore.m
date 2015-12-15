#import "DeviceOperationStore.h"
#import <AFNetworking/AFNetworking.h>
#import "Model.h"

@implementation DeviceOperationStore

- (void)requestWithSuccess:(void (^)())success failure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"DeviceId":self.device.identity,
                                 @"DeviceState":self.powerOn ? @1 : @0,
                                 @"DeviceData":@""};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:@"http://42.96.208.2:8080/DeviceAction/UpdateDeviceStateHandler.ashx" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
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
