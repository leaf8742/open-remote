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

+ (JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"Data.PhoneNumber": @"mobile",
                                                       @"Data.EmailAddress": @"email",
                                                       @"Data.Alias": @"alias",
                                                       @"Data.UserId":@"identity",
                                                       @"Data.HeaderImage":@"headerImage",
                                                       @"Data.CRCodeImage":@"QRCode"
                                                       }];
}

+ (instancetype)currentUser {
    static UserModel *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[UserModel alloc] init];
    });
    return sharedClient;
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
