//
//  UserFixInforViewController.m
//  LegendWorld
//
//  Created by wenrong on 16/9/21.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "UserFixInforViewController.h"
#import "MainRequest.h"

@interface UserFixInforViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UITextField *userFixInforTF;
@end

@implementation UserFixInforViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    self.backBarBtnEvent = ^
    {
        if (self.userFixInforTF.text.length != 0) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"信息未保存" message:@"您修改的信息尚未保存，确认退出？" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }]];
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        }
        else{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    };
    [self initView];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view from its nib.
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length != 0) {
        self.saveBtn.backgroundColor = mainColor;
        self.saveBtn.enabled = YES;
    }
    else{
        self.saveBtn.backgroundColor = [UIColor noteTextColor];
        self.saveBtn.enabled = NO;
    }
}
-(void)initView
{
    self.saveBtn.layer.cornerRadius = 6;
    __weak typeof(self) weakSelf = self;
    if ([_whichToFixStr isEqualToString:@"userName"]) {
        self.title = @"修改个人姓名";
        self.userFixInforTF.placeholder = @"填写个人姓名";
        __block UITextField *userFixInforTFBlock = self.userFixInforTF;
        self.rightBarBtnEvent = ^()
        {
            if (userFixInforTFBlock.text.length == 0) {
                [FrankTools showAlertWithMessage:@"请输入您的姓名" withSuperView:weakSelf.view withHeih:DeviceMaxHeight/2];
                return ;
            }
            [weakSelf showHUD];
            NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],
                                         @"field":@"user_name",
                                         @"value":userFixInforTFBlock.text,
                                         @"token":[FrankTools getUserToken]};
            [MainRequest RequestHTTPData:PATH(@"api/user/changeUserinfo") parameters:parameters success:^(id responseData) {
                [weakSelf hideHUD];
                [weakSelf updateUserData];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.delegate changeUserInforProAct:weakSelf.userFixInforTF.text andWhichTF:@"userName"];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            } failed:^(NSDictionary *errorDic) {
                [weakSelf showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
            }];
        };
    }
    if ([self.whichToFixStr isEqualToString:@"userEmail"]) {
        self.title = @"修改邮箱";
        self.userFixInforTF.placeholder = @"填写个人邮箱";
        __block UITextField *userFixInforTFBlock = self.userFixInforTF;
        self.rightBarBtnEvent = ^()
        {
            [weakSelf showHUD];
            NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],@"field":@"email",@"value":userFixInforTFBlock.text,@"token":[FrankTools getUserToken]};
            [MainRequest RequestHTTPData:PATH(@"api/user/changeUserinfo") parameters:parameters success:^(id responseData) {
                [weakSelf hideHUD];
                [weakSelf updateUserData];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.delegate changeUserInforProAct:weakSelf.userFixInforTF.text andWhichTF:@"userEmail"];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            } failed:^(NSDictionary *errorDic) {
                [weakSelf showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
            }];
        };
    }
    if ([self.whichToFixStr isEqualToString:@"userWeChat"]) {
        self.title = @"修改微信号";
        self.userFixInforTF.placeholder = @"填写微信号码";
        __block UITextField *userFixInforTFBlock = self.userFixInforTF;
        self.rightBarBtnEvent = ^()
        {
            [weakSelf showHUD];
            NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],@"field":@"wx_account",@"value":userFixInforTFBlock.text,@"token":[FrankTools getUserToken]};
            [MainRequest RequestHTTPData:PATH(@"api/user/changeUserinfo") parameters:parameters success:^(id responseData) {
                [weakSelf hideHUD];
                [weakSelf updateUserData];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.delegate changeUserInforProAct:weakSelf.userFixInforTF.text andWhichTF:@"userWeChat"];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            } failed:^(NSDictionary *errorDic) {
                [weakSelf showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
            }];
        };
    }
}
- (IBAction)saveAct:(UIButton *)sender {
    if ([self.whichToFixStr isEqualToString:@"userName"]) {
        self.userFixInforTF.placeholder = @"填写个人姓名";
        __block UITextField *userFixInforTFBlock = self.userFixInforTF;
        if (userFixInforTFBlock.text.length == 0) {
            [FrankTools showAlertWithMessage:@"请输入您的姓名" withSuperView:self.view withHeih:DeviceMaxHeight/2];
            return ;
        }
        [self showHUDWithMessage:nil];
        NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],
                                     @"field":@"user_name",
                                     @"value":userFixInforTFBlock.text,
                                     @"token":[FrankTools getUserToken]};
        [MainRequest RequestHTTPData:PATH(@"api/user/changeUserinfo") parameters:parameters success:^(id responseData) {
            [self hideHUD];
            [self updateUserData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.delegate changeUserInforProAct:self.userFixInforTF.text andWhichTF:@"userName"];
                [self.navigationController popViewControllerAnimated:YES];
            });
        } failed:^(NSDictionary *errorDic) {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }];
    };
    if ([self.whichToFixStr isEqualToString:@"userEmail"]) {
        self.userFixInforTF.placeholder = @"填写个人邮箱";
        __block UITextField *userFixInforTFBlock = self.userFixInforTF;
        [self showHUDWithMessage:nil];
        NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],@"field":@"email",@"value":userFixInforTFBlock.text,@"token":[FrankTools getUserToken]};
        [MainRequest RequestHTTPData:PATH(@"api/user/changeUserinfo") parameters:parameters success:^(id responseData) {
            [self hideHUD];
            [self updateUserData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.delegate changeUserInforProAct:self.userFixInforTF.text andWhichTF:@"userEmail"];
                [self.navigationController popViewControllerAnimated:YES];
            });
        } failed:^(NSDictionary *errorDic) {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }];
    };
    if ([self.whichToFixStr isEqualToString:@"userWeChat"]) {
        self.userFixInforTF.placeholder = @"填写微信号码";
        __block UITextField *userFixInforTFBlock = _userFixInforTF;
        [self showHUDWithMessage:nil];
        NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],@"field":@"wx_account",@"value":userFixInforTFBlock.text,@"token":[FrankTools getUserToken]};
        [MainRequest RequestHTTPData:PATH(@"api/user/changeUserinfo") parameters:parameters success:^(id responseData) {
            [self hideHUD];
            [self updateUserData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.delegate changeUserInforProAct:self.userFixInforTF.text andWhichTF:@"userWeChat"];
                [self.navigationController popViewControllerAnimated:YES];
            });
        } failed:^(NSDictionary *errorDic) {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }];
    };
}
@end
