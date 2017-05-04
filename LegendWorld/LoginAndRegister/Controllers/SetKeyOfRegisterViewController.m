//
//  SetKeyOfRegisterViewController.m
//  LegendWorld
//
//  Created by wenrong on 16/10/31.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "SetKeyOfRegisterViewController.h"
#import "MainRequest.h"
#import "UserDelegateViewController.h"
#import "BaiDuPushObject.h"

@interface SetKeyOfRegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *keyTF;
@property (weak, nonatomic) IBOutlet UIButton *registeDownBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;

@end

@implementation SetKeyOfRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    self.view.backgroundColor = [UIColor whiteColor];
    self.registeDownBtn.layer.cornerRadius = 6;
    self.registeDownBtn.layer.masksToBounds = YES;
    UIImage *image = [UIImage backgroundImageWithColor:mainColor cornerRadius:6];
    [self.registeDownBtn setBackgroundImage:image forState:UIControlStateNormal];
    self.agreeBtn.selected = YES;
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)showKeyAct:(UIButton *)sender {
    self.keyTF.secureTextEntry = !self.keyTF.secureTextEntry;
    sender.selected = !sender.isSelected;
}
- (IBAction)registeDownAct:(UIButton *)sender {
    [self.view endEditing:YES];
    if (self.keyTF.text.length <= 0) {
        [self showHUDWithResult:NO message:@"请填写密码"];
        return;
    }
    if (self.keyTF.text.length < 6 || self.keyTF.text.length > 16) {
        [self showHUDWithResult:NO message:@"请填写6-16位密码"];
        return;
    }
    if (self.agreeBtn.selected != YES) {
        [self showHUDWithResult:NO message:@"请同意传说协议"];
        return;
    }
    __weak typeof (self) weakSelf = self;
    NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],
                                 @"token":self.accessToken,
                                 @"user_pwd":self.keyTF.text,
                                 @"re_pwd":self.keyTF.text,
                                 @"sms_token":self.token};
    [MainRequest RequestHTTPData:PATH(@"api/user/registerSetPassword") parameters:parameters success:^(id response) {
        NSString *channelID = [[NSUserDefaults standardUserDefaults] objectForKey:kLocal_ChannelID];
        if (channelID) {
            [BaiDuPushObject uploadBaiduChangnelID:channelID];
        }
        [self saveUserDataToLocal:response];
        [self showHUDWithResult:YES message:@"注册成功" completion:^{
            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
        }];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

-(void)saveUserDataToLocal:(NSDictionary *)dataDic
{
    //保存token
    NSString *tokenStr = [dataDic objectForKey:@"access_token"];
    [[NSUserDefaults standardUserDefaults] setObject:tokenStr?tokenStr:@"" forKey:saveLocalTokenFile];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (IBAction)getBackAct:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)agreeDelegateAct:(UIButton *)sender {
    UserDelegateViewController *vc = [UserDelegateViewController new];
    vc.sourceType = 0;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
