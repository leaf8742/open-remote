    #import "GroupListStore.h"
#import "Model.h"
#import <AFNetworking/AFNetworking.h>

@implementation GroupListStore

- (void)requestWithSuccess:(void (^)())success failure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"token":[UserModel sharedInstance].token};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:[URLString stringByAppendingString:@"group/group_list"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSError *error = [BaseStore errorWithResponseObject:responseObject];
        if (error) {
            // 服务器返回失败，将失败信息反馈给上层调用者
            failure(error);
        } else {
            
            [[GroupListModel sharedInstance] willChangeValueForKey:@"groups"];
            // 服务器返回成功
            for (NSDictionary *groupItem in responseObject[@"groups"]) {
                GroupModel *group = [GroupListModel groupWithIdentity:groupItem[@"group_id"]];
                group.image = groupItem[@"group_image"];
                group.name = groupItem[@"group_title"];
                
                AuthorizationModel *authorization = [group currentAuthorization];
                if (authorization == nil) {
                    authorization = [[AuthorizationModel alloc] init];
                    authorization.user = [UserModel sharedInstance];
                    [group.authz addObject:authorization];
                }
                authorization.authorization = authorizationWithString(responseObject[@"authorization"]);
            }
            [[GroupListModel sharedInstance] didChangeValueForKey:@"groups"];
            success();
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 网络请求失败，将失败信息反馈给上层调用者
        failure(error);
    }];
}

@end
