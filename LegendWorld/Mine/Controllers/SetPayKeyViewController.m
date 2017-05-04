//
//  SetPayKeyViewController.m
//  LegendWorld
//
//  Created by wenrong on 16/9/27.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "SetPayKeyViewController.h"
#import "MainRequest.h"
@interface SetPayKeyViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *writeKeyTF;
@property (weak, nonatomic) IBOutlet UITextField *writeKeyAgainTF;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@end

@implementation SetPayKeyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付密码设置";
    self.writeKeyTF.delegate = self;
    self.writeKeyAgainTF.delegate = self;
    self.saveBtn.layer.cornerRadius = 6;
    self.saveBtn.layer.masksToBounds = YES;
    // Do any additional setup after loading the view from its nib.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self getBtnEable];
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)saveAct:(UIButton *)sender {
    [self.view endEditing:YES];
    NSString *passwordKey = [NSString stringWithFormat:@"%@%@",self.writeKeyAgainTF.text,DES_KEY];
    NSString *md5Password = [[FrankTools sharedInstance] getMd5_32Bit_String:passwordKey];
    if (self.writeKeyTF.text.length != 6) {
        [self showHUDWithResult:NO message:@"密码位数请设置为6位"];
        return;
    }
    if (![self.writeKeyAgainTF.text isEqualToString:self.writeKeyTF.text]) {
        [self showHUDWithResult:NO message:@"两次输入的密码不一致请重新输入"];
        return;
    }
    if (self.ifFromForgetKeyView) {
        [self showHUDWithMessage:nil];
        NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],
                                     @"token":[FrankTools getUserToken],
                                     @"mobile_no":self.mobile_no,
                                     @"sms_token":self.sms_token,
                                     @"payment_pwd":md5Password,
                                     @"re_payment_pwd":md5Password};
        [MainRequest RequestHTTPData:PATH(@"Api/User/forgetPaymentPwd") parameters:parameters success:^(id response) {
            [self showHUDWithResult:YES message:@"设置密码成功"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:havePayPassword];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self updateUserData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.payMethodVC != nil) {
                    [self.navigationController popToViewController:self.payMethodVC animated:YES];
                }
                else{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            });
        } failed:^(NSDictionary *errorDic) {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }];
    }
    else{
        [self showHUDWithMessage:nil];
        NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],
                                 @"token":[FrankTools getUserToken],
                                 @"new_payment_pwd":md5Password,
                                 @"re_new_payment_pwd":md5Password};
        [MainRequest RequestHTTPData:PATH(@"api/user/setPaymentPassword") parameters:parameters success:^(id response) {
            [self showHUDWithResult:YES message:@"设置密码成功"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:havePayPassword];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self updateUserData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } failed:^(NSDictionary *errorDic) {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }];
    }
}
-(void)getBtnEable
{
    if (self.writeKeyTF.text.length != 0 && self.writeKeyAgainTF.text.length != 0) {
        self.saveBtn.enabled = YES;
        self.saveBtn.backgroundColor = mainColor;
    }
}
@end
