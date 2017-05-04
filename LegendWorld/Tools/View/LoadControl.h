//
//  LoadControl.h
//  LegendWorld
//
//  Created by Tsz on 2016/11/4.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef BOOL (^LoadControlCondition)();

@interface LoadControl : UIControl

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, readonly, getter = isLoading) BOOL loading;
@property (nonatomic, strong) LoadControlCondition displayCondition;
@property (nonatomic, strong) LoadControlCondition loadAllCondition;

- (instancetype)initWithScrollView:(UIScrollView *)scrollView;

- (void)beginLoading;
- (void)endLoading:(BOOL)isSuccess;

@end
