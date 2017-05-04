//
//  SetQuitCell.m
//  LegendWorld
//
//  Created by wenrong on 16/9/27.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "SetQuitCell.h"

@implementation SetQuitCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _quitBtn.layer.cornerRadius = 6;
    _quitBtn.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)quitAct:(UIButton *)sender {
    [self.delegate quitAct];
}
@end
