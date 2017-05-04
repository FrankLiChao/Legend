//
//  EvaluationFooterViewCell.m
//  LegendWorld
//
//  Created by wenrong on 16/11/16.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "EvaluationFooterViewCell.h"

@implementation EvaluationFooterViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.evaluationBtn.layer.cornerRadius = 6;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)evaluationAct:(UIButton *)sender {
    [self.delegate clickEvaluationSubmitAct];
}

@end
