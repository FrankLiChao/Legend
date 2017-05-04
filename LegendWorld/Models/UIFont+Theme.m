//
//  UIFont+Theme.m
//  LegendWorld
//
//  Created by Tsz on 2016/11/2.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "UIFont+Theme.h"

@implementation UIFont (Theme)

+ (UIFont *)titleTextFont {
    return [UIFont boldSystemFontOfSize:15];
}

+ (UIFont *)bodyTextFont {
    return [UIFont systemFontOfSize:14];
}

+ (UIFont *)noteTextFont {
    return [UIFont systemFontOfSize:13];
}

+ (UIFont *)buttonTextFont {
    return [UIFont systemFontOfSize:14];
}

@end
