//
//  WithdrawTypeCell.m
//  LegendWorld
//
//  Created by ios-dev-01 on 16/9/19.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "WithdrawTypeCell.h"

@implementation WithdrawTypeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(15*widthRate, 12*widthRate, 41*widthRate, 41*widthRate)];
        [_logoImage setImage:defaultUserHead];
        [self addSubview:_logoImage];
        
        _name = [UILabel new];
        _name.text = @"微信提现";
        _name.textColor = contentTitleColorStr;
        _name.font = [UIFont systemFontOfSize:15];
        [self addSubview:_name];
        
        _name.sd_layout
        .leftSpaceToView(_logoImage,13*widthRate)
        .topSpaceToView(self,14*widthRate)
        .widthIs(200*widthRate)
        .heightIs(18);
        
        _nameDescribe = [UILabel new];
        _nameDescribe.text = @"推荐使用";
        _nameDescribe.textColor = contentTitleColorStr1;
        _nameDescribe.font = [UIFont systemFontOfSize:13];
        [self addSubview:_nameDescribe];
        
        _nameDescribe.sd_layout
        .leftEqualToView(_name)
        .topSpaceToView(_name,5*widthRate)
        .widthIs(200*widthRate)
        .heightIs(18);
        
        _arrow = [UIImageView new];
        [_arrow setImage:imageWithName(@"rightjiantou")];
        [self addSubview:_arrow];
        
        _arrow.sd_layout
        .rightSpaceToView(self,15*widthRate)
        .centerYEqualToView(self)
        .widthIs(12)
        .heightEqualToWidth();
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 65*widthRate-0.5, DeviceMaxWidth, 0.5)];
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
