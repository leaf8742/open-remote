/**
 * @file
 * @author 单宝华
 * @date 2015-10-05
 */
#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>

@class UserModel;

/**
 * @enum kAuthorization
 * @brief 用户对于群组的权限
 * @author 单宝华
 * @date 2015-10-05
 */
typedef NS_ENUM(NSInteger, kAuthorization) {
    /// @brief 超级管理员
    kAuthorizationSuper,
    
    /// @brief 普通管理员
    kAuthorizationAdministrator,
    
    /// @brief 普通用户
    kAuthorizationMember,
};

/**
 * @class AuthorizationModel
 * @brief 权限模型
 * @author 单宝华
 * @date 2015-10-05
 */
@interface AuthorizationModel : JSONModel

/// @brief 用户
@property (copy, nonatomic) UserModel *user;

/// @brief 用户权限
@property (assign, nonatomic) kAuthorization authorization;

/// @brief 是否是默认群组
@property (assign, nonatomic) BOOL primary;

@end
