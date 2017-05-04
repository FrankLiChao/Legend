//
//  RecordTableViewCell.m
//  LegendWorld
//
//  Created by ios-dev-01 on 16/9/19.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "RecordTableViewCell.h"

@implementation RecordTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _name = [UILabel new];
        _name.text = @"微信提现";
        _name.textColor = contentTitleColorStr;
        _name.font = [UIFont systemFontOfSize:15];
        [self addSubview:_name];
        
        _name.sd_layout
        .leftSpaceToView(self,10*widthRate)
        .topSpaceToView(self,10)
        .widthIs(200)
        .heightIs(20);
        
        _statusLab = [UILabel new];
        _statusLab.text = @"处理中";
        _statusLab.textColor = mainColor;
        _statusLab.font = [UIFont systemFontOfSize:13];
        [self addSubview:_statusLab];
        
        _statusLab.sd_layout
        .leftSpaceToView(self,10*widthRate)
        .topSpaceToView(_name,8)
        .widthIs(200)
        .heightIs(15);
        
        _data = [UILabel new];
        _data.text = @"2016-09-08 10:26:12";
        _data.textColor = contentTitleColorStr1;
        _data.font = [UIFont systemFontOfSize:13];
        [self addSubview:_data];
        
        _data.sd_layout
        .leftSpaceToView(self,10*widthRate)
        .topSpaceToView(_statusLab,10)
        .widthIs(200)
        .heightIs(20);
        
        _money = [UILabel new];
        _money.text = @"100.00";
        _money.textColor = contentTitleColorStr;
        _money.textAlignment = NSTextAlignmentRight;
        _money.font = [UIFont systemFontOfSize:18];
        [self addSubview:_money];
        
        _money.sd_layout
        .rightSpaceToView(self,10*widthRate)
        .topSpaceToView(self,15*widthRate)
        .widthIs(100)
        .heightIs(20);
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 90-0.5, DeviceMaxWidth, 0.5)];
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
