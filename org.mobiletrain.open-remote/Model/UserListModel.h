/**
 * @file
 * @author 单宝华
 * @date 2016-05-04
 */
#import <Foundation/Foundation.h>
@class UserModel;

/**
 * @class UserListModel
 * @brief 用户列表模型
 * @author 单宝华
 * @date 2016-05-04
 */
@interface UserListModel : NSObject

/**
 * @brief 根据用户手机号码查找用户
 * @param mobile 要查找的用户手机号码
 * @return 如果查找到，直接返回;如果查找不到，创建一个返回
 */
+ (UserModel *)userWithMobile:(NSString *)mobile;

/**
 * @brief 根据用户邮箱查找用户
 * @param mobile 要查找的用户邮箱
 * @return 如果查找到，直接返回;如果查找不到，创建一个返回
 */
+ (UserModel *)userWithEmail:(NSString *)email;

/**
 * @brief 根据用户身份唯一标识查找用户
 * @param mobile 要查找的用户身份唯一标识
 * @return 如果查找到，直接返回;如果查找不到，创建一个返回
 */
+ (UserModel *)userWithIdentity:(NSString *)identity;

@end
