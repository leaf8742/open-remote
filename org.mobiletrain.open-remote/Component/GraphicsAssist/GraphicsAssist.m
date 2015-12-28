#import "GraphicsAssist.h"

static inline double radians (double degrees)
{
    return degrees * M_PI/180;
}
@implementation GraphicsAssist

+ (UIImage *)trimImage:(UIImage *)image center:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise {
    CGRect rect = CGRectZero;
    rect.size = image.size;

    CGImageRef mask;
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.0);
    {
        UIGraphicsBeginImageContext(rect.size);
        {
            CGContextRef imgCtx = UIGraphicsGetCurrentContext();
            CGContextMoveToPoint(imgCtx, center.x, center.y);
            CGContextAddArc(imgCtx, center.x, center.y, radius,  startAngle, endAngle, clockwise);
            CGContextFillPath(imgCtx);
            mask = CGBitmapContextCreateImage(UIGraphicsGetCurrentContext());
        }
        UIGraphicsEndImageContext();
    }
    UIGraphicsEndImageContext();

    UIImage *maskedImage;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    {
        CGContextClipToMask(UIGraphicsGetCurrentContext(), rect, mask);
        [image drawAtPoint:CGPointZero];
        CGImageRelease(mask);
        maskedImage = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    return maskedImage;
}

+ (UIImage *)createImageWithColor:(UIColor *) color size:(CGSize)size {
    UIImage *result = nil;
    CGRect rect=CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (context) {
        CGContextSetFillColorWithColor(context, [color CGColor]);
        CGContextFillRect(context, rect);
        result = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    return result;
}

+ (UIImage *)createImageWithColor:(UIColor *) color {
    return [self createImageWithColor:color size:CGSizeMake(1, 1)];
}

+ (UIImage *)maskImage:(UIImage *)image withColor:(UIColor *)color {
    CGRect rect = CGRectZero;
    rect.size = image.size;

    CGImageRef mask = [image CGImage];
    
    UIImage *maskedImage;
    UIImage *colorImage = [GraphicsAssist createImageWithColor:color size:image.size];
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    {
        CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1, -1);
        CGContextTranslateCTM (UIGraphicsGetCurrentContext(), 0, -colorImage.size.height);
        CGContextClipToMask(UIGraphicsGetCurrentContext(), rect, mask);
        [colorImage drawAtPoint:CGPointZero];
        maskedImage = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    return maskedImage;
}

//+ (UIImage *)clipImage:(UIImage *)clipImage maskImage:(UIImage *)maskImage maskPoint:(CGPoint)point {
//#warning 未完成
//    UIImage *result;
//    CGImageRef mask;
//    UIGraphicsBeginImageContext(clipImage.size);
//    {
//        [maskImage drawAtPoint:CGPointZero];
//        mask = CGBitmapContextCreateImage(UIGraphicsGetCurrentContext());
//    }
//    UIGraphicsEndImageContext();
//
//    UIGraphicsBeginImageContext(clipImage.size);
//    {
//        CGContextClipToMask(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, clipImage.size.width, clipImage.size.height), mask);
//        [clipImage drawAtPoint:point];
//        CGImageRelease(mask);
//        result = UIGraphicsGetImageFromCurrentImageContext();
//    }
//    UIGraphicsEndImageContext();
//
//    UIImage *maskedImage;
//    UIGraphicsBeginImageContext(clipImage.size);
//    {
//        CGContextClip(UIGraphicsGetCurrentContext());
//        [clipImage drawAtPoint:point];
//        CGImageRelease(mask);
//        maskedImage = UIGraphicsGetImageFromCurrentImageContext();
//    }
//    UIGraphicsEndImageContext();
//
//    return result;
//}

+ (UIImage*)getGrayImage:(UIImage*)sourceImage
{
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(nil,width,height,8,0,colorSpace,kCGBitmapByteOrderDefault);
    CGColorSpaceRelease(colorSpace);
    
    if (context == NULL) {
        return nil;
    }
    
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), sourceImage.CGImage);
    CGImageRef grayImageRef = CGBitmapContextCreateImage(context);
    UIImage *grayImage = [UIImage imageWithCGImage:grayImageRef];
    CGContextRelease(context);
    CGImageRelease(grayImageRef);
    
    return grayImage;
}

+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

+ (CGPoint)reverseRotation:(CGFloat)radian center:(CGPoint)center point:(CGPoint)point {
    CGPoint vectorp = CGPointMake(point.x - center.x, point.y - center.y);
    CGPoint vector = CGPointMake(vectorp.x * cosf(-radian) - vectorp.y * sinf(-radian),
                                 vectorp.x * sinf(-radian) + vectorp.y * cosf(-radian));
    CGPoint result = CGPointMake(center.x + vector.x, center.y + vector.y);

    return result;
}

@end
