//
//  MyOrderTableViewCell.m
//  LegendWorld
//
//  Created by Tsz on 2016/11/10.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "MyOrderTableViewCell.h"

@implementation MyOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.seeDetailBtn setBackgroundImage:[UIImage backgroundStrokeImageWithColor:[UIColor themeColor]] forState:UIControlStateNormal];
    [self.seeDetailBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)btnAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(myOrderCell:didClickedActionBtn:)]) {
        [self.delegate myOrderCell:self didClickedActionBtn:sender];
    }
}

@end
