//
//  OrderDetailHistoryCell.h
//  LegendWorld
//
//  Created by Tsz on 2016/11/14.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailHistoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITableView *historyTableView;

- (void)updateUIWithOrder:(OrderModel *)order;

@end
