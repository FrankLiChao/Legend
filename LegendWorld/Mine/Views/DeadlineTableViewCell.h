//
//  DeadlineTableViewCell.h
//  LegendWorld
//
//  Created by Frank on 2016/11/8.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountdownLabel.h"

@interface DeadlineTableViewCell : UITableViewCell

@property (nonatomic, strong)UILabel *nameLab;
@property (nonatomic, strong)CountdownLabel *detailLab;
@property (nonatomic, strong)UIView *lineView;

@end
