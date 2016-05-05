#import "HomePageViewController.h"
#import "DeviceListViewController.h"
#import "GroupListViewController.h"
#import "ProfileViewController.h"
#import "GraphicsAssist.h"
#import <EaseUI/EaseUI.h>
#import "Model.h"
#import "NSString+UUIDHandle.h"
#import <KVOController/KVOController.h>

@interface HomePageViewController ()<UITabBarControllerDelegate, RESideMenuDelegate, EaseMessageViewControllerDelegate, EaseMessageViewControllerDataSource, EMChatManagerDelegate>

@property (retain, nonatomic) UITabBarController *tabBarController;

@end


@implementation HomePageViewController

- (id)init {
    if (self = [super init]) {
        self.KVOController = [FBKVOController controllerWithObserver:self];
        [self.KVOController observe:[GroupListModel sharedInstance] keyPath:@"selectedGroup" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld block:^(id observer, id object, NSDictionary *change) {
            [self buildChatViewController];
            [self.tabBarController setViewControllers:@[self.deviceListVC, self.chatViewController]];
        }];
        self.tabBarController = [[UITabBarController alloc] init];
        [self buildHomePage];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)buildHomePage {
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    [self buildDeviceListViewController];
    [self buildChatViewController];
    
    [self.tabBarController setViewControllers:@[self.deviceListVC, self.chatViewController]];
    [self.navigationItem setHidesBackButton:YES];
    [self.tabBarController setSelectedViewController:self.deviceListVC];
    [self.tabBarController setDelegate:self];
    
    ProfileViewController *profile = [ProfileViewController buildViewController];
    [self setContentViewController:self.tabBarController];
    [self setLeftMenuViewController:profile];
    [self setScaleMenuView:NO];
    [self setFadeMenuView:NO];
    [self setScaleContentView:NO];
    self.contentViewInLandscapeOffsetCenterX = [UIScreen mainScreen].bounds.size.height / 3;
    self.contentViewInPortraitOffsetCenterX = [UIScreen mainScreen].bounds.size.width / 3;
    self.delegate = self;
}

- (void)buildDeviceListViewController {
    UITabBarItem *deviceListTab = [[UITabBarItem alloc] initWithTitle:@"家居" image:[GraphicsAssist imageWithImageSimple:[UIImage imageNamed:@"home"] scaledToSize:CGSizeMake(32, 32)] tag:0];
    self.deviceListVC = [DeviceListViewController buildViewController];
    [self.deviceListVC setTabBarItem:deviceListTab];
    [self.deviceListVC setTitle:@"家居"];
}

- (void)buildChatViewController {
    UITabBarItem *groupListTab = [[UITabBarItem alloc] init];
    if ([GroupListModel sharedInstance].selectedGroup) {
        self.chatViewController = [[EaseMessageViewController alloc] initWithConversationChatter:[[GroupListModel sharedInstance].selectedGroup.identity withoutSeparator] conversationType:eConversationTypeGroupChat];
    } else {
        self.chatViewController = [[EaseMessageViewController alloc] init];
    }
    self.chatViewController.delegate = self;
    self.chatViewController.dataSource = self;
    [self.chatViewController setTabBarItem:groupListTab];
    [self.chatViewController setTitle:@"互动"];
}

#pragma mark - CoordinatingControllerDelegate
+ (instancetype)buildViewController {
    return [[HomePageViewController alloc] init];
}

- (void)updateNavigation {
    [(id<CoordinatingControllerDelegate>)(self.tabBarController.selectedViewController) updateNavigation];
}

#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if ([viewController conformsToProtocol:@protocol(CoordinatingControllerDelegate)] && [viewController respondsToSelector:@selector(updateNavigation)]) {
        [(id<CoordinatingControllerDelegate>)viewController updateNavigation];
    }

//    self.tabBarController.sideMenuViewController.panGestureEnabled = [viewController isKindOfClass:[DeviceListViewController class]];
}

#pragma mark - RESideMenuDelegate
- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - Memory Management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
