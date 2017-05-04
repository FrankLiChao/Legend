//
//  AgreeRefundTableViewCell.m
//  LegendWorld
//
//  Created by Frank on 2016/11/11.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "AgreeRefundTableViewCell.h"

@implementation AgreeRefundTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self initFrameView];
}

-(void)initFrameView{
    _statusLab.textColor = contentTitleColorStr1;
    _contentLab.textColor = contentTitleColorStr1;
    self.contentLab.text = @"如果商家同意：申请将达成并需要您退货给商家\n\n如果商家拒绝：将需要您修改退款申请\n\n如果商家未处理：超过02天23时则申请达成并为您退款";
    [_modefyBtn setTitleColor:contentTitleColorStr1 forState:UIControlStateNormal];
    _modefyBtn.layer.borderWidth = 1;
    _modefyBtn.layer.borderColor = contentTitleColorStr2.CGColor;
    
    [_applyServerBtn setTitleColor:contentTitleColorStr1 forState:UIControlStateNormal];
    _applyServerBtn.layer.borderWidth = 1;
    _applyServerBtn.layer.borderColor = contentTitleColorStr2.CGColor;
    
    [_revokBtn setTitleColor:contentTitleColorStr1 forState:UIControlStateNormal];
    _revokBtn.layer.borderWidth = 1;
    _revokBtn.layer.borderColor = contentTitleColorStr2.CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
