#import "UITextField+InputValidator.h"
#import <objc/runtime.h>
#import <pop/POP.h>

static const void *inputValidatorKey = &inputValidatorKey;

@implementation UITextField (InputValidator)

- (NSNumber *)inputValidator {
    return objc_getAssociatedObject(self, inputValidatorKey);
}

- (void)setInputValidator:(InputValidator *)inputValidator {
    objc_setAssociatedObject(self, inputValidatorKey, inputValidator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)validate {
    NSError *error = nil;
    BOOL validationResult;
    
    if (!(validationResult = [self validateWithError:&error])) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription] message:[error localizedFailureReason] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    return validationResult;
}

- (BOOL)validateWithError:(NSError **)error {
    if (self.inputValidator == nil) {
        return YES;
    } else {
        BOOL validationResult = [self.inputValidator validateInput:self error:error];
        if (!validationResult) {
            POPSpringAnimation *shake = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
            shake.velocity = @(1500);
            shake.springBounciness = 15;
            shake.springSpeed = 20;
            shake.dynamicsFriction = 7;
            shake.dynamicsMass = 0.5;
            [self pop_removeAllAnimations];
            [self pop_addAnimation:shake forKey:kPOPViewCenter];
        }
        
        return validationResult;
    }
}

- (BOOL)shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSError *error = nil;
    if (!self.inputValidator) {
        return YES;
    }
    
    BOOL validationResult = [self.inputValidator validateInput:self shouldChangeCharactersInRange:range replacementString:string error:&error];
    
    return validationResult;
}

@end
