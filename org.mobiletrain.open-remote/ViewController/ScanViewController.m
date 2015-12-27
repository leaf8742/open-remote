#import "ScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <RESideMenu/RESideMenu.h>
#import <RESideMenu/UIViewController+RESideMenu.h>
#import "AddDeviceStore.h"
#import "Model.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (strong, nonatomic) AVCaptureSession *session;

@property (strong, nonatomic) CALayer *maskLayer;

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupMask];
    
    if (![self setupCapture]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"模拟器不支持摄像头哦" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alert animated:YES completion:^{
        }];
    }
}

// 准备镂空方格
- (void)setupMask {
    // 镂空方格
    // 参考 http://segmentfault.com/a/1190000002436915
    self.maskLayer = [CALayer layer];
    self.maskLayer.frame = self.view.frame;
    // 除镂空之外的地方，使用什么颜色填充
    self.maskLayer.backgroundColor = [UIColor colorWithWhite:0.333 alpha:0.667].CGColor;
    // 透明度为60%
    self.maskLayer.opacity = 1;
    
    // 镂空范围为200x200
    CGFloat rectSize = 200;
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.view.frame;
    // http://jamesonquave.com/blog/fun-with-cashapelayer/
    // 指明左上角和右下角为圆角，其他为方角 byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomRight
    // 指明圆半径为20像素 cornerRadii:CGSizeMake(20, 20)
    // 镂空方格的frame bezierPathWithRoundedRect
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake((self.view.frame.size.width - rectSize) / 2, (self.view.frame.size.height - rectSize) / 2, rectSize, rectSize) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(40, 40)];
    [path appendPath:[UIBezierPath bezierPathWithRect:self.view.layer.frame]];
    shapeLayer.path = path.CGPath;
    shapeLayer.fillRule = kCAFillRuleEvenOdd;
    
    self.maskLayer.mask = shapeLayer;
    [self.view.layer addSublayer:self.maskLayer];
}

- (BOOL)setupCapture {
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device == nil) {
        return NO;
    }
    
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    AVCaptureSession *session = [[AVCaptureSession alloc]init];
    self.session = session;
    //高质量采集率
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [session addInput:input];
    [session addOutput:output];
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    //开始捕获
    [session startRunning];
    
    return YES;
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        
        NSDictionary *deviceDict = [NSJSONSerialization JSONObjectWithData:[metadataObject.stringValue dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        if (deviceDict == nil) {
            return;
        }
        
        if (self.scanType == kScanTypeDevice) {
            [self handleScanDevice:deviceDict];
        } else if (self.scanType == kScanTypeUser) {
            [self handleScanUser:deviceDict];
        }
    }
}

- (void)handleScanDevice:(NSDictionary *)object {
    [self.session stopRunning];
    DeviceModel *device = [DeviceModel deviceWithIdentity:object[@"prod_id"]];
    device.typeCode = [object[@"prod_type"] integerValue];
    device.name = object[@"prod_title"];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    AddDeviceStore *store = [[AddDeviceStore alloc] init];
    store.device = device;
    store.group = [GroupListModel sharedInstance].selectedGroup;
    [store requestWithSuccess:^{
        [SVProgressHUD dismiss];
        [[CoordinatingController sharedInstance] popViewController];
    } failure:^(NSError *error) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }]];
        [self presentViewController:alert animated:YES completion:^{
        }];
        
        [SVProgressHUD dismiss];
        [self.session startRunning];
    }];
}

- (void)handleScanUser:(NSDictionary *)object {
#warning TODO
}

#pragma mark - CoordinatingControllerDelegate
+ (instancetype)buildViewController {
    return [[ScanViewController alloc] init];
}

- (void)updateNavigation {
}

#pragma mark - Memory Management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
