//
//  DeadlineTableViewCell.m
//  LegendWorld
//
//  Created by Frank on 2016/11/8.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "DeadlineTableViewCell.h"

@implementation DeadlineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 10*widthRate)];
        tempView.backgroundColor = viewColor;
        [self addSubview:tempView];
        
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 10*widthRate-0.5, DeviceMaxWidth, 0.5)];
        lineV.backgroundColor = tableDefSepLineColor;
        [self addSubview:lineV];
        
        _nameLab = [UILabel new];
        _nameLab.text = @"代言截止";
        _nameLab.textColor = contentTitleColorStr2;
        _nameLab.font = [UIFont systemFontOfSize:11];
        [self addSubview:_nameLab];
        
        _nameLab.sd_layout
        .leftSpaceToView(self,15*widthRate)
        .topSpaceToView(tempView,0)
        .widthIs(100)
        .heightIs(30*widthRate);
        
        _detailLab = [CountdownLabel new];
//        _detailLab.text = @"还有32天01：19：08";
//        _detailLab.textColor = contentTitleColorStr2;
//        _detailLab.font = [UIFont systemFontOfSize:11];
//        _detailLab.textAlignment = NSTextAlignmentRight;
        [self addSubview:_detailLab];
        
        _detailLab.sd_layout
        .rightSpaceToView(self,10*widthRate)
        .topSpaceToView(lineV,0)
        .widthIs(200)
        .heightIs(30*widthRate);
        
        _lineView = [[UILabel alloc] initWithFrame:CGRectMake(0, 40*widthRate-0.5, DeviceMaxWidth, 0.5)];
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
