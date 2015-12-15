#import "PersistentManager.h"
#import "Model.h"

@implementation PersistentManager

+ (instancetype)sharedInstance {
    static PersistentManager *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[PersistentManager alloc] init];
    });
    return sharedClient;
}

+ (void)persist {
#warning TODO
}

+ (void)serialize {
#warning TODO
}

@end
