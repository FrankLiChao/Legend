//
//  CustomController.m
//  LegendWorld
//
//  Created by ios-dev-01 on 16/9/9.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "TabBarController.h"
#import "HomePageViewController.h"
#import "ShoppingMallViewController.h"
#import "ShoppingCartViewController.h"
#import "MineViewController.h"
#import "MBProgressHUD.h"

#import "TOCardHomeViewController.h"
#import "TOCardGuideViewController.h"
#import "AgentCertificationViewController.h"

@interface TabBarController () <UITabBarControllerDelegate>

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UINavigationBar appearance] setBarTintColor:mainColor];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [[UINavigationBar appearance] setTranslucent:NO];
    
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setTintColor:mainColor];
    
    [[UITextField appearance] setTintColor:[UIColor themeColor]];
    [[UITextField appearance] setTextColor:[UIColor bodyTextColor]];
    
    [[UISearchBar appearance] setTintColor:[UIColor themeColor]];
    [[UISearchBar appearance] setTextColor:[UIColor bodyTextColor]];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
    
    HomePageViewController *home = [[HomePageViewController alloc] init];
    home.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"homePage_No_Selected"] tag:ModelIndexHome];
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:home];
    
    ShoppingMallViewController *shoppingMall = [[ShoppingMallViewController alloc] init];
    shoppingMall.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"商城" image:[UIImage imageNamed:@"ShoppingMall_No_Selected"] tag:ModelIndexShoppingMall];
    UINavigationController *shoppingMallNav = [[UINavigationController alloc] initWithRootViewController:shoppingMall];
    
    TOCardHomeViewController *emptyTOcard = [[TOCardHomeViewController alloc] init];
    emptyTOcard.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"传说支付" image:[UIImage imageNamed:@"TO_btn"] tag:ModelIndexTOCard];
    UINavigationController *emptyTOCardNav = [[UINavigationController alloc] initWithRootViewController:emptyTOcard];
    
    ShoppingCartViewController *shoppingCart = [[ShoppingCartViewController alloc] init];
    shoppingCart.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"购物车" image:[UIImage imageNamed:@"ShoppingCart_No_Selected"] tag:ModelIndexShoppingCart];
    UINavigationController *loanNav = [[UINavigationController alloc] initWithRootViewController:shoppingCart];
    
    MineViewController *mine = [[MineViewController alloc] init];
    mine.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[UIImage imageNamed:@"Mine_No_Selected"] tag:ModelIndexMine];
    UINavigationController *mineNav = [[UINavigationController alloc] initWithRootViewController:mine];
    
    self.viewControllers = @[homeNav, shoppingMallNav, emptyTOCardNav, loanNav, mineNav];
    self.delegate = self;
    
//    UIButton *tocardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    tocardBtn.frame = CGRectMake((DeviceMaxWidth - 45)/2, -10, 45, 45);
//    [tocardBtn setBackgroundImage:[UIImage imageNamed:@"TO_btn"] forState:UIControlStateNormal];
//    [tocardBtn addTarget:self action:@selector(openTOCard:) forControlEvents:UIControlEventTouchUpInside];
//    [self.tabBar addSubview:tocardBtn];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)openTOCard:(id)sender {
    if (![FrankTools loginIsOrNot:self]) {
        return;
    }
    
    MBProgressHUD *hudView = [[MBProgressHUD alloc] initWithView:self.view];
    hudView.mode = MBProgressHUDModeIndeterminate;
    hudView.contentColor = [UIColor bodyTextColor];
    hudView.minSize = CGSizeMake(100, 80);
    hudView.removeFromSuperViewOnHide = YES;
    hudView.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:hudView];
    
    [hudView showAnimated:YES];
        
    NSDictionary *param = @{@"device_id": [FrankTools getDeviceUUID], @"token": [FrankTools getUserToken]};
    [MainRequest RequestHTTPData:PATH(@"Api/User/checkTocardFlag") parameters:param success:^(id response) {
        BOOL flag = [[response objectForKey:@"flag"] boolValue];
        NSString *tocard_grade = [response objectForKey:@"tocard_grade"];
        NSString *auth_status = [response objectForKey:@"auth_status"];
        if (tocard_grade) {
            NSMutableDictionary *userDic = [[[NSUserDefaults standardUserDefaults] objectForKey:userLoginDataToLocal] mutableCopy];
            [userDic setObject:tocard_grade?tocard_grade:@"" forKey:@"tocard_grade"];
            [[NSUserDefaults standardUserDefaults] setObject:[userDic copy] forKey:userLoginDataToLocal];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        [hudView hideAnimated:YES];
        if (([auth_status integerValue] == 3 || [auth_status integerValue] == 2) && [tocard_grade integerValue] >= 1) {//未申请实名认证 或开户失败 并且已激活（等级大于0）
            AgentCertificationViewController *agentVc = [AgentCertificationViewController new];
            agentVc.auth_status = auth_status;
            UINavigationController *agentNav = [[UINavigationController alloc] initWithRootViewController:agentVc];
            [self presentViewController:agentNav animated:YES completion:nil];
            return ;
        }
        TOCardHomeViewController *home = [[TOCardHomeViewController alloc] init];
        home.isActivated = flag;
        home.auth_status = auth_status;
        UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:home];
        [self presentViewController:homeNav animated:YES completion:nil];
        
    } failed:^(NSDictionary *errorDic) {
        [hudView showAnimated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            hudView.mode = MBProgressHUDModeCustomView;
            
            UIImage *image = [UIImage imageNamed: @"error_network"];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [imageView sizeToFit];
            
            hudView.customView = imageView;
            hudView.label.text = [errorDic objectForKey:@"error_msg"];
            
            double deley = 2.0;
            [hudView hideAnimated:YES afterDelay:deley];
        });
    }];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    NSInteger index = [tabBarController.viewControllers indexOfObject:viewController];
    if (index == ModelIndexTOCard) {
        [self openTOCard:nil];
        return NO;
    }
    if (index == ModelIndexShoppingCart && ![FrankTools isLogin]) {
        LoginViewController *login = [[LoginViewController alloc] init];
        UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:login];
        [self presentViewController:loginNav animated:YES completion:nil];
        return NO;
    }
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)viewController;
        [nav popToRootViewControllerAnimated:NO];
    }
    return YES;
}

@end
