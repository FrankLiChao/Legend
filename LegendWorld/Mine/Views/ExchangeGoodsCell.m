//
//  ExchangeGoodsCell.m
//  LegendWorld
//
//  Created by Frank on 2016/11/11.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "ExchangeGoodsCell.h"

@implementation ExchangeGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initFrameView];
}

-(void)initFrameView{
    _statusIm.backgroundColor = [UIColor lightGrayColor];
    _statusLab.textColor = contentTitleColorStr1;
    _contentLab.textColor = contentTitleColorStr1;
    [_sureTakeBtn setTitleColor:contentTitleColorStr1 forState:UIControlStateNormal];
    _sureTakeBtn.layer.borderWidth = 1;
    _sureTakeBtn.layer.borderColor = contentTitleColorStr2.CGColor;
    [_saleAfterBtn setTitleColor:contentTitleColorStr1 forState:UIControlStateNormal];
    _saleAfterBtn.layer.borderWidth = 1;
    _saleAfterBtn.layer.borderColor = contentTitleColorStr2.CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
