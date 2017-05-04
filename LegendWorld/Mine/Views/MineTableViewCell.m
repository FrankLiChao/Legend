//
//  MineTableViewCell.m
//  LegendWorld
//
//  Created by ios-dev-01 on 16/9/17.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "MineTableViewCell.h"

@implementation MineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(15*widthRate, 0, 250, 45*widthRate)];
        _nameLab.textColor = contentTitleColorStr;
        _nameLab.font = [UIFont systemFontOfSize:15];
        [self addSubview:_nameLab];
        
        _arrowImage = [UIImageView new];
        [_arrowImage setImage:imageWithName(@"rightjiantou")];
        [self addSubview:_arrowImage];
        
        _arrowImage.sd_layout
        .rightSpaceToView(self,10*widthRate)
        .centerYEqualToView(self)
        .widthIs(12*widthRate)
        .heightIs(12*widthRate);
        
        _deteiLab = [UILabel new];
        _deteiLab.font = [UIFont systemFontOfSize:13];
        _deteiLab.textColor = contentTitleColorStr1;
        _deteiLab.textAlignment = NSTextAlignmentRight;
        [self addSubview:_deteiLab];
        
        _deteiLab.sd_layout
        .rightSpaceToView(_arrowImage,10*widthRate)
        .topSpaceToView(self,0)
        .widthIs(150)
        .heightIs(45*widthRate);
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(10*widthRate, 45*widthRate-0.5, DeviceMaxWidth-20*widthRate, 0.5)];
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
