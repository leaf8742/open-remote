#import "GroupListViewController.h"
#import "PublicGroupDetailViewController.h"
#import "GroupListStore.h"
#import "Model.h"
#import "ChatViewController.h"
#import <RESideMenu/UIViewController+RESideMenu.h>
#import <RESideMenu/RESideMenu.h>

@interface GroupListViewController ()

//@property (strong, nonatomic) NSMutableArray *dataSource;
//@property (nonatomic, strong) NSString *cursor;
//@property (nonatomic) BOOL isGettingMore;

@end

@implementation GroupListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"互动";
}

#pragma mark - CoordinatingControllerDelegate
+ (instancetype)buildViewController {
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    id result = [main instantiateViewControllerWithIdentifier:@"GroupListViewController"];
    return result;
}

- (void)updateNavigation {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onCreateGroup)];
    [self.tabBarController.sideMenuViewController.navigationItem setRightBarButtonItem:item];
}

#pragma mark - Memory Management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
