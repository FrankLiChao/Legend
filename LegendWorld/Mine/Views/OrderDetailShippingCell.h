//
//  OrderDetailShippingCell.h
//  LegendWorld
//
//  Created by Tsz on 2016/11/14.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailShippingCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *statusDesc;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *info;

- (void)updateUIWithLogistic:(LogisticsModel *)log;

@end
