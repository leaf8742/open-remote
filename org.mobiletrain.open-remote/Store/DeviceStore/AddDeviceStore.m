#import "AddDeviceStore.h"
#import "DeviceModel.h"
#import "GroupModel.h"
#import "UserModel.h"
#import <AFNetworking/AFNetworking.h>

@implementation AddDeviceStore

- (void)requestWithSuccess:(void (^)())success failure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"group_id":self.group.identity,
                                 @"token":[UserModel sharedInstance].token,
                                 @"device_id":self.device.identity};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:[URLString stringByAppendingString:@"device/add_device"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSError *error = [BaseStore errorWithResponseObject:responseObject];
        if (error) {
            // 服务器返回失败，将失败信息反馈给上层调用者
            failure(error);
        } else {
            
            // 服务器返回成功
            [[self.group mutableArrayValueForKey:@"devices"] addObject:self.device];
//            for (NSDictionary *deviceItem in responseObject[@"Data"]) {
//                DeviceModel *device = [DeviceModel deviceWithIdentity:deviceItem[@"DeviceId"]];
//                [device mergeFromDictionary:deviceItem useKeyMapping:YES];
//                [self.group insertDevie:device];
//            }
            
            success();
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 网络请求失败，将失败信息反馈给上层调用者
        failure(error);
    }];
}

@end
