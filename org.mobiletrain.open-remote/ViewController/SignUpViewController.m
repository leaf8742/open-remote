#import "SignUpViewController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "SignUpStore.h"
#import "HomePageViewController.h"
#import "UserModel.h"
#import <HexColors/HexColors.h>
#import "UITextField+InputValidator.h"
#import <pop/POP.h>

@interface SignUpViewController ()<UITextFieldDelegate>

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *requiredColor = [HXColor hx_colorWithHexString:@"#ca8589"];
    self.mobile.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机号码" attributes:@{NSForegroundColorAttributeName:requiredColor, NSFontAttributeName:[UIFont boldSystemFontOfSize:12]}];
    self.email.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"邮箱" attributes:@{NSForegroundColorAttributeName:requiredColor, NSFontAttributeName:[UIFont boldSystemFontOfSize:12]}];
    self.passwd.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"密码" attributes:@{NSForegroundColorAttributeName:requiredColor, NSFontAttributeName:[UIFont boldSystemFontOfSize:12]}];
    self.confirm.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"确认密码" attributes:@{NSForegroundColorAttributeName:requiredColor, NSFontAttributeName:[UIFont boldSystemFontOfSize:12]}];
}

#pragma mark - CoordinatingControllerDelegate
+ (instancetype)buildViewController {
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    id result = [main instantiateViewControllerWithIdentifier:@"SignUpViewController"];
    return result;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (![textField validateWithError:nil]) {
        [[IQKeyboardManager sharedManager] goNext];
    } else if (![[IQKeyboardManager sharedManager] goNext]) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        SignUpStore *store = [[SignUpStore alloc] init];
        store.mobile = self.mobile.text;
        store.email = self.email.text;
        store.alias = self.alias.text;
        store.passwd = self.passwd.text;
        [store requestWithSuccess:^{
            [[CoordinatingController sharedInstance] popViewControllerWithAnimated:NO];
            [[CoordinatingController sharedInstance] pushViewControllerWithClass:[HomePageViewController class] animated:YES];
            [SVProgressHUD dismiss];
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            }]];
            [self presentViewController:alert animated:YES completion:^{
            }];
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
