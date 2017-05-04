//
//  RefreshControl.h
//  LegendWorld
//
//  Created by Tsz on 2016/11/4.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefreshControl : UIControl

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, readonly, getter = isRefreshing) BOOL refreshing;

- (instancetype)initWithScrollView:(UIScrollView *)scrollView;

- (void)beginRefreshing;
- (void)endRefreshing:(BOOL)isSuccess;

@end
