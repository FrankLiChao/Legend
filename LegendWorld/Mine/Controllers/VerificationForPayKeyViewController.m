//
//  VerificationForPayKeyViewController.m
//  LegendWorld
//
//  Created by wenrong on 16/10/11.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "VerificationForPayKeyViewController.h"
#import "MainRequest.h"
#import "SetPayKeyViewController.h"

@interface VerificationForPayKeyViewController ()
@property (nonatomic) NSInteger secondsCountDown;
@property (strong, nonatomic) NSTimer *countDownTimer;
@property (strong, nonatomic) NSDictionary *userData;
@property (weak, nonatomic) IBOutlet BaseTextField *phoneTF;
@property (weak, nonatomic) IBOutlet UIButton *verificationBtn;
@property (weak, nonatomic) IBOutlet BaseTextField *verififcationTF;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (nonatomic, strong) NSString *phoneStr;
@end

@implementation VerificationForPayKeyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"手机验证";
    self.checkBtn.layer.cornerRadius = 6;
    self.verificationBtn.layer.borderWidth = 1;
    self.verificationBtn.layer.borderColor = mainColor.CGColor;
    self.userData = [[NSUserDefaults standardUserDefaults] objectForKey:userLoginDataToLocal];
    self.phoneStr = [self.userData objectForKey:@"mobile_no"];
    self.phoneTF.text = [FrankTools replacePhoneNumber:[self.userData objectForKey:@"mobile_no"]];
}

- (IBAction)getVerificationAct:(UIButton *)sender {
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
    NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],@"mobile_no":self.phoneStr,@"msg_type":@9,@"use_area":@"1"};
    [self showHUDWithMessage:nil];
    [MainRequest RequestHTTPData:PATH(@"utility/message/sendMsg") parameters:parameters success:^(id responseData) {
        [self showHUDWithResult:YES message:@"发送成功"];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

- (IBAction)checkAct:(UIButton *)sender {
    [self.view endEditing:YES];
    if (self.verififcationTF.text.length <= 0) {
        [self showHUDWithResult:NO message:@"请输入验证码"];
        return;
    }
    
    [self showHUD];
    NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],@"use_area":@"1",@"msg_type":@9,@"mobile_no":self.phoneStr,@"sms_code":self.verififcationTF.text};
    [MainRequest RequestHTTPData:PATH(@"utility/message/checkMsgCode") parameters:parameters success:^(id response) {
        SetPayKeyViewController *setPayKeyVC = [[SetPayKeyViewController alloc] init];
        setPayKeyVC.hidesBottomBarWhenPushed = YES;
        setPayKeyVC.ifFromForgetKeyView = YES;
        if (self.payMethodVC != nil) {
            setPayKeyVC.payMethodVC = self.payMethodVC;
        }
        setPayKeyVC.mobile_no = self.phoneStr;
        setPayKeyVC.sms_token = [response objectForKey:@"sms_token"];
        [self.navigationController pushViewController:setPayKeyVC animated:YES];
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
