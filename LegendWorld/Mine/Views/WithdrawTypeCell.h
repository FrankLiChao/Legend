//
//  WithdrawTypeCell.h
//  LegendWorld
//
//  Created by ios-dev-01 on 16/9/19.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WithdrawTypeCell : UITableViewCell

@property (nonatomic,strong) UIImageView *logoImage;//logo图片
@property (nonatomic,strong) UILabel *name;//提现名称
@property (nonatomic,strong) UILabel *nameDescribe;//提现描述
@property (nonatomic,strong) UIImageView *arrow;//右箭头
@property (nonatomic,strong) UIView *lineView;

@end
