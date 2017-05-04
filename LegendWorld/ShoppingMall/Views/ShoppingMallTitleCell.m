//
//  ShoppingMallTitleCell.m
//  LegendWorld
//
//  Created by wenrong on 16/10/28.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "ShoppingMallTitleCell.h"

@implementation ShoppingMallTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected == YES) {
        self.orangeLabel.hidden = NO;
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    else{
        self.orangeLabel.hidden = YES;
        self.contentView.backgroundColor = [UIColor backgroundColor];
    }
    // Configure the view for the selected state
}

@end
