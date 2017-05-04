//
//  IncomeTitleTabCell.m
//  LegendWorld
//
//  Created by Frank on 2016/11/7.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "IncomeTitleTabCell.h"

@implementation IncomeTitleTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _headIm = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10*widthRate, 75*widthRate, 75*widthRate)];
        [_headIm setImage:defaultUserHead];
        _headIm.layer.cornerRadius = 75*widthRate/2;
        _headIm.layer.masksToBounds = YES;
        [self.contentView addSubview:_headIm];
        
        _imagaTag = [UIImageView new];
        [_imagaTag setImage:imageWithName(@"mine_grade_v1")];
        _imagaTag.layer.cornerRadius = 13*widthRate;
        _imagaTag.layer.masksToBounds = YES;
        _imagaTag.userInteractionEnabled = YES;
        _imagaTag.layer.borderWidth = 2.5*widthRate;
        _imagaTag.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.contentView addSubview:_imagaTag];
        
        _imagaTag.sd_layout
        .rightEqualToView(_headIm)
        .bottomEqualToView(_headIm)
        .widthIs(26*widthRate)
        .heightEqualToWidth();
    
        _nameLab = [UILabel new];
        _nameLab.text = @"唐志强";
        _nameLab.textColor = contentTitleColorStr1;
        _nameLab.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_nameLab];
        
        _nameLab.sd_layout
        .leftSpaceToView(_headIm,15*widthRate)
        .rightSpaceToView(self.contentView,15*widthRate)
        .topSpaceToView(self.contentView,22*widthRate)
        .heightIs(20*widthRate);
        
        _todayIncome = [UILabel new];
        _todayIncome.text = @"今日收益：12.50";
        _todayIncome.textColor = contentTitleColorStr2;
        _todayIncome.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_todayIncome];
        
        _todayIncome.sd_layout
        .leftEqualToView(_nameLab)
        .topSpaceToView(_nameLab,15*widthRate)
        .widthIs(150*widthRate)
        .heightIs(20*widthRate);
        
        _totalIncome = [UILabel new];
        _totalIncome.text = @"总收益：5365.12";
        _totalIncome.font = [UIFont systemFontOfSize:13];
        _totalIncome.textColor = contentTitleColorStr2;
        _totalIncome.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_totalIncome];
        
        _totalIncome.sd_layout
        .rightSpaceToView(self.contentView,15*widthRate)
        .topEqualToView(_todayIncome)
        .widthIs(150*widthRate)
        .heightIs(20*widthRate);
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = viewColor;
        [self.contentView addSubview:lineView];
        
        lineView.sd_layout
        .xIs(0)
        .rightSpaceToView(self.contentView,0)
        .topSpaceToView(self.contentView,95*widthRate)
        .heightIs(10*widthRate);
        
        UIView *lineV = [UIView new];
        lineV.backgroundColor = tableDefSepLineColor;
        [self.contentView addSubview:lineV];
        
        lineV.sd_layout
        .topSpaceToView(lineView,20*widthRate)
        .heightIs(50*widthRate)
        .centerXEqualToView(self.contentView)
        .widthIs(0.5);
        
        UILabel *goOnLab = [UILabel new];
        goOnLab.text = @"进行中的收益";
        goOnLab.textColor = contentTitleColorStr1;
        goOnLab.font = [UIFont systemFontOfSize:16];
        goOnLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:goOnLab];
        
        goOnLab.sd_layout
        .leftSpaceToView(self.contentView,15*widthRate)
        .rightSpaceToView(lineV,15*widthRate)
        .heightIs(20*widthRate)
        .topSpaceToView(lineView,20*widthRate);
        
        _goonMoney = [UILabel new];
        _goonMoney.text = @"12.50";
        _goonMoney.textColor = mainColor;
        _goonMoney.font = [UIFont systemFontOfSize:24];
        _goonMoney.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_goonMoney];
        
        _goonMoney.sd_layout
        .centerXEqualToView(goOnLab)
        .topSpaceToView(goOnLab,15*widthRate)
        .widthIs(DeviceMaxWidth/2-30*widthRate)
        .heightIs(20);
        
        _goOnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_goOnBtn];
        _goOnBtn.sd_layout
        .leftSpaceToView(self.contentView,0)
        .widthIs(DeviceMaxWidth/2)
        .topSpaceToView(lineView,0)
        .heightIs(90*widthRate);
        
        UILabel *waitLab = [UILabel new];
        waitLab.text = @"待分红收益";
        waitLab.textColor = contentTitleColorStr1;
        waitLab.font = [UIFont systemFontOfSize:16];
        waitLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:waitLab];
        
        waitLab.sd_layout
        .leftSpaceToView(lineV,15*widthRate)
        .rightSpaceToView(self.contentView,15*widthRate)
        .heightIs(20*widthRate)
        .topSpaceToView(lineView,20*widthRate);
        
        _waitMoney = [UILabel new];
        _waitMoney.text = @"52.50";
        _waitMoney.textColor = mainColor;
        _waitMoney.font = [UIFont systemFontOfSize:24];
        _waitMoney.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_waitMoney];
        
        _waitMoney.sd_layout
        .centerXEqualToView(waitLab)
        .topSpaceToView(waitLab,15*widthRate)
        .widthIs(DeviceMaxWidth/2-30*widthRate)
        .heightIs(20);
        
        _waiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_waiBtn];
        
        _waiBtn.sd_layout
        .leftSpaceToView(self.contentView,DeviceMaxWidth/2)
        .rightSpaceToView(self.contentView,0)
        .topEqualToView(_goOnBtn)
        .heightIs(90*widthRate);
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
