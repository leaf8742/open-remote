/**
 * @file
 * @author 单宝华
 * @date 2015-10-09
 */
#import <Foundation/Foundation.h>

/**
 * @class PersistentManager
 * @brief 数据库存取类
 * @author 单宝华
 * @date 2015-10-09
 */
@interface PersistentManager : NSObject

/// @brief 单例
+ (instancetype)sharedInstance;

/// @brief 持久化存储
+ (void)persist;

/// @brief 读取
+ (void)serialize;

@end
