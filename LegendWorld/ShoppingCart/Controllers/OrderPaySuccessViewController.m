//
//  OrderPaySuccessViewController.m
//  LegendWorld
//
//  Created by Tsz on 2016/11/9.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "OrderPaySuccessViewController.h"
#import "MyOrderViewController.h"
#import "ProductDetailViewController.h"
#import "MyOrderViewController.h"
#import "OrderDetailViewController.h"
#import "AgentCertificationViewController.h"

@interface OrderPaySuccessViewController ()

@end

@implementation OrderPaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"支付完成";
    [self requestData];
    __weak typeof (self) weakSelf = self;
    self.backBarBtnEvent = ^{
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        UITabBarController *root = (UITabBarController *)app.window.rootViewController;
        if (![root.viewControllers containsObject:weakSelf.navigationController]) {
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            return;
        }
        
        if ([root.viewControllers indexOfObject:weakSelf.navigationController] == ModelIndexShoppingCart) {
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        } else if ([root.viewControllers indexOfObject:weakSelf.navigationController] == 1 || [root.viewControllers indexOfObject:weakSelf.navigationController] == 0) {
            for (NSInteger i = weakSelf.navigationController.viewControllers.count - 1; i >= 0; i--) {
                UIViewController *vc = [weakSelf.navigationController.viewControllers objectAtIndex:i];
                if ([vc isKindOfClass:[ProductDetailViewController class]]) {
                    [weakSelf.navigationController popToViewController:vc animated:YES];
                    return;
                }
            }
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        } else if ([root.viewControllers indexOfObject:weakSelf.navigationController] == ModelIndexMine) {
            for (NSInteger i = weakSelf.navigationController.viewControllers.count - 1; i >= 0; i--) {
                UIViewController *vc = [weakSelf.navigationController.viewControllers objectAtIndex:i];
                if ([vc isKindOfClass:[MyOrderViewController class]] || [vc isKindOfClass:[OrderDetailViewController class]]) {
                    [weakSelf.navigationController popToViewController:vc animated:YES];
                    return;
                }
            }
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }
    };
    
    [self.backToHomeBtn setBackgroundImage:[UIImage backgroundStrokeImageWithColor:[UIColor themeColor]] forState:UIControlStateNormal];
    [self.backToHomeBtn setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    
    [self.goToManageOrderBtn setBackgroundImage:[UIImage backgroundStrokeImageWithColor:[UIColor bodyTextColor]] forState:UIControlStateNormal];
    [self.goToManageOrderBtn setTitleColor:[UIColor bodyTextColor] forState:UIControlStateNormal];
}

-(void)requestData{
    NSDictionary *dic = @{@"token":[FrankTools getUserToken],
                          @"device_id":[FrankTools getDeviceUUID],
                          @"order_id":self.order_id?self.order_id:@""};
    [self showHUDWithMessage:nil];
    [MainRequest RequestHTTPData:PATHShop(@"api/ShoppingCart/checkIsAddReal") parameters:dic success:^(id responseData) {
        FLLog(@"%@",responseData);
        NSString *flag = [responseData objectForKey:@"flag"];
        if ([flag boolValue]) {
            __weak UINavigationController *weakNav = self.navigationController;
            UIAlertController *alterView = [UIAlertController alertControllerWithTitle:@"提示" message:@"马上完成代理商认证，赚取收益吧!" preferredStyle:UIAlertControllerStyleAlert];
            [alterView addAction:[UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                AgentCertificationViewController *agentVc = [AgentCertificationViewController new];
                agentVc.buyPage = YES;
                [weakNav pushViewController:agentVc animated:YES];
            }]];
            [self presentViewController:alterView animated:YES completion:nil];
        }
        [self hideHUD];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backToHomeEvent:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:NO];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UITabBarController *root = (UITabBarController *)app.window.rootViewController;
    NSInteger goToIndex = ModelIndexHome;
    UINavigationController *nav = [root.viewControllers objectAtIndex:goToIndex];
    [nav popToRootViewControllerAnimated:NO];
    root.selectedIndex = goToIndex;
}

- (IBAction)goToManageOrderEvent:(id)sender {
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[MyOrderViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    MyOrderViewController *myOrder = [[MyOrderViewController alloc] init];
    myOrder.pageIndex = 0;
    [self.navigationController pushViewController:myOrder animated:YES];
}

@end
