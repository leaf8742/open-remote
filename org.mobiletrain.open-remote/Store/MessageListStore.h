//
//  MessageListStore.h
//  org.mobiletrain.open-remote
//
//  Created by qianfeng on 15/10/14.
//
//

#import <Foundation/Foundation.h>
#import "BaseStore.h"

@interface MessageListStore : BaseStore

@property (strong, nonatomic) NSString *groupId;
@property (strong, nonatomic) NSNumber *page;

@end
