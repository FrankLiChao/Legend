//
//  ChooseReasonCell.m
//  LegendWorld
//
//  Created by wenrong on 16/11/9.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "ChooseReasonCell.h"

@implementation ChooseReasonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if (DeviceMaxWidth == 320) {
        UIEdgeInsets insets = UIEdgeInsetsMake(0, 270, 0, 0);
        [self.chooseBtn setImageEdgeInsets:insets];
    }
    self.chooseBtn.layer.borderWidth = 1;
    self.chooseBtn.layer.borderColor = [UIColor seperateColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)chooseAct:(UIButton *)sender {
    [self.delegate clickChooseReasonCell:sender];
}

@end
