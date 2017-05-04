//
//  BaseViewController.m
//  LegendWorld
//
//  Created by 文荣 on 16/9/13.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD.h"
#import <objc/runtime.h>

@interface BaseViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) MBProgressHUD *hudView;

@end

static const void *HttpRequestHUDKey = &HttpRequestHUDKey;

#define activityTag 199
#define activityImgTag 198

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = viewColor;
    
    if ([self.navigationController.viewControllers indexOfObject:self] != 0) {
        __weak typeof(self) weakSelf = self;
        self.backBarBtnEvent = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_image"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonClicked:)];
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 判断是否需要重新登录
- (BOOL)isReLogin:(NSDictionary *)errorDic{
    if ([[errorDic objectForKey:@"error_code"] integerValue] >= 1020001 && [[errorDic objectForKey:@"error_code"] integerValue] <= 1020008) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - 弹出登录页面
- (void)popLoginView:(UIViewController *)controller{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    loginVC.delegate = (id<RefreshingViewDelegate>)controller;
    [controller presentViewController:nav animated:YES completion:nil];
}

- (void)leftBarButtonClicked:(UIBarButtonItem *)sender {
    if (self.leftBarBtnEvent) {
        self.leftBarBtnEvent();
    }
}

- (void)rightBarButtonClicked:(UIBarButtonItem *)sender {
    if (self.rightBarBtnEvent) {
        self.rightBarBtnEvent();
    }
}

- (void)backBarButtonClicked:(UIBarButtonItem *)sender {
    if (self.backBarBtnEvent) {
        self.backBarBtnEvent();
    }
}

- (void)updateUserData{
    NSDictionary *dic = @{@"token":[FrankTools getUserToken],
                          @"device_id":[FrankTools getDeviceUUID]};
    [MainRequest RequestHTTPData:PATH(@"Api/User/getuserinfo") parameters:dic success:^(id responseData) {
        [[LoginUserManager sharedManager] updateLoginUser:responseData];
    } failed:^(NSDictionary *errorDic) {

    }];
}

- (UserModel *)getUserData{
    return [LoginUserManager sharedManager].loginUser;
}

#pragma mark - MBProgressHUD
- (void)showHUD {
    [self showHUDWithMessage:nil];
}

- (void)showHUDInView:(UIView *)view {
    if (self.hudView.superview) {
        [self.hudView removeFromSuperview];
    }
    [view addSubview:self.hudView];
    [self showHUDWithMessage:nil];
}

- (void)showHUDWithMessage:(NSString *)message {
    self.hudView.mode = MBProgressHUDModeIndeterminate;
    self.hudView.detailsLabel.text = message;
    [self.hudView showAnimated:YES];
}

- (void)showHUDWithMessage:(NSString *)message inView:(UIView *)view {
    if (self.hudView.superview) {
        [self.hudView removeFromSuperview];
    }
    [view addSubview:self.hudView];
    [self showHUDWithMessage:message];
}

- (void)showHUDWithResult:(BOOL)isSuccess message:(NSString *)message {
    [self showHUDWithResult:isSuccess message:message completion:nil];
}

- (void)showHUDWithResult:(BOOL)isSuccess message:(NSString *)message completion:(void (^)(void))completion {
    [self.hudView showAnimated:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.hudView.mode = MBProgressHUDModeCustomView;
        
        UIImage *image = [UIImage imageNamed: isSuccess ? @"success_network" : @"error_network"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView sizeToFit];
        
        self.hudView.customView = imageView;
        self.hudView.detailsLabel.text = message;
        
        double deley = isSuccess ? 1.0 : 2.0;
        [self.hudView hideAnimated:YES afterDelay:deley];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(deley * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    });
}

- (void)hideHUD {
    [self.hudView hideAnimated:YES];
}

- (MBProgressHUD *)hudView {
    if (!_hudView) {
        _hudView = [[MBProgressHUD alloc] initWithView:self.view];
        _hudView.mode = MBProgressHUDModeIndeterminate;
        _hudView.contentColor = [UIColor bodyTextColor];
        _hudView.minSize = CGSizeMake(110, 90);
        _hudView.removeFromSuperViewOnHide = YES;
        _hudView.detailsLabel.font = [UIFont bodyTextFont];
    }
    if (!_hudView.superview) {
        [self.view addSubview:_hudView];
    }
    return _hudView;
}

@end
