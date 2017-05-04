//
//  ResetKeyViewController.m
//  LegendWorld
//
//  Created by wenrong on 16/9/19.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "ResetKeyViewController.h"
#import "MainRequest.h"
#import "FrankTools.h"
#import "VerificationForPayKeyViewController.h"
@interface ResetKeyViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UITextField *keyBeforeTF;
@property (weak, nonatomic) IBOutlet UITextField *setNewKeyTF;
@property (weak, nonatomic) IBOutlet UITextField *againTF;
@property (weak, nonatomic) IBOutlet UIButton *forgetKeyBtn;
@end

@implementation ResetKeyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.ifFromPayKeySetView == YES) {
        self.title = @"设置支付密码";
        self.forgetKeyBtn.hidden = NO;
        self.setNewKeyTF.keyboardType = UIKeyboardTypeNumberPad;
        self.againTF.keyboardType = UIKeyboardTypeNumberPad;
        self.keyBeforeTF.keyboardType = UIKeyboardTypeNumberPad;
    }
    else{
        self.title = @"设置登录密码";
        self.forgetKeyBtn.hidden = YES;
    }
    self.setNewKeyTF.delegate = self;
    self.againTF.delegate = self;
    self.keyBeforeTF.delegate = self;
    self.saveBtn.layer.cornerRadius = 6;
    self.saveBtn.layer.masksToBounds = YES;
    // Do any additional setup after loading the view from its nib.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.keyBeforeTF.text.length == 0) {
        return YES;
    }
    if (self.againTF.text.length == 0) {
        return YES;
    }
    if (self.setNewKeyTF.text.length == 0) {
        return YES;
    }
    self.saveBtn.backgroundColor = mainColor;
    self.saveBtn.enabled = YES;
    return YES;
}
- (IBAction)retrieveKeyAct:(UIButton *)sender {
    VerificationForPayKeyViewController *verificationVC = [[VerificationForPayKeyViewController alloc] init];
    verificationVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:verificationVC animated:YES];
}
- (IBAction)saveAct:(UIButton *)sender {
    NSString *passwordBeforeKey = [NSString stringWithFormat:@"%@%@",self.keyBeforeTF.text,DES_KEY];
    NSString *md5BeforePassword = [[FrankTools sharedInstance] getMd5_32Bit_String:passwordBeforeKey];
    NSString *passwordAfterKey = [NSString stringWithFormat:@"%@%@",self.setNewKeyTF.text,DES_KEY];
    NSString *md5AfterPassword = [[FrankTools sharedInstance] getMd5_32Bit_String:passwordAfterKey];
    if (self.againTF.text != self.setNewKeyTF.text) {
        [self showHUDWithResult:NO message:@"两次密码不一致"];
        return;
    }
    if (self.ifFromPayKeySetView == YES) {
        if (self.setNewKeyTF.text.length != 6) {
            [self showHUDWithResult:NO message:@"支付密码请设置6位数字"];
            return;
        }
    }
    if (self.ifFromPayKeySetView == NO) {
        if (self.setNewKeyTF.text.length<6 || self.setNewKeyTF.text.length > 16) {
            [self showHUDWithResult:NO message:@"密码6-16位"];
            return;
        }
    }
    __weak typeof (self) weakSelf = self;
    if (self.ifFromPayKeySetView == NO) {
        [self showHUD];
        NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],@"user_pwd":self.keyBeforeTF.text,@"new_pwd":self.setNewKeyTF.text,@"re_pwd":self.setNewKeyTF.text,@"token":[FrankTools getUserToken]};
        [MainRequest RequestHTTPData:PATH(@"api/user/resetPwd") parameters:parameters success:^(id responseData) {
            [self showHUDWithResult:YES message:@"修改成功" completion:^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        } failed:^(NSDictionary *errorDic) {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }];
    } else {
        [self showHUD];
        NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],
                                     @"payment_pwd":md5BeforePassword,
                                     @"new_payment_pwd":md5AfterPassword,
                                     @"re_new_payment_pwd":md5AfterPassword,
                                     @"token":[FrankTools getUserToken]};
        [MainRequest RequestHTTPData:PATH(@"Api/User/setPaymentPassword") parameters:parameters success:^(id responseData) {
            [self showHUDWithResult:YES message:@"修改成功" completion:^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        } failed:^(NSDictionary *errorDic) {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }];
    }
}
@end
