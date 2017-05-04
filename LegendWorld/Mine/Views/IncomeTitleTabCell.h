//
//  IncomeTitleTabCell.h
//  LegendWorld
//
//  Created by Frank on 2016/11/7.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IncomeTitleTabCell : UITableViewCell

@property (nonatomic, strong)UIImageView *headIm;//头像
@property (nonatomic, strong)UIImageView *imagaTag;//等级
@property (nonatomic, strong)UILabel *nameLab;//姓名
@property (nonatomic, strong)UILabel *todayIncome;//今日收益
@property (nonatomic, strong)UILabel *totalIncome;//总收益
@property (nonatomic, strong)UILabel *goonMoney;//表示进行中的收益
@property (nonatomic, strong)UILabel *waitMoney;//表示待分红的收益
@property (nonatomic, strong)UIButton *goOnBtn;//表示进行中的收益按钮
@property (nonatomic, strong)UIButton *waiBtn;//表示待分红的收益按钮

@end
