//
//  UIImage+Resizeable.m
//  LegendWorld
//
//  Created by Tsz on 2016/11/1.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "UIImage+Resizeable.h"


static CGFloat const defaultCornerRadius = 10.0;
static CGFloat const defaultLineWidth = 1.0;
@implementation UIImage (Resizeable)

+ (UIImage *)imageNamed:(NSString *)imageName cornerRadius:(CGFloat)cornerRidus {
    UIImage *image = [UIImage imageNamed:imageName];
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(cornerRidus, cornerRidus, cornerRidus, cornerRidus)
                                 resizingMode:UIImageResizingModeStretch];
}

+ (UIImage *)resizableImageNamed:(NSString *)imageName {
    return [UIImage imageNamed:imageName cornerRadius:defaultCornerRadius];
}

- (UIImage *)resizableImageWithCornerRadius:(CGFloat)cornerRidus {
    return [self resizableImageWithCapInsets:UIEdgeInsetsMake(cornerRidus, cornerRidus, cornerRidus, cornerRidus)
                                resizingMode:UIImageResizingModeStretch];
}

- (UIImage *)resizableImage {
    return [self resizableImageWithCornerRadius:defaultCornerRadius];
}

@end

@implementation UIImage (Redrawing)

- (UIImage *)redrawingWithTintColor:(UIColor *)tintColor {
    CGRect imageBounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIGraphicsBeginImageContextWithOptions(self.size, false, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, tintColor.CGColor);
    CGContextFillRect(context, imageBounds);
    [self drawInRect:imageBounds blendMode:kCGBlendModeDestinationIn alpha:1.0];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

@implementation UIImage (ButtonBackgroundImage)

+ (UIImage *)backgroundImageWithColor:(UIColor *)color {
    CGRect imageBounds = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(imageBounds.size, false, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, imageBounds);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)backgroundImageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRidus {
    CGRect imageBounds = CGRectMake(0, 0, (cornerRidus + 1) * 2, (cornerRidus + 1) * 2);
    UIGraphicsBeginImageContextWithOptions(imageBounds.size, false, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    UIBezierPath *roundRect = [UIBezierPath bezierPathWithRoundedRect:imageBounds cornerRadius:cornerRidus];
    CGContextAddPath(context, roundRect.CGPath);
    CGContextFillPath(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [image resizableImageWithCornerRadius:cornerRidus];
}

+ (UIImage *)backgroundStrokeImageWithColor:(UIColor *)color {
//    CGRect imageBounds = CGRectMake(0, 0, 10, 10);
//    CGRect innerBounds = CGRectMake(defaultLineWidth/4, defaultLineWidth/4, 10 - defaultLineWidth/2, 10 - defaultLineWidth/2);
//    UIGraphicsBeginImageContextWithOptions(imageBounds.size, false, [UIScreen mainScreen].scale);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(context, defaultLineWidth/2);
//    CGContextSetStrokeColorWithColor(context, color.CGColor);
//    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
//    CGContextStrokeRect(context, innerBounds);
//    CGContextFillRect(context, innerBounds);
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return [image resizableImageWithCornerRadius:defaultLineWidth/2];
    return [UIImage backgroundStrokeImageWithColor:color cornerRadius:0];
}

+ (UIImage *)backgroundStrokeImageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRidus {
    CGRect imageBounds = CGRectMake(0, 0, cornerRidus * 2 + 10, cornerRidus * 2 + 10);
    CGRect innerBounds = CGRectMake(defaultLineWidth/4, defaultLineWidth/4, cornerRidus * 2 + 10 - defaultLineWidth/2, cornerRidus * 2 + 10 - defaultLineWidth/2);
    UIGraphicsBeginImageContextWithOptions(imageBounds.size, false, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, defaultLineWidth/2);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    UIBezierPath *roundRect = [UIBezierPath bezierPathWithRoundedRect:innerBounds cornerRadius:cornerRidus];
    CGContextAddPath(context, roundRect.CGPath);
    CGContextStrokePath(context);
    CGContextFillPath(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [image resizableImageWithCornerRadius:cornerRidus + defaultLineWidth/2];
}

@end
