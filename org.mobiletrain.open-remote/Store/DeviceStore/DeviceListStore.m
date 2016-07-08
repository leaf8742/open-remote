#import "DeviceListStore.h"

@implementation DeviceListStore

- (void)requestWithSuccess:(void (^)())success failure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"token":[UserModel currentUser].token,
                                 @"group_id":self.group.identity};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:[URLString stringByAppendingString:@"device/device_list"] parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSError *error = [BaseStore errorWithResponseObject:responseObject];
        if (error) {
            // 服务器返回失败，将失败信息反馈给上层调用者
            failure(error);
        } else {
            // 服务器返回成功
            for (NSDictionary *deviceItem in responseObject[@"devices"]) {
                NSDictionary *deviceItemWithoutNull = [BaseStore JSONObjectWithOutNull:deviceItem];
                NSData *jsonData = [deviceItemWithoutNull[@"prod_status"] dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *deviceStatus = nil;
                if (jsonData) {
                    deviceStatus = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                }
                DeviceModel *device = [DeviceModel deviceWithIdentity:deviceItemWithoutNull[@"prod_id"]];
                device.name = deviceItemWithoutNull[@"prod_title"];
                device.image = deviceItemWithoutNull[@"prod_image"];
                device.powerOn = [deviceStatus[@"power_on"] boolValue];
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
