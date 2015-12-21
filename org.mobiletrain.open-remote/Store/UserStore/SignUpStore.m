#import "SignUpStore.h"
#import "Model.h"
#import "NSString+MD5HexDigest.h"
#import <AFNetworking/AFNetworking.h>

@implementation SignUpStore

- (void)requestWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure {
    NSDictionary *parameters = @{@"PhoneNumber":self.mobile,
                                 @"EmailAddress":self.email,
                                 @"Alias":self.alias,
                                 @"Password":[self.passwd md5HexDigest],
                                 @"Gender":[NSNumber numberWithInteger:self.gender]};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[URLString stringByAppendingString:@"UserAction/RegistUserHandler.ashx"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
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
