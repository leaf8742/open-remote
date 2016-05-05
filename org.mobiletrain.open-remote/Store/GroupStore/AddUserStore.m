#import "AddUserStore.h"
#import "Model.h"
#import <AFNetworking/AFNetworking.h>
#import <EaseMobSDKFull/EaseMob.h>
#import "NSString+UUIDHandle.h"

@implementation AddUserStore

- (void)requestWithSuccess:(void (^)())success failure:(void (^)(NSError *))failure {
    __block NSError *responseError = nil;
    __block EMError *emerror = nil;
    dispatch_group_t group_t = dispatch_group_create();
    
    dispatch_group_enter(group_t);
    [[EaseMob sharedInstance].chatManager asyncAddOccupants:@[[self.user.identity withoutSeparator]] toGroup:[self.group.identity withoutSeparator] welcomeMessage:@"邀请信息"  completion:^(NSArray *occupants, EMGroup *group, NSString *welcomeMessage, EMError *error) {
        emerror = error;
        dispatch_group_leave(group_t);
    } onQueue:nil];
    
    dispatch_group_enter(group_t);
    NSDictionary *parameters = @{@"token":[UserModel currentUser].token,
                                 @"user_id":self.user.identity,
                                 @"group_id":self.group.identity};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:[URLString stringByAppendingString:@"group/add_user"] parameters:parameters  progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        responseError = [BaseStore errorWithResponseObject:responseObject];
        if (responseError == nil) {
            AuthorizationModel *auth = [self.group authorizationWithUser:self.user];
            auth.authorization = kAuthorizationMember;
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
