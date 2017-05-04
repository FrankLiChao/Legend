//
//  MyWalletTableViewCell.h
//  LegendWorld
//
//  Created by ios-dev-01 on 16/9/19.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyWalletTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *typeImage;//交易类型图片
@property (nonatomic,strong) UILabel *name;//交易名称
@property (nonatomic,strong) UILabel *data;//交易时间
@property (nonatomic,strong) UILabel *money;//交易金额
@property (nonatomic,strong) UILabel *moneyType;//交易类型
@property (nonatomic,strong) UIView *lineView;

@end
