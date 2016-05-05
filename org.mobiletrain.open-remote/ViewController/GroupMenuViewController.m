#import "GroupMenuViewController.h"
#import "Model.h"
#import <KVOController/KVOController.h>
#import "GroupMenuCell.h"
#import <RESideMenu/RESideMenu.h>

@interface GroupMenuViewController ()

@end

@implementation GroupMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self registerObserving];
}

- (void)registerObserving {
    self.KVOController = [FBKVOController controllerWithObserver:self];
    [self.KVOController observe:[GroupListModel sharedInstance] keyPath:@"groups" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld block:^(id observer, id object, NSDictionary *change) {
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    }];
}

#pragma mark - CoordinatingControllerDelegate
+ (instancetype)buildViewController {
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GroupMenuViewController *result = [main instantiateViewControllerWithIdentifier:@"GroupMenuViewController"];
    
    return result;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning 本机调试
    return [[GroupListModel groupsWithUser:[UserModel currentUser]] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GroupMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GroupReuseIdentifier" forIndexPath:indexPath];
    NSArray *groups = [GroupListModel groupsWithUser:[UserModel currentUser]];
    cell.textLabel.text = [groups[indexPath.row] name];
    cell.imageView.image = [UIImage imageNamed:@"icon"];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [GroupListModel sharedInstance].selectedGroup = [GroupListModel groupsWithCurrentUser][indexPath.row];
    [self.sideMenuViewController hideMenuViewController];
//    [self dismissViewControllerAnimated:YES completion:^{
//    }];
}

#pragma mark - Memory Management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
