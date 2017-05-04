//
//  IncomeDetailTableVCell.m
//  LegendWorld
//
//  Created by Frank on 2016/11/8.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "IncomeDetailTableVCell.h"

@implementation IncomeDetailTableVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _nameLab = [UILabel new];
        _nameLab.text = @"商品";
        _nameLab.textColor = contentTitleColorStr1;
        _nameLab.font = [UIFont systemFontOfSize:15];
        [self addSubview:_nameLab];
        
        _nameLab.sd_layout
        .leftSpaceToView(self,15*widthRate)
        .topSpaceToView(self,0)
        .widthIs(200)
        .heightIs(40);
        
        _detailLab = [UILabel new];
        _detailLab.text = @"商品名称商品名称商品名称商品名称商品名称商品名称商品名称商品名称";
        _detailLab.numberOfLines = 2;
        _detailLab.textColor = contentTitleColorStr2;
        _detailLab.textAlignment = NSTextAlignmentRight;
        _detailLab.font = [UIFont systemFontOfSize:13];
        [self addSubview:_detailLab];
        
        _detailLab.sd_layout
        .rightSpaceToView(self,15*widthRate)
        .topEqualToView(self)
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
