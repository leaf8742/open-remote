/**
 * @file
 * @author 单宝华
 * @date 2015-10-05
 */
#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>

@class UserModel;
@class AuthorizationModel;
@class DeviceModel;
@class MessageListModel;

/**
 * @class GroupModel
 * @brief 群组模型
 * @author 单宝华
 * @date 2015-10-05
 */
@interface GroupModel : JSONModel

/// @brief 群组唯一标识
@property (copy, nonatomic) NSString *identity;

/// @brief 群组名称
@property (copy, nonatomic) NSString *name;

/// @brief 群组图片
@property (copy, nonatomic) NSString *image;

/// @brief 群组二维码图片URL
@property (copy, nonatomic) NSString *QRCode;

/// @brief 设备列表
@property (strong, nonatomic) NSMutableArray *devices;

/// @brief 当前被选中的设备
@property (strong, nonatomic) DeviceModel *selectedDevice;

/// @brief 消息列表
@property (strong, nonatomic) MessageListModel<Optional> *messages;

/// @brief 权限列表
@property (strong, nonatomic) NSMutableArray *authz;

/// @brief 当前用户所对应的权限
- (AuthorizationModel *)currentAuthorization;

/// @brief 添加设备
- (void)insertDevie:(DeviceModel *)device;

@end
