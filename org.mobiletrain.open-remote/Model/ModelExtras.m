#import "ModelExtras.h"

kGender genderWithString(NSString *string) {
    if ([string isEqualToString:@"male"]) {
        return kGenderMale;
    } else if ([string isEqualToString:@"female"]) {
        return kGenderFemale;
    } else {
        return kGenderUnknown;
    }
}

NSString *stringWithGender(kGender gender) {
    switch (gender) {
        case kGenderMale:
            return @"male";
            break;
        case kGenderFemale:
            return @"female";
            break;
        default:
            return @"unknown";
            break;
    }
}

kAuthorization authorizationWithString(NSString *string) {
    if ([string isEqualToString:@"primary"]) {
        return kAuthorizationPrimary;
    } else if ([string isEqualToString:@"super"]) {
        return kAuthorizationSuper;
    } else if ([string isEqualToString:@"administrator"]) {
        return kAuthorizationAdministrator;
    } else {
        return kAuthorizationMember;
    }
}

NSString *stringWithAuthorization(kAuthorization authorization) {
    switch (authorization) {
        case kAuthorizationPrimary:
            return @"primary";
            break;
        case kAuthorizationSuper:
            return @"supser";
            break;
        case kAuthorizationAdministrator:
            return @"administrator";
            break;
        default:
            return @"member";
            break;
    }
}