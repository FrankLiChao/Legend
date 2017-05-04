//
//  TOCardGuideViewController.m
//  LegendWorld
//
//  Created by Tsz on 2016/11/27.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "TOCardGuideViewController.h"
#import "ProductDetailViewController.h"

@interface TOCardGuideViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *contenImg;
@property (weak, nonatomic) IBOutlet UILabel *contentMsg;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;

@end

@implementation TOCardGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"TO卡";
    __weak typeof (self) weakSelf = self;
    self.backBarBtnEvent = ^{
        [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
    };
    
    [self.actionBtn setBackgroundImage:[UIImage backgroundImageWithColor:[UIColor themeColor] cornerRadius:18] forState:UIControlStateNormal];
    
    self.contenImg.image = [UIImage imageNamed:@"monkey_scare"];
    self.contentMsg.text = @"您尚未购买TO卡，请先完成购买";
    [self.actionBtn setTitle:@"去购买" forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (IBAction)actionBtnEvent:(UIButton *)sender {
    if ([sender.currentTitle isEqualToString:@"去购买"]) {
        [self showHUDWithMessage:nil];
        NSDictionary *param = @{@"device_id": [FrankTools getDeviceUUID], @"token": [FrankTools getUserToken]};
        [MainRequest RequestHTTPData:PATHShop(@"api/goods/getTocardId") parameters:param success:^(id response) {
            NSString *goods_id = [response objectForKey:@"goods_id"];
            if ([goods_id integerValue] > 0) {
                [self hideHUD];
                ProductDetailViewController *product = [[ProductDetailViewController alloc] init];
                product.goods_id = goods_id;
                product.isTok = YES;
                [self.navigationController pushViewController:product animated:YES];
            } else {
                [self showHUDWithResult:NO message:@"找不到对应商品"];
            }
        } failed:^(NSDictionary *errorDic) {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }];
    } 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
