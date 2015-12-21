#import "GroupListStore.h"
#import "Model.h"
#import <AFNetworking/AFNetworking.h>

@implementation GroupListStore

- (void)requestWithSuccess:(void (^)())success failure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"UserId":[UserModel sharedInstance].identity};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[URLString stringByAppendingString:@"UserGroupAction/GetUserGroupHandler.ashx"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSError *error = [BaseStore errorWithResponseObject:responseObject];
        if (error) {
            // 服务器返回失败，将失败信息反馈给上层调用者
            failure(error);
        } else {
            // 服务器返回成功
            for (NSDictionary *groupItem in responseObject[@"Data"]) {
                GroupModel *group = [GroupListModel groupWithIdentity:groupItem[@"GroupId"]];
                AuthorizationModel *authorization = [group currentAuthorization];
                if (authorization == nil) {
                    authorization = [[AuthorizationModel alloc] init];
                    authorization.user = [UserModel sharedInstance];
                    [group.authz addObject:authorization];
                }
                authorization.primary = [groupItem[@"IsDefault"] boolValue];
                if (authorization.primary && [GroupListModel sharedInstance].selectedGroup == nil) {
                    [GroupListModel sharedInstance].selectedGroup = group;
                }
                authorization.authorization = [groupItem[@"UserPermission"] integerValue];
            }
            success();
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 网络请求失败，将失败信息反馈给上层调用者
        failure(error);
    }];
}

@end
