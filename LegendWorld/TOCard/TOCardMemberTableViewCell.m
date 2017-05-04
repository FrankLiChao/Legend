//
//  TOCardMemberTableViewCell.m
//  LegendWorld
//
//  Created by Tsz on 2016/11/28.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "TOCardMemberTableViewCell.h"

@implementation TOCardMemberTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.memberImg.layer.cornerRadius = 25;
    self.memberImg.layer.masksToBounds = YES;
    self.exchangeTag.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.exchangeTag.layer.cornerRadius = 25;
    self.exchangeTag.layer.masksToBounds = YES;
    [self.phoneBtn addTarget:self action:@selector(tapPhoneBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.changeBtn setTitle:@"置换" forState:UIControlStateNormal];
    [self.changeBtn setTitleColor:[UIColor noteTextColor] forState:UIControlStateNormal];
    [self.changeBtn setBackgroundImage:[UIImage backgroundStrokeImageWithColor:[UIColor noteTextColor]] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)tapPhoneBtn:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapCallPhoneBtn:)]) {
        [self.delegate didTapCallPhoneBtn:self];
    }
}

@end
