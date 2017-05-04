//
//  SellerShopHeaderView.m
//  LegendWorld
//
//  Created by Tsz on 2016/11/2.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "SellerShopHeaderView.h"

@implementation SellerShopHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.collectBtn.layer.borderWidth = 0.5;
    self.collectBtn.layer.borderColor = [UIColor whiteColor].CGColor;
}

@end
