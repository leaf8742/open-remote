//
//  SendMessageStore.h
//  org.mobiletrain.open-remote
//
//  Created by qianfeng on 15/10/15.
//
//

#import <Foundation/Foundation.h>
#import "BaseStore.h"

@interface SendMessageStore : BaseStore

@property (strong, nonatomic) NSString *groupId;
@property (strong, nonatomic) NSNumber *userId;
@property (strong, nonatomic) NSString *messageType;
@property (strong, nonatomic) NSString *messageContent;

@end
