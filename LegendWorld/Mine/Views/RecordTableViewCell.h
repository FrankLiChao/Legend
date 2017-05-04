//
//  RecordTableViewCell.h
//  LegendWorld
//
//  Created by ios-dev-01 on 16/9/19.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *name;//提现名称
@property (nonatomic,strong) UILabel *data;//提现日期
@property (nonatomic,strong) UILabel *money;//提现金额
@property (nonatomic,strong) UILabel *statusLab;//提现状态
@property (nonatomic,strong) UIView  *lineView;

@end
