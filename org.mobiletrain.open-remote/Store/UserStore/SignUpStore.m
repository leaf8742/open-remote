#import "SignUpStore.h"
#import "Model.h"
#import "NSString+MD5HexDigest.h"
#import <AFNetworking/AFNetworking.h>
#import <EaseMobSDKFull/EaseMob.h>
#import "NSString+UUIDHandle.h"

@implementation SignUpStore

- (void)requestWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure {
    dispatch_group_t group = dispatch_group_create();
    __block NSError *responseError = nil;
    __block EMError *emerror = nil;

    NSString *identity = [NSUUID UUID].UUIDString;
    NSDictionary *parameters = @{@"identity":identity,
                                 @"image":@"default",
                                 @"mobile":self.mobile,
                                 @"email":self.email,
                                 @"title":self.alias,
                                 @"passwd":[self.passwd md5HexDigest],
                                 @"gender":stringWithGender(self.gender)};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    dispatch_group_enter(group);
    [manager POST:[URLString stringByAppendingString:@"user/sign_up"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
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
        dispatch_group_leave(group);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 网络请求失败，将失败信息反馈给上层调用者
        responseError = error;
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:[identity withoutSeparator] password:[self.passwd md5HexDigest] withCompletion:^(NSString *username, NSString *password, EMError *error) {
        emerror = error;
        dispatch_group_leave(group);
    } onQueue:nil];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (responseError != nil) {
            failure(responseError);
        } else if (emerror != nil) {
            failure([BaseStore transformEMError:emerror]);
        } else {
            success();
        }
    });
}

@end
