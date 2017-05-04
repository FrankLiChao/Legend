//
//  InviteOfRegisterController.m
//  LegendWorld
//
//  Created by wenrong on 16/10/31.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "InviteOfRegisterController.h"
#import "GetVerificationCodeController.h"
@interface InviteOfRegisterController ()
@property (weak, nonatomic) IBOutlet UITextField *inviteCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *nextStepBtn;

@end

@implementation InviteOfRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    self.view.backgroundColor = [UIColor whiteColor];
    self.nextStepBtn.layer.cornerRadius = 6;
    self.nextStepBtn.layer.masksToBounds = YES;
    UIImage *image = [UIImage backgroundImageWithColor:mainColor cornerRadius:6];
    [self.nextStepBtn setBackgroundImage:image forState:UIControlStateNormal];
    // Do any additional setup after loading the view from its nib.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (IBAction)nextStepAct:(UIButton *)sender {
    [self.view endEditing:YES];
    if (self.inviteCodeTF.text.length == 0) {
        [self showHUDWithResult:NO message:@"请填写邀请码"];
        return;
    }
    [self showHUDWithMessage:nil];
    NSDictionary *parameters = @{@"recommend_code":self.inviteCodeTF.text,@"device_id":[FrankTools getDeviceUUID]};
    [MainRequest RequestHTTPData:PATH(@"Api/User/checkRecommendCode") parameters:parameters success:^(id response) {
        [self showHUDWithResult:YES message:nil];
        GetVerificationCodeController *getVerificationCodeVC = [[GetVerificationCodeController alloc] init];
        getVerificationCodeVC.invitePerson = self.inviteCodeTF.text;
        getVerificationCodeVC.ifFromRegister = YES;
        [self.navigationController pushViewController:getVerificationCodeVC animated:YES];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}
- (IBAction)getBackAct:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)deleteAct:(UIButton *)sender {
    self.inviteCodeTF.text = @"";
}
@end
