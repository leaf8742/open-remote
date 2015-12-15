#import "SignInStore.h"
#import "Model.h"
#import "NSString+MD5HexDigest.h"
#import <AFNetworking/AFNetworking.h>

@implementation SignInStore

- (void)requestWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure {
    NSDictionary *parameters = @{@"PhoneNumberOrEmail":self.account,
                                 @"Password":[self.passwd md5HexDigest]};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:@"http://42.96.208.2:8080/UserAction/UserLoginHandler.ashx" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSError *error = [BaseStore errorWithResponseObject:responseObject];
        if (error) {
            // 服务器返回失败，将失败信息反馈给上层调用者
            failure(error);
        } else {
            // 服务器返回成功，设置用户模型单例
            UserModel *user = [UserModel sharedInstance];
            [user mergeFromDictionary:responseObject useKeyMapping:YES];
            user.passwd = self.passwd;
            success();
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 网络请求失败，将失败信息反馈给上层调用者
        failure(error);
    }];
}

@end
