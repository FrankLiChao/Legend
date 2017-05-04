//
//  PaySelectTableViewCell.m
//  LegendWorld
//
//  Created by 文荣 on 16/9/14.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "PaySelectTableViewCell.h"

@interface  PaySelectTableViewCell()

@end
@implementation PaySelectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectedBtn.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self.selectedBtn setSelected:selected];
}


@end
