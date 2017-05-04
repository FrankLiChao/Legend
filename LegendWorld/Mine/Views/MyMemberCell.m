//
//  MyMemberCell.m
//  LegendWorld
//
//  Created by wenrong on 16/9/23.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "MyMemberCell.h"

@implementation MyMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.memberIconIma.layer.cornerRadius = 6;
    self.memberIconIma.layer.masksToBounds = YES;
    self.changeMemberBtn.layer.borderWidth = 1;
    self.changeMemberBtn.layer.borderColor = [UIColor noteTextColor].CGColor;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)changeMemberAct:(UIButton *)sender {
    [self.delegate changeMemberAct:self.tag];
}
- (IBAction)callPersonAct:(UIButton *)sender {
    [self.delegate callMemberAct:self.tag];
}
@end
