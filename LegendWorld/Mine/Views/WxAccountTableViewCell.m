//
//  WxAccountTableViewCell.m
//  LegendWorld
//
//  Created by Frank on 2016/12/16.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "WxAccountTableViewCell.h"

@implementation WxAccountTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectBtn.selected = selected;
}

@end
