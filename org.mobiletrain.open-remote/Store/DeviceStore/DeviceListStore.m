#import "DeviceListStore.h"
#import <AFNetworking/AFNetworking.h>
#import "DeviceModel.h"
#import "GroupModel.h"

@implementation DeviceListStore

- (void)requestWithSuccess:(void (^)())success failure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"GroupId":self.group.identity};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[URLString stringByAppendingString:@"DeviceAction/GetGroupDeviceHandler.ashx"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSError *error = [BaseStore errorWithResponseObject:responseObject];
        if (error) {
            // 服务器返回失败，将失败信息反馈给上层调用者
            failure(error);
        } else {
            // 服务器返回成功
            for (NSDictionary *deviceItem in responseObject[@"Data"]) {
                DeviceModel *device = [DeviceModel deviceWithIdentity:deviceItem[@"DeviceId"]];
                [device mergeFromDictionary:deviceItem useKeyMapping:YES];
                [self.group insertDevie:device];
            }
            
            success();
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 网络请求失败，将失败信息反馈给上层调用者
        failure(error);
    }];
}

@end
