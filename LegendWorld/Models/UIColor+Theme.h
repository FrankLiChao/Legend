//
//  UIColor+Theme.h
//  LegendWorld
//
//  Created by Tsz on 2016/11/2.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Theme)

+ (UIColor *)colorFromHexRGB:(NSString *)inColorString;

+ (UIColor *)themeColor;

+ (UIColor *)titleTextColor;

+ (UIColor *)bodyTextColor;

+ (UIColor *)noteTextColor;

+ (UIColor *)seperateColor;

+ (UIColor *)backgroundColor;

+ (UIColor *)sectionColor;

@end
