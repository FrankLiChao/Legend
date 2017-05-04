//
//  OrderDetailOrderIdCell.h
//  LegendWorld
//
//  Created by Tsz on 2016/11/14.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailOrderIdCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLeftLabel;

@end
