//
//  ShoppingCartBottomView.m
//  LegendWorld
//
//  Created by Tsz on 2016/11/7.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "ShoppingCartBottomView.h"

@implementation ShoppingCartBottomView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.calculateBtn setBackgroundImage:[UIImage backgroundImageWithColor:[UIColor themeColor]] forState:UIControlStateNormal];
    [self.calculateBtn setBackgroundImage:[UIImage backgroundImageWithColor:[UIColor noteTextColor]] forState:UIControlStateDisabled];
}

@end
