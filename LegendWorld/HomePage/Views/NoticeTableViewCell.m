//
//  NoticeTableViewCell.m
//  LegendWorld
//
//  Created by Frank on 2016/11/1.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "NoticeTableViewCell.h"

@implementation NoticeTableViewCell

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
        [_logoIm setImage:defaultUserHead];
        [self addSubview:_logoIm];
        
        _logoIm.sd_layout
        .leftSpaceToView(self,10)
        .centerYEqualToView(self)
        .widthIs(45)
        .heightEqualToWidth();
        
//        _pointLab = [UILabel new];
//        _pointLab.layer
//        [self addSubview:_pointLab];
        
        _nameLab = [UILabel new];
        _nameLab.text = @"系统消息";
        _nameLab.textColor = contentTitleColorStr;
        _nameLab.font = [UIFont systemFontOfSize:16];
        [self addSubview:_nameLab];
        
        _nameLab.sd_layout
        .leftSpaceToView(_logoIm,15)
        .rightSpaceToView(self,100)
        .topSpaceToView(self,15)
        .heightIs(20);
        
        _detailLab = [UILabel new];
        _detailLab.text = @"9积分到账了！再送你每天领5积分的机会，进入查看详情";
        _detailLab.textColor = contentTitleColorStr1;
        _detailLab.font = [UIFont systemFontOfSize:13];
        [self addSubview:_detailLab];
        
        _detailLab.sd_layout
        .leftEqualToView(_nameLab)
        .rightSpaceToView(self,15)
        .topSpaceToView(_nameLab,8)
        .heightIs(20);
        
        _dataLab = [UILabel new];
        _dataLab.text = @"今天 14：06";
        _dataLab.textColor = contentTitleColorStr2;
        _dataLab.textAlignment = NSTextAlignmentRight;
        _dataLab.font = [UIFont systemFontOfSize:16];
        [self addSubview:_dataLab];
        
        _dataLab.sd_layout
        .rightSpaceToView(self,10)
        .topEqualToView(_nameLab)
        .heightIs(20)
        .widthIs(100);
        
        _lineView = [UIView new];
        _lineView.backgroundColor = tableDefSepLineColor;
        [self addSubview:_lineView];
        
        _lineView.sd_layout
        .leftSpaceToView(self,10)
        .rightSpaceToView(self,0)
        .heightIs(0.5)
        .topSpaceToView(self,70-0.5);
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
