#import "GroupMenuViewController.h"
#import "Model.h"

@interface GroupMenuViewController ()

@end

@implementation GroupMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    return [[GroupListModel groupsWithUser:[UserModel sharedInstance]] count];
//    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GroupReuseIdentifier" forIndexPath:indexPath];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [GroupListModel sharedInstance].selectedGroup = [GroupListModel groupsWithUser:[UserModel sharedInstance]][indexPath.row];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - Memory Management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
