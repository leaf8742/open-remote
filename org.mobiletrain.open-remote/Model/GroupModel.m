#import "GroupModel.h"
#import "AuthorizationModel.h"
#import "UserModel.h"
#import "DeviceModel.h"

@implementation GroupModel

- (instancetype)init {
    if (self = [super init]) {
        self.devices = [NSMutableArray array];
        self.authz = [NSMutableArray array];
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    return [object isKindOfClass:[GroupModel class]] && [self.identity isEqualToString:[(GroupModel *)object identity]];
}

- (NSUInteger)hash {
    if (self.identity) {
        return [self.identity hash];
    } else {
        return [super hash];
    }
}

- (AuthorizationModel *)currentAuthorization {
    NSArray *filteredObjects = [self.authz filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(AuthorizationModel *evaluatedObject, NSDictionary *bindings) {
        return [[evaluatedObject user] isEqual:[UserModel sharedInstance]];
    }]];
    NSAssert([filteredObjects count] <= 1, @"出现重复用户");
    
    if ([filteredObjects count]) {
        return [filteredObjects firstObject];
    } else {
        return nil;
    }
}

- (void)insertDevie:(DeviceModel *)device {
    if (![self.devices containsObject:device]) {
        [[self mutableArrayValueForKey:@"devices"] addObject:device];
    }
}

@end
