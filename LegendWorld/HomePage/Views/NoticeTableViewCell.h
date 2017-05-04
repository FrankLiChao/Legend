//
//  NoticeTableViewCell.h
//  LegendWorld
//
//  Created by Frank on 2016/11/1.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeTableViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView *logoIm;//logo图片
@property (nonatomic, strong)UILabel *nameLab;//新闻标题
@property (nonatomic, strong)UILabel *detailLab;//新闻描述
@property (nonatomic, strong)UILabel *dataLab;//新闻时间
@property (nonatomic, strong)UIView *lineView;
@property (nonatomic, strong)UILabel *pointLab;//小圆点

@end
