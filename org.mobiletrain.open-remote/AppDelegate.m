#import "AppDelegate.h"
#import "ConfigHeader.h"
#import "CoordinatingController.h"
#import "PersistentManager.h"
#import "SignInViewController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "WelcomeViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/SDWebImageManager.h>

@interface AppDelegate ()

@end


@implementation AppDelegate

- (void)createLocalNotification {
    // 创建一个本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    //设置10秒之后
    NSDate *pushDate = [NSDate dateWithTimeIntervalSinceNow:10];
    if (notification != nil) {
        // 设置推送时间
        notification.fireDate = pushDate;
        
        // 设置时区
        notification.timeZone = [NSTimeZone defaultTimeZone];
        
        // 设置重复间隔
        notification.repeatInterval = kCFCalendarUnitDay;
        
        // 推送声音
        notification.soundName = UILocalNotificationDefaultSoundName;
        
        // 推送内容
        notification.alertBody = @"推送内容";
        
        //显示在icon上的红色圈中的数子
        notification.applicationIconBadgeNumber = 1;
        
        //设置userinfo 方便在之后需要撤销的时候使用
        NSDictionary *info = [NSDictionary dictionaryWithObject:@"name"forKey:@"key"];
        notification.userInfo = info;
        
        //添加推送到UIApplication
        UIApplication *app = [UIApplication sharedApplication];
        [app scheduleLocalNotification:notification];
    }
}

- (void) removeLocalNotication {
    // 获得 UIApplication
    UIApplication *app = [UIApplication sharedApplication];
    
    //获取本地推送数组
    NSArray *localArray = [app scheduledLocalNotifications];
    
    //声明本地通知对象
    UILocalNotification *localNotification;
    if (localArray) {
        for (UILocalNotification *noti in localArray) {
            NSDictionary *dict = noti.userInfo;
            if (dict) {
                NSString *inKey = [dict objectForKey:@"key"];
                if ([inKey isEqualToString:@"对应的key值"]) {
                    if (localNotification){
                        localNotification = nil;
                    }
                    
                    break;
                }
            }
        }
        
        //判断是否找到已经存在的相同key的推送
        if (!localNotification) {
            //不存在初始化
            localNotification = [[UILocalNotification alloc] init];
        }
        
        if (localNotification) {
            //不推送 取消推送
            [app cancelLocalNotification:localNotification];
            return;
        }
    }
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil]];
    [application registerForRemoteNotifications];
    
    [self createLocalNotification];
    
    NSString *appid = @"8421d6601aff781a";
    NSString *secretId = @"d3696f1a72f90369";
    [NewWorldSpt initQQWDeveloperParams:appid QQ_SecretId:secretId];
    [NewWorldSpt initQQWDeveLoper:kTypePortrait];
    
    [PersistentManager serialize];
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    [[CoordinatingController sharedInstance] pushViewControllerWithClass:[WelcomeViewController class] animated:NO];
    
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.origin = CGPointZero;
    self.window = [[UIWindow alloc] initWithFrame:frame];
    self.window.rootViewController = [[CoordinatingController sharedInstance] rootViewController];
    
    //环信注册
//    [[EaseMob sharedInstance] registerSDKWithAppKey:@"dl-1000phone#openremote" apnsCertName:nil];
//    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    [self.window makeKeyAndVisible];
    
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithWhite:0.6 alpha:1]];
    [[UINavigationBar appearance] setTranslucent:YES];

    return YES;
}

// 获取远程推送授权成功
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

// 接收本地推送
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification*)notification {
}

// 获取远程推送授权失败
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error{
}

// 接收远程推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [PersistentManager persist];
    
//    [[EaseMob sharedInstance] applicationWillTerminate:application];
}

// App进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application{
//    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}

// App将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application {
//    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}

@end
