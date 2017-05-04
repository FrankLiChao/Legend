//
//  BillBoardTableViewCell.m
//  LegendWorld
//
//  Created by ios-dev-01 on 16/9/14.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "BillBoardTableViewCell.h"

@implementation BillBoardTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _tagLab = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 10, 20, 20)];
        _tagLab.layer.cornerRadius = 10;
        _tagLab.layer.masksToBounds = YES;
        _tagLab.textColor = [UIColor whiteColor];
        _tagLab.font = [UIFont systemFontOfSize:11];
        _tagLab.textAlignment = NSTextAlignmentCenter;
        _tagLab.backgroundColor = contentTitleColorStr2;
        [self addSubview:_tagLab];
        
        _name = [UILabel new];
        _name.text = @"张三";
        _name.textColor = contentTitleColorStr1;
        _name.font = [UIFont systemFontOfSize:13];
        [self addSubview:_name];
        
        _name.sd_layout
        .leftSpaceToView(_tagLab,DeviceMaxWidth/4-35*widthRate)
        .yIs(0)
        .widthIs(DeviceMaxWidth/4)
        .heightIs(40);
        
//        _phone = [UILabel new];
//        _phone.text = @"132****8090";
//        _phone.textColor = contentTitleColorStr1;
//        _phone.font = [UIFont systemFontOfSize:13];
//        [self addSubview:_phone];
        
//        _phone.sd_layout
//        .leftSpaceToView(_name,10*widthRate)
//        .yIs(0)
//        .widthIs(85)
//        .heightIs(40);
        
//        [_phone setSingleLineAutoResizeWithMaxWidth:100];
        
        _grade = [UILabel new];
        _grade.text = @"小白";
        _grade.textColor = contentTitleColorStr1;
        _grade.font = [UIFont systemFontOfSize:13];
        _grade.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_grade];
        
        _money = [UILabel new];
        _money.text = @"￥1236.00";
        _money.textColor = contentTitleColorStr1;
        _money.font = [UIFont systemFontOfSize:13];
        _money.textAlignment = NSTextAlignmentRight;
        [self addSubview:_money];
        
        _money.sd_layout
        .rightSpaceToView(self,10)
        .yIs(0)
        .heightIs(40)
        .widthIs(DeviceMaxWidth/4-10);
        
        _grade.sd_layout
        .leftSpaceToView(_name,0)
        .yIs(0)
        .heightIs(40)
        .widthIs(DeviceMaxWidth/4);
        
//        _weekMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _weekMoreBtn.frame = CGRectMake(0, 0, DeviceMaxWidth, 40);
//        _weekMoreBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//        [_weekMoreBtn setTitle:@"更多" forState:UIControlStateNormal];
//        [_weekMoreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        _weekMoreBtn.backgroundColor = [UIColor colorFromHexRGB:@"f3c238"];
//        _weekMoreBtn.hidden = YES;
//        [self addSubview:_weekMoreBtn];
//
//        _monthMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _monthMoreBtn.frame = CGRectMake(0, 0, DeviceMaxWidth, 40);
//        _monthMoreBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//        [_monthMoreBtn setTitle:@"更多" forState:UIControlStateNormal];
//        [_monthMoreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        _monthMoreBtn.backgroundColor = [UIColor colorFromHexRGB:@"f3c238"];
//        _monthMoreBtn.hidden = YES;
//        [self addSubview:_monthMoreBtn];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
