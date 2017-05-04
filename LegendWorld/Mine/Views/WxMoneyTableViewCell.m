//
//  WxMoneyTableViewCell.m
//  LegendWorld
//
//  Created by Frank on 2016/12/16.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "WxMoneyTableViewCell.h"

@implementation WxMoneyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = viewColor;
    self.sureBtn.layer.cornerRadius = 6;
    self.sureBtn.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
