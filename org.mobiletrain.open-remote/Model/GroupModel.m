#import "GroupModel.h"
#import "AuthorizationModel.h"
#import "UserModel.h"
#import "DeviceModel.h"
#import "GroupListModel.h"

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
    return [self authorizationWithUser:[UserModel currentUser]];
}

- (AuthorizationModel *)authorizationWithUser:(UserModel *)user {
    NSArray *filteredObjects = [self.authz filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(AuthorizationModel *evaluatedObject, NSDictionary *bindings) {
        return [[evaluatedObject user] isEqual:user];
    }]];
    NSAssert([filteredObjects count] <= 1, @"出现重复用户");
    
    if ([filteredObjects count]) {
        return [filteredObjects firstObject];
    } else {
        AuthorizationModel *result = [[AuthorizationModel alloc] init];
        result.user = user;
        [self.authz addObject:result];
        return result;
    }
}

- (void)insertDevie:(DeviceModel *)device {
    if (![self.devices containsObject:device]) {
        [[self mutableArrayValueForKey:@"devices"] addObject:device];
    }
}

+ (instancetype)groupWithIdentity:(NSString *)identity {
    return [GroupListModel groupWithIdentity:identity];
}

@end
