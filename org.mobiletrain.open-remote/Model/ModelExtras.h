/**
 * @file
 * @author 单宝华
 * @date 2015-12-21
 */
#import <Foundation/Foundation.h>
#import "Model.h"

/**
 * @function genderWithString
 * @brief 根据性别字符串确定性别枚举
 */
extern kGender genderWithString(NSString *string);

/**
 * @function stringWithGender
 * @brief 根据性别枚举确定性别字符串
 */
extern NSString *stringWithGender(kGender gender);

/**
 * @function authorizationWithString
 * @brief 根据权限字符串确定权限枚举
 */
extern kAuthorization authorizationWithString(NSString *string);

/**
 * @function stringWithAuthorization
 * @brief 根据权限枚举确定权限字符串
 */
extern NSString *stringWithAuthorization(kAuthorization authorization);