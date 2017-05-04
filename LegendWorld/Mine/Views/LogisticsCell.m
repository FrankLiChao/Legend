//
//  LogisticsCell.m
//  LegendWorld
//
//  Created by wenrong on 16/11/7.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "LogisticsCell.h"

@implementation LogisticsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.midLab.layer.cornerRadius = 5;
    self.midLab.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
