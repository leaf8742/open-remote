#import "UserModel.h"
#import "UserListModel.h"

@implementation UserModel

- (BOOL)isEqual:(id)object {
    return [object isKindOfClass:[UserModel class]] && [self.identity isEqualToString:[(UserModel *)object identity]];
}

- (NSUInteger)hash {
    if (self.identity) {
        return [self.identity hash];
    } else {
        return [super hash];
    }
}


+ (instancetype)currentUser {
    return [UserListModel sharedInstance].currentUser;
}

+ (instancetype)userWithMobile:(NSString *)mobile {
    return [UserListModel userWithMobile:mobile];
}

+ (instancetype)userWithEmail:(NSString *)email {
    return [UserListModel userWithEmail:email];
}

+ (instancetype)userWithIdentity:(NSString *)identity {
    return [UserListModel userWithIdentity:identity];
}

@end
