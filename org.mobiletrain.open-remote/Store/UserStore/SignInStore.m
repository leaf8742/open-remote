#import "SignInStore.h"
#import "Model.h"
#import "NSString+MD5HexDigest.h"
#import <AFNetworking/AFNetworking.h>
#import <EaseMobSDKFull/EaseMob.h>
#import "NSString+UUIDHandle.h"

@implementation SignInStore

- (void)requestWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure {
    void (^successOnMainQueue)() = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            success();
        });
    };
    void (^failureOnMainQueue)(NSError *error) = ^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
    };
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block NSError *responseError = nil;
        __block EMError *emerror = nil;
        
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
        
        NSDictionary *parameters = @{@"account":self.account,
                                     @"passwd":[self.passwd md5HexDigest]};
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        [manager POST:[URLString stringByAppendingString:@"user/sign_in"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            responseError = [BaseStore errorWithResponseObject:responseObject];
            if (responseError == nil) {
                // 服务器返回成功，设置用户模型单例
                UserModel *user = [UserModel currentUser];
                user.mobile = responseObject[@"user_mobile"];
                user.email = responseObject[@"user_email"];
                user.alias = responseObject[@"user_title"];
                user.gender = responseObject[@"user_gender"];
                user.token = responseObject[@"user_token"];
                user.identity = responseObject[@"user_id"];
                user.headerImage = responseObject[@"user_image"];
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            // 网络请求失败，将失败信息反馈给上层调用者
            responseError = error;
            dispatch_semaphore_signal(semaphore);
        }];
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        if (responseError == nil) {
            [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:[[UserModel currentUser].identity withoutSeparator] password:[self.passwd md5HexDigest] completion:^(NSDictionary *loginInfo, EMError *error) {
                dispatch_semaphore_signal(semaphore);
                emerror = error;
            } onQueue:nil];
        } else {
            dispatch_semaphore_signal(semaphore);
        }
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_signal(semaphore);
        if (responseError != nil) {
            failureOnMainQueue(responseError);
        } else if (emerror != nil) {
            failureOnMainQueue([BaseStore transformEMError:emerror]);
        } else {
            successOnMainQueue();
        }
    });
}

@end
