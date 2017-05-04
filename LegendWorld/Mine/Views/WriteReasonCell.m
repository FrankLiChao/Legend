//
//  WriteReasonCell.m
//  LegendWorld
//
//  Created by wenrong on 16/11/9.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "WriteReasonCell.h"

@implementation WriteReasonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.writeReasonTF.layer.borderColor = [UIColor seperateColor].CGColor;
    self.writeReasonTF.layer.borderWidth = 1;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
