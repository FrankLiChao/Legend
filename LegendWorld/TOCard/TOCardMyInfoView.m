//
//  TOCardMyInfoView.m
//  LegendWorld
//
//  Created by Tsz on 2016/11/28.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "TOCardMyInfoView.h"

@implementation TOCardMyInfoView


- (void)awakeFromNib {
    [super awakeFromNib];
    self.avatar.layer.cornerRadius = 40;
    self.avatar.layer.masksToBounds = YES;
}

@end
