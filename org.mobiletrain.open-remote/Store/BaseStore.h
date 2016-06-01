/**
 * @file
 * @author 单宝华
 * @date 2015-10-05
 */
#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "Model.h"

@class EMError;

/// @brief 网络组件请求成功，但服务器返回失败
FOUNDATION_EXPORT NSString *const ResponseErrorDomain;
FOUNDATION_EXPORT NSInteger const ResponseErrorCode;
FOUNDATION_EXPORT NSString *const URLString;

/**
 * @class BaseStore
 * @brief 网络组件
 * @author 单宝华
 * @date 2015-10-05
 */
@interface BaseStore : NSObject

/// @brief 设置好属性之后，开始网络请求
/// @param success 网络请求成功block
/// @param failure 网络请求失败block
- (void)requestWithSuccess:(void (^)(/*NSDictionary *responseInfo*/))success failure:(void (^)(NSError *error))failure;

/// @brief 根据网络返回，判断是否有服务器失败
/// @param responseObject 网络返回对象
/// @return 如果有错误，创建NSError返回；如果没有错误，返回nil
+ (NSError *)errorWithResponseObject:(NSDictionary *)responseObject;

+ (NSDictionary *)dictWithoutNull:(NSDictionary *)dict;

+ (NSError *)transformEMError:(EMError *)error;

@end
