#import "DeviceListViewController.h"
#import "Model.h"
#import "DeviceListLogic.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "ScanViewController.h"
#import <RESideMenu/UIViewController+RESideMenu.h>
#import <RESideMenu/RESideMenu.h>
#import <KVOController/FBKVOController.h>
#import "DeviceViewController.h"
#import "GroupMenuViewController.h"
#import "GroupMenuTransitionAnimator.h"
#import "GroupSelectedControl.h"

@interface DeviceListViewController ()<UIViewControllerTransitioningDelegate>

@end


@implementation DeviceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"家居";
    
    self.KVOController = [FBKVOController controllerWithObserver:self];
    [self.KVOController observe:[GroupListModel sharedInstance] keyPath:@"selectedGroup" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld block:^(id observer, id object, NSDictionary *change) {
        [self.KVOController unobserve:change[NSKeyValueChangeOldKey] keyPath:@"devices"];
        [self.KVOController observe:change[NSKeyValueChangeNewKey] keyPath:@"devices" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld block:^(id observer, id object, NSDictionary *change) {
            [self.tableView reloadData];
        }];
        [self.tableView reloadData];
    }];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl beginRefreshing];
    [self.refreshControl sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)scan:(id)sender {
    [[CoordinatingController sharedInstance] pushViewControllerWithClass:[ScanViewController class] animated:YES];
}

- (void)refreshValueChanged:(UIRefreshControl *)sender {
    DeviceListLogic *logic = [[DeviceListLogic alloc] init];
    [logic operateWithSuccess:^{
        [GroupListModel sharedInstance].selectedGroup = [[GroupListModel groupsWithUser:[UserModel sharedInstance]] firstObject];
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.refreshControl endRefreshing];
    }];
}

- (void)selectGroup:(id)sender {
    UIViewController *group = [GroupMenuViewController buildViewController];
    group.transitioningDelegate = self;
    group.modalPresentationStyle = UIModalPresentationCustom;

    [self presentViewController:group animated:YES completion:^{
    }];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DeviceModel *device = [[[GroupListModel sharedInstance] selectedGroup] devices][indexPath.row];
    [[GroupListModel sharedInstance] selectedGroup].selectedDevice = device;
    [[CoordinatingController sharedInstance] pushViewControllerWithClass:[DeviceViewController class] animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[[GroupListModel sharedInstance] selectedGroup] devices] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeviceModel *device = [[[GroupListModel sharedInstance] selectedGroup] devices][indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceCell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"icon"];
    cell.textLabel.text = [device name];
    return cell;
}

#pragma mark - CoordinatingControllerDelegate
+ (instancetype)buildViewController {
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DeviceListViewController *result = [main instantiateViewControllerWithIdentifier:@"DeviceListViewController"];
    
    return result;
}

- (void)updateNavigation {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(scan:)];
    [self.tabBarController.sideMenuViewController.navigationItem setRightBarButtonItem:item];
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    id<UIViewControllerAnimatedTransitioning> animationController;
    
    GroupMenuTransitionAnimator *animator = [[GroupMenuTransitionAnimator alloc] init];
    animator.transitionType = kTransitionTypePresent;
    animationController = animator;
    return animator;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    id<UIViewControllerAnimatedTransitioning> animationController;
    
    GroupMenuTransitionAnimator *animator = [[GroupMenuTransitionAnimator alloc] init];
    animator.transitionType = kTransitionTypeDismiss;
    animationController = animator;
    
    return animationController;
}

//- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator {
//    return nil;
//}
//
//- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
//    return nil;
//}
//
//- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
//    return nil;
//}


#pragma mark - Memory Management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
