#import "ProfileViewController.h"
#import "CoordinatingController.h"
//#import <ShareSDK/ShareSDK.h>
#import "CreateGroupStore.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)share:(UIButton *)sender {
//    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK" ofType:@"png"];
//    
//    //构造分享内容
//    id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
//                                       defaultContent:@"测试一下"
//                                                image:[ShareSDK imageWithPath:imagePath]
//                                                title:@"ShareSDK"
//                                                  url:@"http://www.mob.com"
//                                          description:@"这是一条测试信息"
//                                            mediaType:SSPublishContentMediaTypeNews];
//    //创建iPad弹出菜单容器,详见第六步
//    id<ISSContainer> container = [ShareSDK container];
//    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
//    
//    //弹出分享菜单
//    [ShareSDK showShareActionSheet:container
//                         shareList:nil
//                           content:publishContent
//                     statusBarTips:YES
//                       authOptions:nil
//                      shareOptions:nil
//                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                                
//                                if (state == SSResponseStateSuccess)
//                                {
//                                    NSLog(@"分享成功");
//                                }
//                                else if (state == SSResponseStateFail)
//                                {
//                                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", [error errorCode], [error errorDescription]);
//                                }
//                            }];
}

- (IBAction)signOut:(UIButton *)sender {
    [[CoordinatingController sharedInstance] popViewController];
}

#pragma mark - CoordinatingControllerDelegate
+ (instancetype)buildViewController {
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    id result = [main instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    return result;
}

#pragma mark - Memory Management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
