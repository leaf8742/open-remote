/**
 * @file
 * @author 单宝华
 * @date 2015-10-05
 */
#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>

/**
 * @enum kGender
 * @brief 用户性别
 * @author 单宝华
 * @date 2015-10-10
 */
typedef NS_ENUM(NSInteger, kGender) {
    /// @brief 男性
    kGenderMale,
    
    /// @brief 女性
    kGenderFemale,
    
    /// @brief 未知
    kGenderUnknown,
};

/**
 * @class UserModel
 * @brief 用户模型
 * @author 单宝华 
 * @date 2015-10-05
 */
@interface UserModel : JSONModel

/// @brief 用户手机
@property (copy, nonatomic) NSString *mobile;

/// @brief 用户邮箱
@property (copy, nonatomic) NSString *email;

/// @brief 用户昵称
@property (copy, nonatomic) NSString *alias;

/// @brief 用户密码
@property (copy, nonatomic) NSString<Optional> *passwd;

/// @brief 用户性别(male/female)
@property (copy, nonatomic) NSString<Optional> *gender;

/// @brief 用户登录唯一标识
@property (copy, nonatomic) NSString<Optional> *token;

/// @brief 用户身份唯一标识
@property (copy, nonatomic) NSString *identity;

/// @brief 用户头像
@property (copy, nonatomic) NSString *headerImage;

/// @brief 用户名片二维码
@property (copy, nonatomic) NSString *QRCode;

/// @brief 当前用户
+ (instancetype)currentUser;

/**
 * @brief 根据用户手机号码查找用户
 * @param mobile 要查找的用户手机号码
 * @return 如果查找到，直接返回;如果查找不到，创建一个返回
 */
+ (instancetype)userWithMobile:(NSString *)mobile;

/**
 * @brief 根据用户邮箱查找用户
 * @param mobile 要查找的用户邮箱
 * @return 如果查找到，直接返回;如果查找不到，创建一个返回
 */
+ (instancetype)userWithEmail:(NSString *)email;

/**
 * @brief 根据用户身份唯一标识查找用户
 * @param mobile 要查找的用户身份唯一标识
 * @return 如果查找到，直接返回;如果查找不到，创建一个返回
 */
+ (instancetype)userWithIdentity:(NSString *)identity;

@end
