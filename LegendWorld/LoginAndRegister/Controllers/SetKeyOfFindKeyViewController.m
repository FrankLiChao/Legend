//
//  SetKeyOfFindKeyViewController.m
//  LegendWorld
//
//  Created by wenrong on 16/10/31.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "SetKeyOfFindKeyViewController.h"
#import "LoginViewController.h"

@interface SetKeyOfFindKeyViewController ()
@property (weak, nonatomic) IBOutlet UIButton *resetDownBtn;
@property (weak, nonatomic) IBOutlet UITextField *keyTF;
@property (weak, nonatomic) IBOutlet UITextField *keyAgainTF;


@end

@implementation SetKeyOfFindKeyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记密码";
    self.view.backgroundColor = [UIColor whiteColor];

    [self.resetDownBtn setBackgroundImage:[UIImage backgroundImageWithColor:mainColor cornerRadius:6] forState:UIControlStateNormal];

}
- (IBAction)resetDownAct:(UIButton *)sender {
    if (self.keyTF.text.length <= 0) {
        [self showHUDWithResult:NO message:@"请填写密码"];
        return;
    }
    if (self.keyAgainTF.text.length <= 0) {
        [self showHUDWithResult:NO message:@"请填写密码"];
        return;
    }
    if (self.keyTF.text.length < 6 || self.keyTF.text.length > 16) {
        [self showHUDWithResult:NO message:@"请填写6-16位密码"];
        return;
    }
    if (![self.keyTF.text isEqualToString:self.keyAgainTF.text]) {
        [self showHUDWithResult:NO message:@"两次密码不相同，请重新填写"];
        return;
    }
    NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],@"mobile_no":self.phoneNum,@"sms_token":self.sms_token,@"user_pwd":self.keyTF.text,@"re_pwd":self.keyAgainTF.text};
    [MainRequest RequestHTTPData:PATH(@"api/user/findPwd") parameters:parameters success:^(id response) {
        [self showHUDWithResult:YES message:@"密码修改成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[LoginViewController class]]) {
                    LoginViewController *loginVC = (LoginViewController *)controller;
                    [self.navigationController popToViewController:loginVC animated:YES];
                }
            }
        });
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (IBAction)getBackAct:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)deleteFirstAct:(UIButton *)sender {
    self.keyTF.text = @"";
}
- (IBAction)deleteSecondAct:(UIButton *)sender {
    self.keyAgainTF.text = @"";
}
@end
