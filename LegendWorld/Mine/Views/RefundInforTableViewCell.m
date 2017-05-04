//
//  RefundInforTableViewCell.m
//  LegendWorld
//
//  Created by Frank on 2016/11/14.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "RefundInforTableViewCell.h"

@implementation RefundInforTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lineIm.backgroundColor = tableDefSepLineColor;
    self.resonLab.text = @"送快递放假后设计符合实际打款发货时快捷方式的快捷方式可点击付款时点击发送快递发货时看到就发货速度快解放和读书卡积分换多少";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
