//
//  LoginController.m
//  LegendWorld
//
//  Created by wenrong on 16/9/18.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "LoginViewController.h"
#import "FrankTools.h"
#import "MainRequest.h"
#import "MJExtension.h"
#import "UserModel.h"
#import "MineViewController.h"
#import "AppDelegate.h"
#import "InviteOfRegisterController.h"
#import "GetVerificationCodeController.h"
#import "VerificationDeviceViewController.h"
#import "BaiDuPushObject.h"

@interface LoginViewController () <UITextFieldDelegate, CheckUserDeviceDelegate>

@property (weak, nonatomic) IBOutlet BaseTextField *mobileTF;
@property (weak, nonatomic) IBOutlet BaseTextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    __weak typeof(self) weakSelf = self;
    self.backBarBtnEvent = ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_image"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(backBarButtonClicked:)];
    [self.loginBtn setBackgroundImage:[UIImage backgroundImageWithColor:[UIColor themeColor] cornerRadius:6]
                             forState:UIControlStateNormal];
    [self.loginBtn setBackgroundImage:[UIImage backgroundImageWithColor:[UIColor noteTextColor] cornerRadius:6]
                             forState:UIControlStateDisabled];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

#pragma mark - Custom
- (IBAction)deleteAct:(UIButton *)sender {
    self.mobileTF.text = nil;
}

- (IBAction)securityOrNotAct:(UIButton *)sender {
    self.passwordTF.secureTextEntry = !self.passwordTF.secureTextEntry;
    sender.selected = !sender.isSelected;
}

- (IBAction)forgetAct:(UIButton *)sender {
    GetVerificationCodeController *getVerificationVC = [[GetVerificationCodeController alloc] init];
    [self.navigationController pushViewController:getVerificationVC animated:YES];
}

- (IBAction)newCustomerRegisterAct:(UIButton *)sender {
    InviteOfRegisterController *inviteOfRegisterVC = [[InviteOfRegisterController alloc] init];
    [self.navigationController pushViewController:inviteOfRegisterVC animated:YES];
}

- (IBAction)loginAct:(UIButton *)sender {
    [self.view endEditing:YES];
    if (self.mobileTF.text.length <= 0 ) {
        [self showHUDWithResult:NO message:@"请输入手机号码"];
        return;
    }
    if (self.passwordTF.text.length <= 0 ) {
        [self showHUDWithResult:NO message:@"请输入登录密码"];
        return;
    }
    if (![FrankTools isValidateMobile:self.mobileTF.text]) {
        [self showHUDWithResult:NO message:@"请输入正确的手机号码"];
        return;
    }
    if ([self.passwordTF.text rangeOfString:@" "].location != NSNotFound) {
        [self showHUDWithResult:NO message:@"密码不能含有空格"];
        return;
    }
    if (self.passwordTF.text.length < 6) {
        [self showHUDWithResult:NO message:@"密码的位数不能少于6位"];
        return;
    }
    if (self.passwordTF.text.length > 16) {
        [self showHUDWithResult:NO message:@"密码的位数不能大于16位"];
        return;
    }
    NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],
                                 @"user_name":self.mobileTF.text,
                                 @"user_pwd":self.passwordTF.text};
    [self showHUDWithMessage:@"登录中..."];
    [MainRequest RequestHTTPData:PATH(@"api/user/checkUserDeviceIdentify") parameters:parameters success:^(id responseData) {
        [[LoginUserManager sharedManager] updateLoginUser:responseData];
        NSString *channelID = [[NSUserDefaults standardUserDefaults] objectForKey:kLocal_ChannelID];
        if (channelID) {
            [BaiDuPushObject uploadBaiduChangnelID:channelID?channelID:@""];
        }
        
        __weak typeof (self) weakSelf = self;
        [self showHUDWithResult:YES message:@"登录成功" completion:^{
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
            if ([weakSelf.delegate respondsToSelector:@selector(refreshingUI)]) {
                [weakSelf.delegate refreshingUI];
            }
        }];
    } failed:^(NSDictionary *errorDic) {
        if ([[errorDic objectForKey:@"error_code"] integerValue] == 2040200) {
            [self hideHUD];
            //在其他设备上登录需要验证码
            VerificationDeviceViewController *vc = [VerificationDeviceViewController new];
            vc.mobile_no = [NSString stringWithFormat:@"%@",self.mobileTF.text];
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }
    }];
}

- (void)checkUserDevice:(NSString *)sms_token{
    NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],
                                 @"user_name":self.mobileTF.text,
                                 @"user_pwd":self.passwordTF.text,
                                 @"sms_token":[NSString stringWithFormat:@"%@",sms_token]};
    [self showHUDWithMessage:@"登录中..."];
    [MainRequest RequestHTTPData:PATH(@"api/user/login") parameters:parameters success:^(id responseData) {
        [[LoginUserManager sharedManager] updateLoginUser:responseData];
        NSString *channelID = [[NSUserDefaults standardUserDefaults] objectForKey:kLocal_ChannelID];
        if (channelID) {
            [BaiDuPushObject uploadBaiduChangnelID:channelID?channelID:@""];
        }
        
        __weak typeof (self) weakSelf = self;
        [self showHUDWithResult:YES message:@"登录成功" completion:^{
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
            if ([weakSelf.delegate respondsToSelector:@selector(refreshingUI)]) {
                [weakSelf.delegate refreshingUI];
            }
        }];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSInteger length = textField.text.length - range.length + string.length;
    if (textField == self.mobileTF) {
        if (length > 11) {
            return NO;
        }
    } else if (textField == self.passwordTF) {
        if (length > 16) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - Touch Control
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


@end
