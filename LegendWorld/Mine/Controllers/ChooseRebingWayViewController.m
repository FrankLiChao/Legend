//
//  ChooseRebingWayViewController.m
//  LegendWorld
//
//  Created by wenrong on 16/10/11.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "ChooseRebingWayViewController.h"
#import "CheckBingPhoneViewController.h"
#import "PayWordBingViewController.h"
@interface ChooseRebingWayViewController ()
@property (weak, nonatomic) IBOutlet UIButton *keyCheckBtn;
@property (weak, nonatomic) IBOutlet UIButton *messageCheckBtn;
@end

@implementation ChooseRebingWayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"手机号绑定";
    self.keyCheckBtn.layer.borderWidth = self.messageCheckBtn.layer.borderWidth = 1;
    self.keyCheckBtn.layer.borderColor = self.messageCheckBtn.layer.borderColor = mainColor.CGColor;
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)messageCheckAct:(UIButton *)sender {
    UserModel *model = [self getUserData];
    CheckBingPhoneViewController *checkBingPhoneVC = [[CheckBingPhoneViewController alloc] init];
    checkBingPhoneVC.phoneNumStr = model.mobile_no;
    checkBingPhoneVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:checkBingPhoneVC animated:YES];
}
- (IBAction)keyCheckAct:(UIButton *)sender {
    PayWordBingViewController *payWordBingVC = [[PayWordBingViewController alloc] init];
    payWordBingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:payWordBingVC animated:YES];
}
@end
