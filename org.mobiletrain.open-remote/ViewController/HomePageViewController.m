#import "HomePageViewController.h"
#import "DeviceListViewController.h"
#import "GroupListViewController.h"
#import "ProfileViewController.h"

@interface HomePageViewController ()<UITabBarControllerDelegate, RESideMenuDelegate>

@property (retain, nonatomic) UITabBarController *tabBarController;

@end


@implementation HomePageViewController

- (id)init {
    if (self = [super init]) {
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
    UITabBarItem *deviceListTab = [[UITabBarItem alloc] init];
    self.deviceListVC = [DeviceListViewController buildViewController];
    [self.deviceListVC setTabBarItem:deviceListTab];
    [self.deviceListVC setTitle:@"家居"];
    
    UITabBarItem *groupListTab = [[UITabBarItem alloc] init];
    self.groupListVC = [GroupListViewController buildViewController];
    [self.groupListVC setTabBarItem:groupListTab];
    [self.groupListVC setTitle:@"群组"];
    
    [self.tabBarController setViewControllers:@[self.deviceListVC, self.groupListVC]];
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
