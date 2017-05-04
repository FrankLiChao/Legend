//
//  PayDeteilTableViewCell.m
//  LegendWorld
//
//  Created by ios-dev-01 on 16/9/26.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "PayDeteilTableViewCell.h"

@implementation PayDeteilTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _name = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 0, 70, 40*widthRate)];
        _name.text = @"交易时间";
        _name.textColor = contentTitleColorStr1;
        _name.font = [UIFont systemFontOfSize:15];
        [self addSubview:_name];
        
        _deteil = [UILabel new];
        _deteil.text = @"2016-09-26";
        _deteil.textColor = contentTitleColorStr1;
        _deteil.font = [UIFont systemFontOfSize:15];
        _deteil.textAlignment = NSTextAlignmentRight;
        [self addSubview:_deteil];
        
        _deteil.sd_layout
        .rightSpaceToView(self,10*widthRate)
        .topEqualToView(_name)
        .leftSpaceToView(_name,10*widthRate)
        .heightIs(40*widthRate);
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
