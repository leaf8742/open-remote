/**
 * @file
 * @author 单宝华
 * @date 2015-10-11
 */
#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>

@class UserModel;
@class GroupModel;
@class EMGroup;

/**
 * @class GroupListModel
 * @brief 群组列表模型
 * @author 单宝华
 * @date 2015-10-11
 */
@interface GroupListModel : JSONModel

/**
 * @brief 查找指定用户的群组
 * @param user 要指定查找哪一个用户
 * @return 用户的群组列表
 */
+ (NSMutableArray *)groupsWithUser:(UserModel *)user;

/**
 * @brief 根据群组唯一标识查找群组
 * @param identity 群组唯一标识
 * @return 如果查找到，直接返回;如果查找不到，创建一个返回
 */
+ (GroupModel *)groupWithIdentity:(NSString *)identity;

/// @brief 单例
+ (instancetype)sharedInstance;

/// @brief 当前被选中的group
@property (strong, nonatomic) GroupModel *selectedGroup;

@end
