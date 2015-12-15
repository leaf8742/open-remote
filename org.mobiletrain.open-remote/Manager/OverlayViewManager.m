#import "OverlayViewManager.h"

@interface OverlayViewManager()

@property (copy) void (^touchEvent)();

@property (strong, nonatomic) UIControl *overlayView;

@end


@implementation OverlayViewManager

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)overlayViewDidReceiveTouchEvent:(id)sender {
    self.touchEvent();
    [self.overlayView removeFromSuperview];
}

+ (instancetype)sharedInstance {
    static OverlayViewManager *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[OverlayViewManager alloc] init];
    });
    return sharedClient;
}

+ (void)generateTouchEvent:(void (^)())touchEvent {
    [OverlayViewManager sharedInstance].touchEvent = touchEvent;
}

+ (void)setOverlayView:(UIView *)overlayView {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:[OverlayViewManager sharedInstance] action:@selector(overlayViewDidReceiveTouchEvent:)];
    [overlayView addGestureRecognizer:tap];
}

@end
