//
//  POSAgreementViewController.m
//  LegendWorld
//
//  Created by Frank on 2016/12/28.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "POSAgreementViewController.h"
#import "ApplyRecordViewController.h"
#import "ApplyPOSViewController.h"

@interface POSAgreementViewController ()
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;//同意按钮
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHight;

@end

@implementation POSAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"POS机申请";
    if (self.isApplyViewController) {
        self.agreeBtn.hidden = YES;
        self.contentHight.constant = 0;
    } else {
        self.agreeBtn.hidden = NO;
        self.contentHight.constant = 50;
        [self.agreeBtn setBackgroundImage:[UIImage backgroundImageWithColor:mainColor] forState:UIControlStateNormal];
        [self.agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.agreeBtn addTarget:self action:@selector(clickAgreeButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)clickAgreeButtonEvent:(UIButton *)button_{
    NSDictionary *dic = @{@"token":[FrankTools getUserToken],
                          @"device_id":[FrankTools getDeviceUUID]};
    [self showHUDWithMessage:nil];
    [MainRequest RequestHTTPData:PATHTOCard(@"Pos/agreePosPro") parameters:dic success:^(id responseData) {
        [self hideHUD];
        FLLog(@"%@",responseData);
        ApplyPOSViewController *applyPOSVc = [ApplyPOSViewController new];
        [self.navigationController pushViewController:applyPOSVc animated:YES];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
