//
//  IncomeTitleTableViewCell.m
//  LegendWorld
//
//  Created by Frank on 2016/11/8.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "IncomeTitleTableViewCell.h"

@implementation IncomeTitleTableViewCell

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
        .centerXEqualToView(self)
        .widthIs(50*widthRate)
        .heightEqualToWidth()
        .topSpaceToView(self,20*widthRate);
        
        _moneyLab = [UILabel new];
        _moneyLab.text = @"12.5";
        _moneyLab.font = [UIFont systemFontOfSize:24];
        _moneyLab.textColor = contentTitleColorStr1;
        _moneyLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_moneyLab];
        
        _moneyLab.sd_layout
        .centerXEqualToView(self)
        .heightIs(20*widthRate)
        .topSpaceToView(_headIm,15*widthRate)
        .widthIs(200);
        
        _statusLab = [UILabel new];
        _statusLab.text = @"已到账";
        _statusLab.textColor = contentTitleColorStr1;
        _statusLab.font = [UIFont systemFontOfSize:15];
        _statusLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_statusLab];
        
        _statusLab.sd_layout
        .centerXEqualToView(self)
        .bottomSpaceToView(self,20*widthRate)
        .widthIs(250)
        .heightIs(20*widthRate);
        
        _lineView = [[UILabel alloc] initWithFrame:CGRectMake(0, 160*widthRate-0.5, DeviceMaxWidth, 0.5)];
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
