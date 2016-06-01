#import "AppDelegate.h"
#import "ConfigHeader.h"
#import "CoordinatingController.h"
#import "PersistentManager.h"
#import "WelcomeViewController.h"

#import <IQKeyboardManager/IQKeyboardManager.h>
#import <EaseUI/EaseUI.h>
//#import <ShareSDK/ShareSDK.h>
//#import "WXApi.h"
//#import "WeiboSDK.h"

@interface AppDelegate ()

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self appearance];
    [self setupEaseSDK:application launchOptions:launchOptions];
//    [self setupYoumi];
    [self setupShareSDK];
    [self setupPushNotification:application];
    
    [PersistentManager serialize];
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    [[CoordinatingController sharedInstance] pushViewControllerWithClass:[WelcomeViewController class] animated:NO];
    
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.origin = CGPointZero;
    self.window = [[UIWindow alloc] initWithFrame:frame];
    self.window.rootViewController = [[CoordinatingController sharedInstance] rootViewController];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

// 获取远程推送授权成功
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
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
}

#pragma mark - !!!
// UI样式
- (void)appearance {
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithWhite:0.6 alpha:1]];
    [[UINavigationBar appearance] setTranslucent:YES];
}

// 初始化环信
- (void)setupEaseSDK:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions {
    [[EaseSDKHelper shareHelper] easemobApplication:application
                      didFinishLaunchingWithOptions:launchOptions
                                             appkey:@"rainbow-weaver#openremote"
                                       apnsCertName:@"aps_developer"
                                        otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"rainbow-weaver#openremote" apnsCertName:@""];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
}

// 初始化有米广告
- (void)setupYoumi {
    NSString *appid = @"8421d6601aff781a";
    NSString *secretId = @"d3696f1a72f90369";
    [NewWorldSpt initQQWDeveloperParams:appid QQ_SecretId:secretId];
    [NewWorldSpt initQQWDeveLoper:kTypePortrait];
}

// 初始化ShareSDK
- (void)setupShareSDK {
//    [ShareSDK registerApp:@"9da5d8d700ed"];
//    
//    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
//    [ShareSDK  connectSinaWeiboWithAppKey:@"568898243"
//                                appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
//                              redirectUri:@"http://www.sharesdk.cn"
//                              weiboSDKCls:[WeiboSDK class]];
//    //微信登陆的时候需要初始化
//    [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885"
//                           appSecret:@"64020361b8ec4c99936c0e3999a9f249"
//                           wechatCls:[WXApi class]];
}

// 初始化推送
- (void)setupPushNotification:(UIApplication *)application {
    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil]];
    [application registerForRemoteNotifications];
    
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types == UIUserNotificationTypeNone) {
        
    }
    
//    [self createLocalNotification];
}

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

@end
