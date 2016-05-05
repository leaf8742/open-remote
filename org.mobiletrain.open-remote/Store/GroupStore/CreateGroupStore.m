#import "CreateGroupStore.h"
#import "Model.h"
#import <AFNetworking/AFNetworking.h>
#import <EaseMobSDKFull/EaseMob.h>

@implementation CreateGroupStore

- (void)requestWithSuccess:(void (^)())success failure:(void (^)(NSError *))failure {
    void(^successOnMainQueue)() = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            success();
        });
    };
    void(^failureOnMainQueue)(NSError *error) = ^(NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
    };
    __block NSError *responseError = nil;
    __block EMError *emerror = nil;
    __block EMGroup *createdGroup = nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        EMGroupStyleSetting *groupStyleSetting = [[EMGroupStyleSetting alloc] init];
        groupStyleSetting.groupMaxUsersCount = 100;
        groupStyleSetting.groupStyle = eGroupStyle_PrivateMemberCanInvite;
        [[EaseMob sharedInstance].chatManager asyncCreateGroupWithSubject:@""
                                                              description:@""
                                                                 invitees:@[]
                                                    initialWelcomeMessage:@""
                                                             styleSetting:groupStyleSetting
                                                               completion:^(EMGroup *group, EMError *error) {
                                                                   createdGroup = group;
                                                                   emerror = error;
                                                                   dispatch_semaphore_signal(semaphore);
                                                               } onQueue:nil];
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSDictionary *parameters = @{@"token":[UserModel currentUser].token,
                                     @"group_id":createdGroup.groupId};
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager POST:[URLString stringByAppendingString:@"group/create_group"] parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            responseError = [BaseStore errorWithResponseObject:responseObject];
            if (responseError == nil) {
                GroupModel *group = [GroupModel groupWithIdentity:createdGroup.groupId];
                AuthorizationModel *auth = [group currentAuthorization];
                auth.authorization = kAuthorizationAdministrator;
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            responseError = error;
            dispatch_semaphore_signal(semaphore);
        }];
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_signal(semaphore);
        if (responseError) {
            failureOnMainQueue(responseError);
        } else if (emerror) {
            failureOnMainQueue([BaseStore transformEMError:emerror]);
        } else {
            successOnMainQueue();
        }
    });
}

@end
