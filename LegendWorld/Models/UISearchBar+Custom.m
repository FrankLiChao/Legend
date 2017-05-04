//
//  UISearchBar+Custom.m
//  LegendWorld
//
//  Created by Tsz on 2016/11/2.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "UISearchBar+Custom.h"

@implementation UISearchBar (Custom)

- (void)setTextColor:(UIColor *)color {
    for (UIView *sub in self.subviews) {
        for (UIView *subSub in sub.subviews) {
            if ([subSub isKindOfClass:[UITextField class]]) {
                UITextField *tf = (UITextField *)subSub;
                tf.textColor = color;
                return;
            }
        }
    }
}

- (UIColor *)textColor {
    for (UIView *sub in self.subviews) {
        for (UIView *subSub in sub.subviews) {
            if ([subSub isKindOfClass:[UITextField class]]) {
                UITextField *tf = (UITextField *)subSub;
                return tf.textColor;
            }
        }
    }
    return nil;
}


@end
