//
//  DealSuccessViewController.m
//  LegendWorld
//
//  Created by Tsz on 2016/11/15.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "DealSuccessViewController.h"
#import "OrderDetailViewController.h"
#import "EvaluationNewViewController.h"

@interface DealSuccessViewController ()

@property (weak, nonatomic) IBOutlet UIButton *appraiseBtn;
@property (weak, nonatomic) IBOutlet UIButton *orderDetailBtn;

@end

@implementation DealSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认完成";
    
    [self.appraiseBtn setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    [self.appraiseBtn setBackgroundImage:[UIImage backgroundStrokeImageWithColor:[UIColor themeColor]] forState:UIControlStateNormal];
    
    [self.orderDetailBtn setTitleColor:[UIColor bodyTextColor] forState:UIControlStateNormal];
    [self.orderDetailBtn setBackgroundImage:[UIImage backgroundStrokeImageWithColor:[UIColor bodyTextColor]] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goToAppraise:(id)sender {
    EvaluationNewViewController *evaluation = [[EvaluationNewViewController alloc] init];
    evaluation.order_id = self.order.order_id;
    evaluation.seller_id = self.order.seller_info.seller_id;
    evaluation.modelDataArr = [self.order.order_goods copy];
    [self.navigationController pushViewController:evaluation animated:YES];
}

- (IBAction)goToOrderDetail:(id)sender {
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[OrderDetailViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    OrderDetailViewController *orderDetail = [[OrderDetailViewController alloc] init];
    orderDetail.orderId = [self.order.order_id integerValue];
    [self.navigationController pushViewController:orderDetail animated:YES];
}

@end
