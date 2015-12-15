//
//  SendMessageStore.m
//  org.mobiletrain.open-remote
//
//  Created by qianfeng on 15/10/15.
//
//

#import "SendMessageStore.h"
#import "Model.h"
#import <AFNetworking/AFNetworking.h>

@implementation SendMessageStore
- (void)requestWithSuccess:(void (^)())success failure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"GroupId":_groupId,@"UserId":_userId,@"messageType":_messageType,@"messageContent":_messageContent};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:@"http://42.96.208.2:8080/GroupMessageAction/SendMessageHandler.ashx" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSError *error = [BaseStore errorWithResponseObject:responseObject];
        if (error) {
            // 服务器返回失败，将失败信息反馈给上层调用者
            failure(error);
        } else {
            // 服务器返回成功
            
            success();
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 网络请求失败，将失败信息反馈给上层调用者
        failure(error);
    }];
}

@end
