#import "QuitGroupStore.h"
#import "Model.h"
#import <AFNetworking/AFNetworking.h>
#import <EaseMobSDKFull/EaseMob.h>
#import "NSString+UUIDHandle.h"

@implementation QuitGroupStore

- (void)requestWithSuccess:(void (^)())success failure:(void (^)(NSError *))failure {
    __block NSError *responseError = nil;
    __block EMError *emerror = nil;
    dispatch_group_t group_t = dispatch_group_create();
    
    dispatch_group_enter(group_t);
    [[EaseMob sharedInstance].chatManager asyncLeaveGroup:[self.group.identity withoutSeparator]
                                               completion:
     ^(EMGroup *group, EMGroupLeaveReason reason, EMError *error) {
         emerror = error;
         dispatch_group_leave(group_t);
     } onQueue:nil];

    
    dispatch_group_enter(group_t);
    NSDictionary *parameters = @{@"token":[UserModel currentUser].token,
                                 @"group_id":self.group.identity};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:[URLString stringByAppendingString:@"group/quit_group"] parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        responseError = [BaseStore errorWithResponseObject:responseObject];
        if (responseError == nil) {
            AuthorizationModel *auth = [self.group currentAuthorization];
            [self.group.authz removeObject:auth];
        }
        dispatch_group_leave(group_t);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        responseError = error;
        dispatch_group_leave(group_t);
    }];
    
    dispatch_group_notify(group_t, dispatch_get_main_queue(), ^{
        if (responseError) {
            failure(responseError);
        } else if (emerror) {
            failure([BaseStore transformEMError:emerror]);
        } else {
            success();
        }
    });
}

@end
