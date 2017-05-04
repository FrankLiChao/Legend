//
//  MyOrderCollectionViewCell.m
//  LegendWorld
//
//  Created by Tsz on 2016/11/10.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "MyOrderCollectionViewCell.h"


@implementation MyOrderCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    RefreshControl *refreshControl = [[RefreshControl alloc] initWithScrollView:self.orderTableView];
    self.refreshControl = refreshControl;
    self.refreshControl.color = [UIColor noteTextColor];
    
    LoadControl *loadControl = [[LoadControl alloc] initWithScrollView:self.orderTableView];
    self.loadControl = loadControl;
    self.loadControl.color = [UIColor noteTextColor];
    self.loadControl.displayCondition = ^{ return NO; };
}

@end
