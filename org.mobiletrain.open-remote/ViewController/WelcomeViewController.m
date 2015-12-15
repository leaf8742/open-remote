#import "WelcomeViewController.h"
#import "LogoAnimateLayer.h"
#import "CoordinatingController.h"
#import "SignInViewController.h"


@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
    
    const CGFloat aspect = 0.582;
    const CGFloat animateWidth = [UIScreen mainScreen].bounds.size.width * aspect;
    
    UIView *logoAnimate = [[UIView alloc] initWithFrame:CGRectMake(0, 0, animateWidth, animateWidth)];
    logoAnimate.center = self.view.center;
    
    LogoAnimateLayer *logoAnimateLayer = [LogoAnimateLayer layer];
    logoAnimateLayer.layerSize = logoAnimate.frame.size;
    [logoAnimateLayer preparePolygon];
    [logoAnimateLayer prepareCircle];
    logoAnimateLayer.completionBlock = ^{
        [[CoordinatingController sharedInstance] pushViewControllerWithClass:[SignInViewController class] animated:NO];
    };
    [logoAnimateLayer beginAnimate];
    [logoAnimate.layer addSublayer:logoAnimateLayer];
    
    [self.view addSubview:logoAnimate];
}

#pragma mark - CoordinatingControllerDelegate
+ (instancetype)buildViewController {
    return [[WelcomeViewController alloc] init];
}

- (BOOL)navigationBarHidden {
    return YES;
}

#pragma mark - Memory Management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
