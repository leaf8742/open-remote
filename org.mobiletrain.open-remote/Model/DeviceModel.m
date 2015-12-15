#import "DeviceModel.h"

@interface DeviceModel()

/// @brief 所有的设备
@property (strong, nonatomic) NSMutableSet *devices;

@end


@implementation DeviceModel

+ (instancetype)sharedInstance {
    static DeviceModel *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[DeviceModel alloc] init];
    });
    return sharedClient;
}

- (instancetype)init {
    if (self = [super init]) {
        self.devices = [NSMutableSet set];
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    return [object isKindOfClass:[DeviceModel class]] && [self.identity isEqualToString:[(DeviceModel *)object identity]];
}

- (NSUInteger)hash {
    if (self.identity) {
        return [self.identity hash];
    } else {
        return [super hash];
    }
}

+ (DeviceModel *)deviceWithIdentity:(NSString *)identity {
    NSSet *filteredObjects = [[DeviceModel sharedInstance].devices filteredSetUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(DeviceModel *evaluatedObject, NSDictionary *bindings) {
        return [[evaluatedObject identity] isEqualToString:identity];
    }]];
    NSAssert([filteredObjects count] <= 1, @"出现重复设备");
    
    if ([filteredObjects count]) {
        return [filteredObjects anyObject];
    } else {
        DeviceModel *result = [[DeviceModel alloc] init];
        result.identity = identity;
        [[[DeviceModel sharedInstance] devices] addObject:result];
        return result;
    }
}

+ (JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"DeviceId": @"identity",
                                                       @"DeviceTypeName": @"type",
                                                       @"DeviceName": @"name",
                                                       }];
}

@end
