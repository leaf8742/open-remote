#import "GroupSelectedControl.h"
#import <KVOController/KVOController.h>
#import "Model.h"

@implementation GroupSelectedControl

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.KVOController = [[FBKVOController alloc] init];
        [self renewalGroup];
        [self.KVOController observe:[GroupListModel sharedInstance] keyPath:@"selectedGroup" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld block:^(id observer, id object, NSDictionary *change) {
            [self renewalGroup];
        }];
    }
    return self;
}

- (void)renewalGroup {
    [self setTitle:[GroupListModel sharedInstance].selectedGroup.name forState:UIControlStateNormal];
}

@end
