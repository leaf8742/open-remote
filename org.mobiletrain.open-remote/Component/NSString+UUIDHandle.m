#import "NSString+UUIDHandle.h"

@implementation NSString (UUIDHandle)

- (NSString *)withoutSeparator {
    return [self stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

@end
