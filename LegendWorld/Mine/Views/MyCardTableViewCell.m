//
//  MyCardTableViewCell.m
//  LegendWorld
//
//  Created by Frank on 2016/10/31.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "MyCardTableViewCell.h"

@implementation MyCardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _logoIm = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 50, 50)];
        [self addSubview:_logoIm];
        
        _nameLab = [UILabel new];
        _nameLab.text = @"中国银行";
        _nameLab.textColor = contentTitleColorStr1;
        _nameLab.font = [UIFont systemFontOfSize:16];
        [self addSubview:_nameLab];
        
        _nameLab.sd_layout
        .leftSpaceToView(_logoIm,15*widthRate)
        .rightSpaceToView(self,90)
        .topSpaceToView(self,15)
        .heightIs(20);
        
        _detailLab = [UILabel new];
        _detailLab.text = @"尾号9572";
        _detailLab.textColor = contentTitleColorStr2;
        _detailLab.font = [UIFont systemFontOfSize:13];
        [self addSubview:_detailLab];
        
        _detailLab.sd_layout
        .leftEqualToView(_nameLab)
        .bottomSpaceToView(self,15)
        .widthRatioToView(_nameLab,1)
        .heightIs(20);
        
        _addCardLab = [UILabel new];
        _addCardLab.text = @"添加银行卡";
        _addCardLab.textColor = contentTitleColorStr2;
        _addCardLab.hidden = YES;
        _addCardLab.font = [UIFont systemFontOfSize:16];
        [self addSubview:_addCardLab];
        
        _addCardLab.sd_layout
        .leftEqualToView(_nameLab)
        .centerYEqualToView(self)
        .widthRatioToView(_nameLab,1)
        .heightIs(20);
    
        _arrowIm = [UIImageView new];
        [_arrowIm setImage:imageWithName(@"rightjiantou")];
        [self addSubview:_arrowIm];
        
        _arrowIm.sd_layout
        .rightSpaceToView(self,15)
        .centerYEqualToView(self)
        .widthIs(12)
        .heightIs(12);
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 80-0.5, DeviceMaxWidth-10, 0.5)];
        _lineView.backgroundColor = tableDefSepLineColor;
        [self addSubview:_lineView];
    }
    return self;
}

@end
