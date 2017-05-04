//
//  BaseTextField.m
//  LegendWorld
//
//  Created by wenrong on 16/9/28.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "BaseTextField.h"

@implementation BaseTextField

- (void)drawPlaceholderInRect:(CGRect)rect {
    // 计算占位文字的 Size 
    CGSize placeholderSize = [self.placeholder sizeWithAttributes:
                              @{NSFontAttributeName : self.font}];
    
    [self.placeholder drawInRect:CGRectMake(0, (rect.size.height - placeholderSize.height)/2, rect.size.width, rect.size.height) withAttributes:
     @{NSForegroundColorAttributeName : [UIColor colorFromHexRGB:@"DDDDDD"],
       NSFontAttributeName : self.font}];
}

@end
