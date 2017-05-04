//
//  UIColor+Theme.m
//  LegendWorld
//
//  Created by Tsz on 2016/11/2.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "UIColor+Theme.h"

@implementation UIColor (Theme)

+ (UIColor *)colorFromHexRGB:(NSString *)inColorString {
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString) {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void)[scanner scanHexInt:&colorCode];
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode);
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}

+ (UIColor *)themeColor {
    return [UIColor colorFromHexRGB:@"e3383e"];
}

+ (UIColor *)titleTextColor {
    return [UIColor colorFromHexRGB:@"191919"];
}

+ (UIColor *)bodyTextColor {
    return [UIColor colorFromHexRGB:@"464646"];
}

+ (UIColor *)noteTextColor {
    return [UIColor colorFromHexRGB:@"9b9b9b"];
}

+ (UIColor *)seperateColor {
    return [UIColor colorFromHexRGB:@"d9d9d9"];
}

+ (UIColor *)backgroundColor {
    return [UIColor colorFromHexRGB:@"f5f5f5"];
}

+ (UIColor *)sectionColor {
    return [UIColor colorFromHexRGB:@"f1f2f6"];
}

@end
