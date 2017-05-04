//
//  downLineTableViewCell.m
//  LegendWorld
//
//  Created by Frank on 2016/11/7.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "downLineTableViewCell.h"

@implementation downLineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _headIm = [UIImageView new];
        [_headIm setImage:defaultUserHead];
        _headIm.layer.cornerRadius = 25*widthRate;
        _headIm.layer.masksToBounds = YES;
        [self addSubview:_headIm];
        
        _headIm.sd_layout
        .leftSpaceToView(self,15*widthRate)
        .topSpaceToView(self,10*widthRate)
        .widthIs(50*widthRate)
        .heightEqualToWidth();
        
        _nameLab = [UILabel new];
        _nameLab.text = @"赵本山";
        _nameLab.textColor = contentTitleColorStr1;
        _nameLab.font = [UIFont systemFontOfSize:16];
        [self addSubview:_nameLab];
        
        _nameLab.sd_layout
        .leftSpaceToView(_headIm,15*widthRate)
        .widthIs(200*widthRate)
        .topSpaceToView(self,17*widthRate)
        .heightIs(20*widthRate);
        
        _phoneLab = [UILabel new];
        _phoneLab.text = @"13258358090";
        _phoneLab.textColor = contentTitleColorStr2;
        _phoneLab.font = [UIFont systemFontOfSize:13];
        [self addSubview:_phoneLab];
        
        _phoneLab.sd_layout
        .leftEqualToView(_nameLab)
        .topSpaceToView(_nameLab,5*widthRate)
        .widthIs(200*widthRate)
        .heightIs(20*widthRate);
        
//        _phoneIm = [UIImageView new];
//        [_phoneIm setImage:imageWithName(@"mine_phone_image")];
//        [self addSubview:_phoneIm];
//        
//        _phoneIm.sd_layout
//        .centerYEqualToView(self)
//        .widthIs(20*widthRate)
//        .heightEqualToWidth()
//        .rightSpaceToView(self,15*widthRate);
        
        _callPhoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_callPhoneBtn setImage:imageWithName(@"mine_phone_image") forState:UIControlStateNormal];
        [self addSubview:_callPhoneBtn];
        
        _callPhoneBtn.sd_layout
        .yIs(0)
        .widthIs(20*widthRate)
        .heightIs(70*widthRate)
        .rightSpaceToView(self,15*widthRate);
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(15*widthRate, 70*widthRate-0.5, DeviceMaxWidth-30*widthRate, 0.5)];
        _lineView.backgroundColor = tableDefSepLineColor;
        [self addSubview:_lineView];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
