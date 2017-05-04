//
//  MyWalletTableViewCell.m
//  LegendWorld
//
//  Created by ios-dev-01 on 16/9/19.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "MyWalletTableViewCell.h"

@implementation MyWalletTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        _typeImage = [UIImageView new];
        [self addSubview:_typeImage];
        
        _typeImage.sd_layout
        .centerYEqualToView(self)
        .leftSpaceToView(self,15*widthRate)
        .widthIs(35*widthRate)
        .heightEqualToWidth();
        
        _name = [UILabel new];
        _name.text = @"购买商品";
        _name.textColor = contentTitleColorStr;
        _name.font = [UIFont systemFontOfSize:15];
        [self addSubview:_name];
        
        _name.sd_layout
        .leftSpaceToView(self,65*widthRate)
        .topSpaceToView(self,10*widthRate)
        .widthIs(250*widthRate)
        .heightIs(20*widthRate);
        
        _data = [UILabel new];
        _data.text = @"2015.09.05 11:39:19";
        _data.font = [UIFont systemFontOfSize:14];
        _data.textColor = contentTitleColorStr1;
        [self addSubview:_data];
        
        _data.sd_layout
        .leftSpaceToView(self,65*widthRate)
        .topSpaceToView(_name,10*widthRate)
        .widthIs(250*widthRate)
        .heightIs(20*widthRate);
        
        _money = [UILabel new];
        _money.text = @"-99";
        _money.font = [UIFont systemFontOfSize:15];
        _money.textColor = contentTitleColorStr;
        _money.textAlignment = NSTextAlignmentRight;
        [self addSubview:_money];
        
        _money.sd_layout
        .rightSpaceToView(self,15*widthRate)
        .topSpaceToView(self,10*widthRate)
        .widthIs(100*widthRate)
        .heightIs(20*widthRate);
        
        _moneyType = [UILabel new];
        _moneyType.text = @"支出";
        _moneyType.font = [UIFont systemFontOfSize:14];
        _moneyType.textColor = contentTitleColorStr1;
        _moneyType.textAlignment = NSTextAlignmentRight;
        [self addSubview:_moneyType];
        
        _moneyType.sd_layout
        .rightSpaceToView(self,15*widthRate)
        .topSpaceToView(_money,10*widthRate)
        .widthIs(100*widthRate)
        .heightIs(20*widthRate);
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(10*widthRate, 70*widthRate-0.5, DeviceMaxWidth-10*widthRate, 0.5)];
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
