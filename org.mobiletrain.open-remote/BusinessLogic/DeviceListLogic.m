#import "DeviceListLogic.h"
#import "GroupListStore.h"
#import "DeviceListStore.h"
#import "Model.h"

@implementation DeviceListLogic

- (void)operateWithSuccess:(void (^)())success failure:(void (^)(NSError *error))failure {
#warning 本地调试
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        // 一个用户默认群组，两个后加的群组
//        NSArray *groups = @[@{@"id":@"DB279C71-043C-4C1F-B18A-3184B79BA0F1",
//                             @"primary":@YES,
//                             @"devices":@[@{@"id":@"84411FDC-422F-48B8-BE22-9FD88C80A7ED",
//                                            @"lat":@38.84365979,
//                                            @"lng":@121.39688959},
//                                          
//                                          @{@"id":@"CBCEB19C-6277-4861-B36A-0433E55DE9F9",
//                                            @"lat":@38.84365979,
//                                            @"lng":@121.39688959},
//
//                                          @{@"id":@"49155BF4-CBED-4DF3-B9E0-E6A5E5B128F8",
//                                            @"lat":@38.84365979,
//                                            @"lng":@121.39688959}
//                                     ]},
//                           
//                           @{@"id":@"19C362C0-8771-4742-8154-FA3F8F82D6AF",
//                             @"primary":@NO,
//                             @"devices":@[@{@"id":@"5DDC117F-35AE-4F88-8A8D-B0F95D2E4390",
//                                            @"lat":@38.84365979,
//                                            @"lng":@121.39688959},
//
//                                          @{@"id":@"B5D9F9CE-FA4F-428E-8F3F-C82E67243317",
//                                            @"lat":@38.84365979,
//                                            @"lng":@121.39688959},
//
//                                          @{@"id":@"FEAE653C-9A11-4361-A107-F10AF252FE08",
//                                            @"lat":@38.84365979,
//                                            @"lng":@121.39688959}
//                                     ]},
//                           
//                           @{@"id":@"53E313C1-6E0A-4153-A19B-1E780155B173",
//                             @"primary":@NO,
//                             @"devices":@[@{@"id":@"190115E4-E997-4D74-A2AE-239F1B16A3BD",
//                                            @"lat":@38.84365979,
//                                            @"lng":@121.39688959},
//
//                                          @{@"id":@"0DEFAAFD-D5AE-48B8-B645-4CC00A45A027",
//                                            @"lat":@38.84365979,
//                                            @"lng":@121.39688959},
//
//                                          @{@"id":@"45424106-CBA1-415D-A58B-4FF23AAC0F9F",
//                                            @"lat":@38.84365979,
//                                            @"lng":@121.39688959}
//                                     ]},
//                            
//                            @{@"id":@"F819999E-115E-4940-A293-31EB3A4A3629",
//                              @"primary":@NO,
//                              @"devices":@[@{@"id":@"96CF8665-3E16-43CC-9199-CA26536AD33A",
//                                             @"lat":@38.84365979,
//                                             @"lng":@121.39688959},
//
//                                           @{@"id":@"ACB43DD6-D652-46A1-A938-37441413686D",
//                                             @"lat":@38.84365979,
//                                             @"lng":@121.39688959},
//
//                                           @{@"id":@"6FF9EB6C-950D-47CC-A669-566CC34B77AE",
//                                             @"lat":@38.84365979,
//                                             @"lng":@121.39688959}
//                                           ]},
//
//                            @{@"id":@"6DA52867-4009-42E6-BDAD-506F600CD4A6",
//                              @"primary":@NO,
//                              @"devices":@[@{@"id":@"D7FBD48A-FA30-4873-94CF-E53CD17B94F6",
//                                             @"lat":@38.84365979,
//                                             @"lng":@121.39688959},
//
//                                           @{@"id":@"70BE214C-8759-4170-A0B9-C04670FB2455",
//                                             @"lat":@38.84365979,
//                                             @"lng":@121.39688959},
//
//                                           @{@"id":@"09FB79F9-8322-4609-A634-068D908C3912",
//                                             @"lat":@38.84365979,
//                                             @"lng":@121.39688959},
//                                           ]},
//
//                            @{@"id":@"6A5993A4-FD1A-47F7-9156-A52DD440834A",
//                              @"primary":@NO,
//                              @"devices":@[@{@"id":@"6CA73223-8C51-4E9F-8524-6B737551FE02",
//                                             @"lat":@38.84365979,
//                                             @"lng":@121.39688959},
//                                           @{@"id":@"0786CA36-AB57-4E49-BB54-094CC03EE729",
//                                             @"lat":@38.84365979,
//                                             @"lng":@121.39688959},
//                                           @{@"id":@"3758CF18-ADB9-47C0-86C5-B7692A9D60C7",
//                                             @"lat":@38.84365979,
//                                             @"lng":@121.39688959}
//                                           ]}
//                            ];
//        
//        for (NSDictionary *groupItem in groups) {
//            GroupModel *group = [GroupListModel groupWithIdentity:groupItem[@"id"]];
//            group.name = group.identity;
//            AuthorizationModel *authorization = [group currentAuthorization];
//            if (authorization == nil) {
//                authorization = [[AuthorizationModel alloc] init];
//                authorization.user = [UserModel sharedInstance];
//                [group.authz addObject:authorization];
//            }
//            authorization.primary = [groupItem[@"primary"] boolValue];
//            if (authorization.primary && [GroupListModel sharedInstance].selectedGroup == nil) {
//                [GroupListModel sharedInstance].selectedGroup = group;
//            }
//            
//            for (NSDictionary *deviceItem in groupItem[@"devices"]) {
//                DeviceModel *device = [DeviceModel deviceWithIdentity:deviceItem[@"id"]];
//                device.name = device.identity;
//                device.coordinate = CLLocationCoordinate2DMake([deviceItem[@"lat"] doubleValue], [deviceItem[@"lng"] doubleValue]);
//                [group insertDevie:device];
//            }
//        }
//        success();
//    });
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_group_t group = dispatch_group_create();
    __block NSError *responseError = nil;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        GroupListStore *groupListStore = [[GroupListStore alloc] init];
        [groupListStore requestWithSuccess:^{
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
            for (GroupModel *groupItem in [GroupListModel groupsWithUser:[UserModel sharedInstance]]) {
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
