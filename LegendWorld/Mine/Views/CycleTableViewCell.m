//
//  CycleTableViewCell.m
//  LegendWorld
//
//  Created by Frank on 2016/11/8.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "CycleTableViewCell.h"

@implementation CycleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _nameLab = [UILabel new];
        _nameLab.text = @"分红周期";
        _nameLab.textColor = contentTitleColorStr1;
        _nameLab.font = [UIFont systemFontOfSize:15];
        [self addSubview:_nameLab];
        
        _nameLab.sd_layout
        .leftSpaceToView(self,15*widthRate)
        .widthIs(250*widthRate)
        .topSpaceToView(self,0)
        .heightIs(40*widthRate);
        
        _tipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tipBtn setImage:imageWithName(@"question_image") forState:UIControlStateNormal];
        [self addSubview:_tipBtn];
        
        _tipBtn.sd_layout
        .rightSpaceToView(self,10*widthRate)
        .topSpaceToView(self,10*widthRate)
        .widthIs(20*widthRate)
        .heightEqualToWidth();
        
        _detailLab = [UILabel new];
        _detailLab.text = @"200.00元";
        _detailLab.textColor = mainColor;
        _detailLab.textAlignment = NSTextAlignmentRight;
        _detailLab.font = [UIFont systemFontOfSize:13];
        [self addSubview:_detailLab];
        
        _detailLab.sd_layout
        .rightSpaceToView(_tipBtn,2)
        .topSpaceToView(self,0)
        .widthIs(100)
        .heightIs(40*widthRate);
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40*widthRate-0.5, DeviceMaxWidth, 0.5)];
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
