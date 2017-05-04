//
//  IncomeContentTableCell.m
//  LegendWorld
//
//  Created by Frank on 2016/11/7.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "IncomeContentTableCell.h"

@implementation IncomeContentTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _logoIm = [UIImageView new];
        [_logoIm setImage:placeSquareImg];
        _logoIm.layer.cornerRadius = 35*widthRate/2;
        _logoIm.layer.masksToBounds = YES;
        [_logoIm setImage:imageWithName(@"mine_zhitui")];
        [self.contentView addSubview:_logoIm];
        
        _logoIm.sd_layout
        .leftSpaceToView(self.contentView,15*widthRate)
        .centerYEqualToView(self.contentView)
        .widthIs(35*widthRate)
        .heightEqualToWidth();
        
        _nameLab = [UILabel new];
        _nameLab.text = @"直推收益";
        _nameLab.textColor = contentTitleColorStr1;
        _nameLab.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_nameLab];
        
        _nameLab.sd_layout
        .leftSpaceToView(_logoIm,15*widthRate)
        .rightSpaceToView(self.contentView,15*widthRate)
        .topSpaceToView(self.contentView,15*widthRate)
        .heightIs(20*widthRate);
        
        _moneyLab = [UILabel new];
        _moneyLab.text = @"12.50";
        _moneyLab.textColor = mainColor;
        _moneyLab.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_moneyLab];
        
        _moneyLab.sd_layout
        .leftEqualToView(_nameLab)
        .bottomSpaceToView(self.contentView,10*widthRate)
        .rightSpaceToView(self.contentView,50*widthRate)
        .heightIs(20*widthRate);
        
        _arrowIm = [UIImageView new];
        [_arrowIm setImage:imageWithName(@"rightjiantou")];
        [self.contentView addSubview:_arrowIm];
        
        _arrowIm.sd_layout
        .rightSpaceToView(self.contentView,10*widthRate)
        .widthIs(12*widthRate)
        .heightEqualToWidth()
        .centerYEqualToView(self.contentView);
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 70*widthRate-0.5, DeviceMaxWidth, 0.5)];
        lineView.backgroundColor = tableDefSepLineColor;
        [self.contentView addSubview:lineView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
