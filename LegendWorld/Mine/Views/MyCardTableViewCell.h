//
//  MyCardTableViewCell.h
//  LegendWorld
//
//  Created by Frank on 2016/10/31.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCardTableViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView *logoIm;//银行卡logo
@property (nonatomic, strong)UILabel *nameLab;//银行名字
@property (nonatomic, strong)UILabel *detailLab;//银行卡尾号
@property (nonatomic, strong)UIImageView *arrowIm;//右箭头
@property (nonatomic, strong)UILabel *addCardLab;//添加银行卡
@property (nonatomic, strong)UIView *lineView;

@end
