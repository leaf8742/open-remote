#import "GroupListModel.h"
#import "GroupModel.h"
#import "AuthorizationModel.h"
#import "UserModel.h"

@interface GroupListModel()

@property (strong, nonatomic) NSMutableArray *groups;

@end

@implementation GroupListModel

- (instancetype)init {
    if (self = [super init]) {
        self.groups = [NSMutableArray array];
    }
    return self;
}

+ (instancetype)sharedInstance {
    static GroupListModel *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[GroupListModel alloc] init];
    });
    return sharedClient;
}

+ (NSArray *)groupsWithUser:(UserModel *)user {

    NSArray *result = [[GroupListModel sharedInstance].groups filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(GroupModel *evaluatedObject, NSDictionary *bindings) {
        
        NSArray *hasUser = [evaluatedObject.authz filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(AuthorizationModel *evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject.user isEqual:user];
        }]];
        
        return [hasUser count] != 0;
    }]];
    return result;
}

+ (GroupModel *)groupWithIdentity:(NSString *)identity {
    NSArray *filteredObjects = [[GroupListModel sharedInstance].groups filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(GroupModel *evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject.identity isEqualToString:identity];
    }]];
    NSAssert([filteredObjects count] <= 1, @"出现重复群组");
    
    if ([filteredObjects count]) {
        return [filteredObjects firstObject];
    } else {
        GroupModel *group = [[GroupModel alloc] init];
        group.identity = identity;
        [[GroupListModel sharedInstance].groups addObject:group];
        return group;
    }
}

@end
