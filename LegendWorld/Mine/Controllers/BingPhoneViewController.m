//
//  BingPhoneViewController.m
//  LegendWorld
//
//  Created by wenrong on 16/10/11.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "BingPhoneViewController.h"
#import "MainRequest.h"
@interface BingPhoneViewController ()
@property (strong, nonatomic) NSTimer *countDownTimer;
@property (nonatomic) NSInteger secondsCountDown;
@property (weak, nonatomic) IBOutlet BaseTextField *phoneTF;
@property (weak, nonatomic) IBOutlet BaseTextField *verificationTF;
@property (weak, nonatomic) IBOutlet UIButton *getVerificationBtn;
@property (weak, nonatomic) IBOutlet UIButton *downBtn;
@end

@implementation BingPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"手机号绑定";
    self.downBtn.layer.cornerRadius = 6;
    self.getVerificationBtn.layer.borderWidth = 1;
    self.getVerificationBtn.layer.borderColor = mainColor.CGColor;
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)getVerificationAct:(UIButton *)sender {
    [self.view endEditing:YES];
    if (![FrankTools isValidateMobile:self.phoneTF.text]) {
        [self showHUDWithResult:NO message:@"请输入正确的手机号码"];
        return;
    }
    self.secondsCountDown = 60;//60秒倒计时
    //开始倒计时
    [self.getVerificationBtn setTitle:[NSString stringWithFormat:@"%ld秒获取",(long)self.secondsCountDown] forState:UIControlStateNormal];
    self.getVerificationBtn.enabled = NO;
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],@"mobile_no":self.phoneTF.text,@"msg_type":@5,@"use_area":@"1"};
    [self showHUDWithMessage:nil];
    [MainRequest RequestHTTPData:PATH(@"utility/message/sendMsg") parameters:parameters success:^(id responseData) {
        [self showHUDWithResult:YES message:@"发送成功"];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
    
}
-(void)timeFireMethod
{
    //倒计时-1
    self.secondsCountDown--;
    //修改倒计时标签现实内容
    [self.getVerificationBtn setTitle:[NSString stringWithFormat:@"%ld秒获取",(long)self.secondsCountDown] forState:UIControlStateNormal];
    self.getVerificationBtn.enabled = NO;
    //当倒计时到0时，做需要的操作，比如验证码过期不能提交
    if(self.secondsCountDown==0){
        [self.countDownTimer invalidate];
        [self.getVerificationBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        self.getVerificationBtn.enabled = YES;
    }
}

- (IBAction)downBtnAct:(UIButton *)sender {
    [self.view endEditing:YES];
    if (![FrankTools isValidateMobile:self.phoneTF.text]) {
        [self showHUDWithResult:NO message:@"请输入正确的手机号码"];
        return;
    }
    if (self.verificationTF.text.length<6) {
        [self showHUDWithResult:NO message:@"请输入验证码"];
        return;
    }
    if (self.ifFromPayWordWay) {
        [self showHUDWithMessage:nil];
        NSDictionary *param = @{@"use_area":@"1",@"msg_type":@5, @"device_id":[FrankTools getDeviceUUID], @"sms_code":self.verificationTF.text,@"mobile_no":self.phoneTF.text};
        [MainRequest RequestHTTPData:PATH(@"utility/message/checkMsgCode") parameters:param success:^(id response) {
            NSString *sms_token = [response objectForKey:@"sms_token"];
            NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],
                                         @"token":[FrankTools getUserToken],
                                         @"mobile_no":self.phoneTF.text,
                                         @"sms_token":sms_token};
            [MainRequest RequestHTTPData:PATH(@"Api/User/resetMobileNew") parameters:parameters success:^(id response) {
                [self showHUDWithResult:YES message:@"改绑成功"];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [self updateUserData];
                });
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            } failed:^(NSDictionary *errorDic) {
                [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
            }];
        } failed:^(NSDictionary *errorDic) {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }];
    } else {
        [self showHUDWithMessage:nil];
        NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],@"use_area":@"1",@"msg_type":@5,@"mobile_no":self.phoneTF.text,@"sms_code":self.verificationTF.text};
        [MainRequest RequestHTTPData:PATH(@"utility/message/checkMsgCode") parameters:parameters success:^(id response) {
            FLLog(@"response ====== %@",response);
            [self rebingCellPhone:[response objectForKey:@"sms_token"]];
        } failed:^(NSDictionary *errorDic) {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }];
    }
}
-(void)rebingCellPhone:(NSString *)token
{
    NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],
                                 @"token":[FrankTools getUserToken],
                                 @"mobile_no":self.oldPhoneNum,
                                 @"new_mobile_no":self.phoneTF.text,
                                 @"sms_token":self.smsToken,
                                 @"new_sms_token":token};
    [MainRequest RequestHTTPData:PATH(@"api/user/resetMobile") parameters:parameters success:^(id response) {
        [self hideHUD];
        FLLog(@"response%@",response);
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
    
}
@end
