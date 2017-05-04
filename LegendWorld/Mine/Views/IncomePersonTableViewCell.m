//
//  IncomePersonTableViewCell.m
//  LegendWorld
//
//  Created by Frank on 2016/11/8.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "IncomePersonTableViewCell.h"

@implementation IncomePersonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _nameTitleLab = [UILabel new];
        _nameTitleLab.text = @"购买人";
        _nameTitleLab.textColor = contentTitleColorStr1;
        _nameTitleLab.font = [UIFont systemFontOfSize:15];
        [self addSubview:_nameTitleLab];
        
        _nameTitleLab.sd_layout
        .leftSpaceToView(self,15*widthRate)
        .topSpaceToView(self,0)
        .heightIs(40)
        .widthIs(200);
        
        _nameLab = [UILabel new];
        _nameLab.text = @"王尼玛";
        _nameLab.textColor = contentTitleColorStr2;
        _nameLab.font = [UIFont systemFontOfSize:13];
        _nameLab.textAlignment = NSTextAlignmentRight;
        [self addSubview:_nameLab];
        
        _nameLab.sd_layout
        .rightSpaceToView(self,15*widthRate)
        .yIs(0)
        .widthIs(60)
        .heightIs(40);
        
        _headIm = [UIImageView new];
        [_headIm setImage:defaultUserHead];
        _headIm.layer.cornerRadius = 25/2;
        _headIm.layer.masksToBounds = YES;
        [self addSubview:_headIm];
        
        _headIm.sd_layout
        .rightSpaceToView(_nameLab,2)
        .centerYEqualToView(self)
        .widthIs(25)
        .heightEqualToWidth();
        
        _detailLab = [UILabel new];
        _detailLab.hidden = YES;
        _detailLab.textColor = contentTitleColorStr1;
        _detailLab.font = [UIFont systemFontOfSize:13];
        _detailLab.textAlignment = NSTextAlignmentRight;
        _detailLab.numberOfLines = 2;
        [self addSubview:_detailLab];
        
        _detailLab.sd_layout
        .rightSpaceToView(self,15*widthRate)
        .topSpaceToView(self,0)
        .widthIs(250)
        .heightIs(40);
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40-0.5, DeviceMaxWidth, 0.5)];
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
