#import "UserListModel.h"
#import "UserModel.h"

@interface UserListModel()

@property (strong, nonatomic) NSMutableSet *users;

@end

@implementation UserListModel

- (instancetype)init {
    if (self = [super init]) {
        self.users = [NSMutableSet set];
    }
    return self;
}

+ (instancetype)sharedInstance {
    static UserListModel *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[UserListModel alloc] init];
    });
    return sharedClient;
}

+ (UserModel *)userWithMobile:(NSString *)mobile {
    NSSet *filteredUsers = [[UserListModel sharedInstance].users filteredSetUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UserModel *evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [evaluatedObject.mobile isEqualToString:mobile];
    }]];
    
    NSAssert([filteredUsers count] <= 1, @"出现重复用户");
    if ([filteredUsers count]) {
        return [filteredUsers anyObject];
    } else {
        UserModel *user = [[UserModel alloc] init];
        user.mobile = mobile;
        [[UserListModel sharedInstance].users addObject:user];
        return user;
    }
}

+ (UserModel *)userWithEmail:(NSString *)email {
    NSSet *filteredUsers = [[UserListModel sharedInstance].users filteredSetUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UserModel *evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [evaluatedObject.email isEqualToString:email];
    }]];
    
    NSAssert([filteredUsers count] <= 1, @"出现重复用户");
    if ([filteredUsers count]) {
        return [filteredUsers anyObject];
    } else {
        UserModel *user = [[UserModel alloc] init];
        user.email = email;
        [[UserListModel sharedInstance].users addObject:user];
        return user;
    }
}

+ (UserModel *)userWithIdentity:(NSString *)identity {
    NSSet *filteredUsers = [[UserListModel sharedInstance].users filteredSetUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UserModel *evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [evaluatedObject.identity isEqualToString:identity];
    }]];
    
    NSAssert([filteredUsers count] <= 1, @"出现重复用户");
    if ([filteredUsers count]) {
        return [filteredUsers anyObject];
    } else {
        UserModel *user = [[UserModel alloc] init];
        user.identity = identity;
        [[UserListModel sharedInstance].users addObject:user];
        return user;
    }
}

@end
