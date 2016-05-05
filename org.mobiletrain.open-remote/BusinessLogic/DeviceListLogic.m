#import "DeviceListLogic.h"
#import "GroupListStore.h"
#import "DeviceListStore.h"

#import "AddDeviceStore.h"
#import "Model.h"

@implementation DeviceListLogic

- (void)operateWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_group_t group = dispatch_group_create();
    __block NSError *responseError = nil;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        GroupListStore *groupListStore = [[GroupListStore alloc] init];
        [groupListStore requestWithSuccess:^{
            if ([GroupListModel sharedInstance].selectedGroup == nil) {
                [GroupListModel sharedInstance].selectedGroup = [GroupListModel groupsWithCurrentUser][0];
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(NSError *error) {
            responseError = error;
            dispatch_semaphore_signal(semaphore);
        }];
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        if (responseError) {
            dispatch_semaphore_signal(semaphore);
            failure(responseError);
        } else {
            for (GroupModel *groupItem in [GroupListModel groupsWithUser:[UserModel currentUser]]) {
                dispatch_group_enter(group);
                DeviceListStore *deviceListStore = [[DeviceListStore alloc] init];
                deviceListStore.group = groupItem;
                [deviceListStore requestWithSuccess:^{
                    dispatch_group_leave(group);
                } failure:^(NSError *error) {
                    responseError = error;
                    dispatch_group_leave(group);
                }];
            }
            
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                dispatch_semaphore_signal(semaphore);
                success();
            });
        }
    });
}

@end
