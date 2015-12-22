#import "SignUpStore.h"
#import "Model.h"
#import "NSString+MD5HexDigest.h"
#import <AFNetworking/AFNetworking.h>

@implementation SignUpStore

- (void)requestWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure {
    NSDictionary *parameters = @{@"identity":[NSUUID UUID].UUIDString,
                                 @"image":@"default",
                                 @"mobile":self.mobile,
                                 @"email":self.email,
                                 @"title":self.alias,
                                 @"passwd":[self.passwd md5HexDigest],
                                 @"gender":stringWithGender(self.gender)};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:[URLString stringByAppendingString:@"user/sign_up"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSError *error = [BaseStore errorWithResponseObject:responseObject];
        if (error) {
            // 服务器返回失败，将失败信息反馈给上层调用者
            failure(error);
        } else {
            // 服务器返回成功，设置用户模型单例
            UserModel *user = [UserModel sharedInstance];
            user.mobile = responseObject[@"user_mobile"];
            user.email = responseObject[@"user_email"];
            user.alias = responseObject[@"user_title"];
            user.gender = responseObject[@"user_gender"];
            user.token = responseObject[@"user_token"];
            user.identity = responseObject[@"user_id"];
            user.headerImage = responseObject[@"user_image"];
            success();
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 网络请求失败，将失败信息反馈给上层调用者
        failure(error);
    }];
}

@end
