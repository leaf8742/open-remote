#import "DeviceViewController.h"
#import "GroupLocationViewController.h"
#import "TaskListViewController.h"
#import "DeviceSettingViewController.h"
#import "Model.h"
#import "DeviceOperationStore.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "ModifyDeviceNameStore.h"

@interface DeviceViewController ()

@end

@implementation DeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DeviceModel *device = [[[GroupListModel sharedInstance] selectedGroup] selectedDevice];
    
    [self.powerOn setOn:device.powerOn];
    self.title = [device name];
}

- (IBAction)powerSwitch:(UISwitch *)sender {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    DeviceOperationStore *store = [[DeviceOperationStore alloc] init];
    store.powerOn = sender.on;
    store.device = [[[GroupListModel sharedInstance] selectedGroup] selectedDevice];
    [store requestWithSuccess:^{
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

- (IBAction)locate:(UIButton *)sender {
    [[CoordinatingController sharedInstance] pushViewControllerWithClass:[GroupLocationViewController class] animated:YES];
}

- (IBAction)taskList:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"此功能暂未开放" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }]];
    [self presentViewController:alert animated:YES completion:^{
    }];
//    [[CoordinatingController sharedInstance] pushViewControllerWithClass:[TaskListViewController class] animated:YES];
}

- (IBAction)setting:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入要修改的设备名称" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        NSString *name = [alert.textFields[0] text];
        ModifyDeviceNameStore *store = [[ModifyDeviceNameStore alloc] init];
        store.device = [[[GroupListModel sharedInstance] selectedGroup] selectedDevice];
        store.name = name;
        [store requestWithSuccess:^{
            [SVProgressHUD dismiss];
            self.title = [[[GroupListModel sharedInstance] selectedGroup] selectedDevice].name;
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
        }];
    }]];
    [self presentViewController:alert animated:YES completion:^{
    }];
//    [[CoordinatingController sharedInstance] pushViewControllerWithClass:[DeviceSettingViewController class] animated:YES];
}

#pragma mark - CoordinatingControllerDelegate
+ (instancetype)buildViewController {
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [main instantiateViewControllerWithIdentifier:@"DeviceViewController"];
}

- (void)updateNavigation {
    
}

#pragma mark - Memory Management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
