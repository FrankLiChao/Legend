//
//  MineTableViewCell.h
//  LegendWorld
//
//  Created by ios-dev-01 on 16/9/17.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *nameLab; //名称
@property (nonatomic,strong) UILabel *deteiLab; //详情
@property (nonatomic,strong) UIImageView *arrowImage; //右箭头
@property (nonatomic,strong) UIView *lineView;

@end
