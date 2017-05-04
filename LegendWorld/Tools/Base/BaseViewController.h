//
//  BaseViewController.h
//  LegendWorld
//
//  Created by 文荣 on 16/9/13.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

typedef void (^NavBtnEventBlock)();
@interface BaseViewController : UIViewController

@property(nonatomic, strong) NavBtnEventBlock rightBarBtnEvent;
@property(nonatomic, strong) NavBtnEventBlock leftBarBtnEvent;
@property(nonatomic, strong) NavBtnEventBlock backBarBtnEvent;

//需要重新登录
- (BOOL)isReLogin:(NSDictionary *)errorDic;
//弹出登录页面
- (void)popLoginView:(UIViewController *)controller;

- (void)updateUserData;
- (UserModel *)getUserData;

- (void)leftBarButtonClicked:(UIBarButtonItem *)sender;
- (void)rightBarButtonClicked:(UIBarButtonItem *)sender;
- (void)backBarButtonClicked:(UIBarButtonItem *)sender;

//MBProgressHUD
- (void)showHUD;
- (void)showHUDInView:(UIView *)view;
- (void)showHUDWithMessage:(NSString *)message;
- (void)showHUDWithMessage:(NSString *)message inView:(UIView *)view;
- (void)showHUDWithResult:(BOOL)isSuccess message:(NSString *)message;
- (void)showHUDWithResult:(BOOL)isSuccess message:(NSString *)message completion:(void (^)(void))completion;
- (void)hideHUD;

@end
