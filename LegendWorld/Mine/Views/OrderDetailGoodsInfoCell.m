//
//  OrderDetailGoodsInfoCell.m
//  LegendWorld
//
//  Created by Tsz on 2016/11/14.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "OrderDetailGoodsInfoCell.h"

@implementation OrderDetailGoodsInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor clearColor];
    self.actionBtn.layer.borderColor = [UIColor bodyTextColor].CGColor;
    self.actionBtn.layer.borderWidth = 0.5;
    [self.actionBtn setTitleColor:[UIColor bodyTextColor] forState:UIControlStateNormal];
//    [self.actionBtn setBackgroundImage:[UIImage backgroundStrokeImageWithColor:[UIColor bodyTextColor]] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
