#import "SignInViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "SignInStore.h"
#import "CoordinatingController.h"
#import "HomePageViewController.h"
#import "SignUpViewController.h"
#import <IQKeyboardManager/KeyboardManager.h>
#import "UserModel.h"
#import "LogoAnimateLayer.h"
#import <pop/POP.h>
//#import "EaseMob.h"
//#import "EMError.h"

@interface SignInViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) UIView *logoAnimate;

@property (strong, nonatomic) LogoAnimateLayer *logoAnimateLayer;

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登录";
    
    [self.account setLeftView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"account"]]];
    self.account.leftViewMode = UITextFieldViewModeAlways;

    [self.passwd setLeftView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"passwd"]]];
    self.passwd.leftViewMode = UITextFieldViewModeAlways;
    
    const CGFloat aspect = 0.582;
    const CGFloat animateWidth = [UIScreen mainScreen].bounds.size.width * aspect;
    
    self.logoAnimate = [[UIView alloc] initWithFrame:CGRectMake(0, 0, animateWidth, animateWidth)];
    self.logoAnimate.userInteractionEnabled = NO;
    self.logoAnimate.center = self.view.center;
    
    self.logoAnimateLayer = [LogoAnimateLayer layer];
    self.logoAnimateLayer.layerSize = self.logoAnimate.frame.size;
    self.logoAnimateLayer.animated = NO;
    [self.logoAnimateLayer preparePolygon];
    [self.logoAnimateLayer prepareCircle];
    [self.logoAnimateLayer beginAnimate];
    [self.logoAnimate.layer addSublayer:self.logoAnimateLayer];
    
    [self.view addSubview:self.logoAnimate];
    
    [self frameAnim];
}

- (void)bounceAnim {
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    animation.toValue = @1;
    animation.duration = 0.4;
    
    [self.account pop_addAnimation:animation forKey:kPOPViewAlpha];
    [self.passwd pop_addAnimation:animation forKey:kPOPViewAlpha];
    [self.signUp pop_addAnimation:animation forKey:kPOPViewAlpha];
    [self.forgetPasswd pop_addAnimation:animation forKey:kPOPViewAlpha];
}

- (void)frameAnim {
    [self.logoAnimateLayer disappearHouse];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        [animation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
            [self bounceAnim];
        }];
        animation.name = @"frame";
        animation.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX([UIScreen mainScreen].bounds), CGRectGetMaxY([UIScreen mainScreen].bounds) / 4)];
        animation.duration = 0.8;
        [self.logoAnimate pop_addAnimation:animation forKey:@"frame"];
    });
}

- (IBAction)signUp:(id)sender {
    [[CoordinatingController sharedInstance] pushViewControllerWithClass:[SignUpViewController class] animated:YES];
}

- (IBAction)backgroundTap:(id)sender {
    [[CoordinatingController sharedInstance] backgroundTap:sender];
}

#pragma mark - CoordinatingControllerDelegate
+ (instancetype)buildViewController {
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    id result = [main instantiateViewControllerWithIdentifier:@"SignInViewController"];
    return result;
}

- (BOOL)navigationBarHidden {
    return YES;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
#warning 本机调试
//    [[CoordinatingController sharedInstance] pushViewControllerWithClass:[HomePageViewController class] animated:YES];
    if (![[IQKeyboardManager sharedManager] goNext]) {
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        SignInStore *store = [[SignInStore alloc] init];
        store.account = self.account.text;
        store.passwd = self.passwd.text;
        [store requestWithSuccess:^{
            [[CoordinatingController sharedInstance] pushViewControllerWithClass:[HomePageViewController class] animated:YES];
            [SVProgressHUD dismiss];
        } failure:^(NSError *error) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            }]];
            [self presentViewController:alert animated:YES completion:^{
            }];
            
            [SVProgressHUD dismiss];
        }];
    }
    return YES;
}

#pragma mark - Memory Management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
