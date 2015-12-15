//
//  MessageListStore.m
//  org.mobiletrain.open-remote
//
//  Created by qianfeng on 15/10/14.
//
//

#import "MessageListStore.h"
#import "Model.h"
#import <AFNetworking/AFNetworking.h>

@implementation MessageListStore

- (void)requestWithSuccess:(void (^)())success failure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"GroupId":_groupId,@"page":_page};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:@"http://42.96.208.2:8080/GroupMessageAction/GetGroupMessageHandler.ashx" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSError *error = [BaseStore errorWithResponseObject:responseObject];
        if (error) {
            // 服务器返回失败，将失败信息反馈给上层调用者
            failure(error);
        } else {
            // 服务器返回成功
            
            MessageListModel *messageList = [[MessageListModel alloc] initWithDictionary:responseObject[@"Data"] error:nil];
            
//            NSDictionary *data = responseObject[@"Data"];
//            
//            messageList.nextPage = [data[@"NextPage"] intValue];
//            messageList.timeStamp = data[@"TimeStamp"];
//            for (NSDictionary *item in responseObject[@"MessageData"]) {
//                
//                MessageModel *message = [[MessageModel alloc] initWithDictionary:item error:nil];
//                
//            }
            GroupModel *group = [GroupListModel groupWithIdentity:_groupId];
            group.messages = messageList;
            success();
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 网络请求失败，将失败信息反馈给上层调用者
        failure(error);
    }];
}

@end
