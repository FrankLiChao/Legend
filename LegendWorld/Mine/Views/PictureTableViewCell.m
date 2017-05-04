//
//  PictureTableViewCell.m
//  LegendWorld
//
//  Created by Frank on 2016/11/17.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "PictureTableViewCell.h"

@implementation PictureTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameHight.constant = 55*widthRate;
    self.imageWith.constant = 70*widthRate;
    self.imageHight.constant = 70*widthRate;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
