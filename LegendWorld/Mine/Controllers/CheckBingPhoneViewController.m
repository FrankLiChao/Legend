//
//  CheckBingPhoneViewController.m
//  LegendWorld
//
//  Created by wenrong on 16/10/11.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "CheckBingPhoneViewController.h"
#import "MainRequest.h"
#import "BingPhoneViewController.h"
@interface CheckBingPhoneViewController ()
@property (nonatomic) NSInteger secondsCountDown;
@property (strong, nonatomic) NSTimer *countDownTimer;
@property (weak, nonatomic) IBOutlet BaseTextField *VerificationTF;
@property (weak, nonatomic) IBOutlet BaseTextField *phoneTF;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UIButton *verificationBtn;
@end

@implementation CheckBingPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"手机号绑定";
    self.phoneTF.text = [FrankTools replacePhoneNumber:self.phoneNumStr];
    self.checkBtn.layer.cornerRadius = 6;
    self.verificationBtn.layer.borderWidth = 1;
    self.verificationBtn.layer.borderColor = mainColor.CGColor;
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)checkAct:(UIButton *)sender {
    [self.view endEditing:YES];
    if (![FrankTools isValidateMobile:self.phoneTF.text]) {
        [self showHUDWithResult:NO message:@"请输入正确的手机号码"];
        return;
    }
    if (self.VerificationTF.text.length < 6) {
        [self showHUDWithResult:NO message:@"请输入验证码"];
        return;
    }
    
    [self showHUD];
    NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],
                                 @"use_area":@"1",
                                 @"msg_type":@5,
                                 @"mobile_no":self.phoneNumStr,
                                 @"sms_code":self.VerificationTF.text};
    [MainRequest RequestHTTPData:PATH(@"utility/message/checkMsgCode") parameters:parameters success:^(id response) {
        [self hideHUD];
        BingPhoneViewController *bingPhoneVC = [[BingPhoneViewController alloc] init];
        bingPhoneVC.smsToken = [response objectForKey:@"sms_token"];
        bingPhoneVC.oldPhoneNum = self.phoneNumStr;
        bingPhoneVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:bingPhoneVC animated:YES];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

- (IBAction)getVerifictionAct:(UIButton *)sender {
    [self.view endEditing:YES];
    if (![FrankTools isValidateMobile:self.phoneTF.text]) {
        [self showHUDWithResult:NO message:@"请输入正确的手机号码"];
        return;
    }
    self.secondsCountDown = 60;//60秒倒计时
    //开始倒计时
    [self.verificationBtn setTitle:[NSString stringWithFormat:@"%ld秒获取",(long)self.secondsCountDown] forState:UIControlStateNormal];
    self.verificationBtn.enabled = NO;
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],@"mobile_no":self.phoneNumStr,@"msg_type":@5,@"use_area":@"1"};
    [self showHUD];
    [MainRequest RequestHTTPData:PATH(@"utility/message/sendMsg") parameters:parameters success:^(id responseData) {
        [self hideHUD];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}
-(void)timeFireMethod
{
    //倒计时-1
    self.secondsCountDown--;
    //修改倒计时标签现实内容
    [self.verificationBtn setTitle:[NSString stringWithFormat:@"%ld秒获取",(long)self.secondsCountDown] forState:UIControlStateNormal];
    self.verificationBtn.enabled = NO;
    //当倒计时到0时，做需要的操作，比如验证码过期不能提交
    if(self.secondsCountDown==0){
        [self.countDownTimer invalidate];
        [self.verificationBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        self.verificationBtn.enabled = YES;
    }
    
}
@end
