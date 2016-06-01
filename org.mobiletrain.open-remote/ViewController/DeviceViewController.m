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
    
    [self.powerOn setSelected:device.powerOn];
    if (!device.powerOn) {
        [self.powerOnBackground setImage:nil];
    }
    
    self.title = [device name];
}

- (IBAction)powerSwitch:(UIButton *)sender {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD show];
    DeviceOperationStore *store = [[DeviceOperationStore alloc] init];
    store.powerOn = sender.selected;
    store.device = [[[GroupListModel sharedInstance] selectedGroup] selectedDevice];
    [store requestWithSuccess:^{
        sender.selected = !sender.selected;
        DeviceModel *device = [[[GroupListModel sharedInstance] selectedGroup] selectedDevice];
        if (!device.powerOn) {
            [self.powerOnBackground setImage:nil];
        } else {
            [self.powerOnBackground setImage:[UIImage imageNamed:@"power_on_background"]];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        sender.selected = !sender.selected;
        DeviceModel *device = [[[GroupListModel sharedInstance] selectedGroup] selectedDevice];
        if (!device.powerOn) {
            [self.powerOnBackground setImage:nil];
        } else {
            [self.powerOnBackground setImage:[UIImage imageNamed:@"power_on_background"]];
        }
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
}

- (IBAction)setting:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入要修改的设备名称" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD show];
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
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alert animated:YES completion:^{
    }];
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
