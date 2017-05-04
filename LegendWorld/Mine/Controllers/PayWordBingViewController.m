//
//  PayWordBingViewController.m
//  LegendWorld
//
//  Created by wenrong on 16/11/11.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "PayWordBingViewController.h"
#import "CashPasswordFirstSetingViewController.h"
#import "BingPhoneViewController.h"
@interface PayWordBingViewController ()

@end

@implementation PayWordBingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"手机号绑定";
    self.checkBtn.layer.cornerRadius = 6;
    self.setPayWordBtn.layer.cornerRadius = 6;
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    UserModel*model = [self getUserData];
    if (![model.payment_pwd isEqualToString:@""]) {
        self.checkHavePayWordOrNotView.hidden = YES;
    }
    else{
        self.checkHavePayWordOrNotView.hidden = NO;
        self.checkHavePayWordOrNotView.backgroundColor = [UIColor backgroundColor];
    }
}
- (IBAction)setPayWordAct:(UIButton *)sender {
    CashPasswordFirstSetingViewController *password = [[CashPasswordFirstSetingViewController alloc] initWithNibName:@"CashPasswordFirstSetingViewController" bundle:nil];
    [self.navigationController pushViewController:password animated:YES];
}
- (IBAction)checkPayWordAct:(UIButton*)sender {
    NSString *passwordKey = [NSString stringWithFormat:@"%@%@",self.payWordTF.text,DES_KEY];
    NSString *md5Password = [[FrankTools sharedInstance] getMd5_32Bit_String:passwordKey];
    NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],@"token":[FrankTools getUserToken],@"payment_pwd":md5Password};
    [MainRequest RequestHTTPData:PATH(@"Api/User/checkPaymentPassword") parameters:parameters success:^(id response) {
        BingPhoneViewController *bingPhoneVC = [[BingPhoneViewController alloc] init];
        bingPhoneVC.hidesBottomBarWhenPushed = YES;
        bingPhoneVC.ifFromPayWordWay = YES;
        [self.navigationController pushViewController:bingPhoneVC animated:YES];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];

}

@end
