#import "UserModel.h"

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

+ (UserModel *)sharedInstance {
    static UserModel *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[UserModel alloc] init];
    });
    return sharedClient;
}

+ (UserModel *)userWithMobile:(NSString *)mobile {
#warning TODO
    return nil;
}

+ (UserModel *)userWithEmail:(NSString *)email {
#warning TODO
    return nil;
}

+ (UserModel *)userWithIdentity:(NSString *)identity {
#warning TODO
    return nil;
}

@end
