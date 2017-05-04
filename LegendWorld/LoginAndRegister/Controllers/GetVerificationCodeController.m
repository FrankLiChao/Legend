//
//  GetVerificationCodeController.m
//  LegendWorld
//
//  Created by wenrong on 16/10/31.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "GetVerificationCodeController.h"
#import "MainRequest.h"
#import "SetKeyOfRegisterViewController.h"
#import "SetKeyOfFindKeyViewController.h"
@interface GetVerificationCodeController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *nextStepBtn;
@property (weak, nonatomic) IBOutlet UIButton *verificationBtn;

@property (nonatomic, strong) NSTimer *countDownTimer;
@property (nonatomic) NSInteger secondsCountDown;
@property (nonatomic, strong) NSString *previousTextFieldContent;
@property (nonatomic, strong) UITextRange *previousSelection;
@property (nonatomic, strong) NSString *phoneStr;

@end

@implementation GetVerificationCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.ifFromRegister ? @"注册" : @"忘记密码";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.verificationBtn setTitleColor:[UIColor bodyTextColor] forState:UIControlStateNormal];
    [self.verificationBtn setTitleColor:[UIColor noteTextColor] forState:UIControlStateDisabled];
    
    [self.nextStepBtn setBackgroundImage:[UIImage backgroundImageWithColor:[UIColor themeColor] cornerRadius:6] forState:UIControlStateNormal];
    [self.nextStepBtn setBackgroundImage:[UIImage backgroundImageWithColor:[UIColor noteTextColor] cornerRadius:6] forState:UIControlStateDisabled];
    
    [self.phoneNumTF addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - Custom
- (IBAction)deleteAct:(UIButton *)sender {
    self.phoneNumTF.text = nil;
}

- (IBAction)sendVerificationAct:(UIButton *)sender {
    [self.view endEditing:YES];
    self.phoneStr = [self.phoneNumTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (![FrankTools isValidateMobile:self.phoneStr]) {
        [self showHUDWithResult:NO message:@"请输入正确的手机号码"];
        return;
    }
    if (self.ifFromRegister) {
        NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],
                                     @"use_area":@"1",
                                     @"msg_type":@"2",
                                     @"mobile_no":self.phoneStr};
        [self showHUDWithMessage:nil];
        [MainRequest RequestHTTPData:PATH(@"utility/message/sendMsg") parameters:parameters success:^(id responseData) {
            [self showHUDWithResult:YES message:@"验证码发送成功"];
            //设置倒计时总时长
            self.secondsCountDown = 60;//60秒倒计时
            //开始倒计时
            [self.verificationBtn setTitle:[NSString stringWithFormat:@"%ld秒后重新获取",(long)self.secondsCountDown] forState:UIControlStateNormal];
            self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
            self.verificationBtn.enabled = NO;
            
        } failed:^(NSDictionary *errorDic) {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }];
    } else {
        NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],
                                     @"use_area":@"1",
                                     @"msg_type":@"3",
                                     @"mobile_no":self.phoneStr};
        [self showHUDWithMessage:nil];
        [MainRequest RequestHTTPData:PATH(@"utility/message/sendMsg") parameters:parameters success:^(id responseData) {
            [self showHUDWithResult:YES message:@"验证码发送成功"];
            //设置倒计时总时长
            self.secondsCountDown = 60;//60秒倒计时
            //开始倒计时
            [self.verificationBtn setTitle:[NSString stringWithFormat:@"%ld秒后重新获取",(long)self.secondsCountDown] forState:UIControlStateNormal];
            self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
            self.verificationBtn.enabled = NO;
        } failed:^(NSDictionary *errorDic) {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }];
    }
}

- (IBAction)nextStepAct:(UIButton *)sender {
    self.phoneStr = [self.phoneNumTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (self.phoneStr.length <= 0) {
        [self showHUDWithResult:NO message:@"请填写手机号码"];
        return;
    }
    if (![FrankTools isValidateMobile:self.phoneStr]) {
        [self showHUDWithResult:NO message:@"请填写正确的手机号码"];
        return;
    }
    if (self.verificationCodeTF.text.length<6) {
        [self showHUDWithResult:NO message:@"请填写验证码,验证码是6位数字"];
        return;
    }
    if (self.ifFromRegister) {
        NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],
                                     @"mobile_no":self.phoneStr,
                                     @"sms_code":self.verificationCodeTF.text,
                                     @"use_area":@"1",@"msg_type":@"2",
                                     @"recommend_code":self.invitePerson};
        [self showHUDWithMessage:nil];
        [MainRequest RequestHTTPData:PATH(@"api/user/register") parameters:parameters success:^(id responseData) {
            [self hideHUD];
            [[LoginUserManager sharedManager] updateLoginUser:responseData];
            SetKeyOfRegisterViewController *setKeyOfRegisterVC = [[SetKeyOfRegisterViewController alloc] init];
            setKeyOfRegisterVC.accessToken = [responseData objectForKey:@"access_token"];
            setKeyOfRegisterVC.token = [responseData objectForKey:@"sms_token"];
            [self.navigationController pushViewController:setKeyOfRegisterVC animated:YES];
        } failed:^(NSDictionary *errorDic) {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }];
    }
    else{
        NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],@"use_area":@"1",@"msg_type":@3,@"mobile_no":self.phoneStr,@"sms_code":self.verificationCodeTF.text};
        [self showHUDWithMessage:nil];
        [MainRequest RequestHTTPData:PATH(@"utility/message/checkMsgCode") parameters:parameters success:^(id response) {
            [self showHUDWithResult:YES message:nil];
            SetKeyOfFindKeyViewController *setKeyOfFindKeyVC = [[SetKeyOfFindKeyViewController alloc] init];
            setKeyOfFindKeyVC.phoneNum = self.phoneStr;
            setKeyOfFindKeyVC.sms_token = [response objectForKey:@"sms_token"];
            setKeyOfFindKeyVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:setKeyOfFindKeyVC animated:YES];
        } failed:^(NSDictionary *errorDic) {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }];
    }
}

- (void)timeFireMethod {
    //倒计时-1
    self.secondsCountDown--;
    //修改倒计时标签现实内容
    [self.verificationBtn setTitle:[NSString stringWithFormat:@"%ld秒后重新获取",(long)self.secondsCountDown] forState:UIControlStateDisabled];
    self.verificationBtn.enabled = NO;
    //当倒计时到0时，做需要的操作，比如验证码过期不能提交
    if (self.secondsCountDown <= 0) {
        [self.countDownTimer invalidate];
        [self.verificationBtn setTitle:@"重新获取验证码" forState:UIControlStateNormal];
        self.verificationBtn.enabled = YES;
    }
}

#pragma mark - 改手机为3-4-4
- (void)textFieldEditingChanged:(UITextField *)textField {
    //限制手机账号长度（有两个空格）
    if (textField.text.length > 13) {
        textField.text = [textField.text substringToIndex:13];
    }
    
    NSUInteger targetCursorPosition = [textField offsetFromPosition:textField.beginningOfDocument toPosition:textField.selectedTextRange.start];
    
    NSString *currentStr = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *preStr = [self.previousTextFieldContent stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //正在执行删除操作时为0，否则为1
    char editFlag = 0;
    if (currentStr.length <= preStr.length) {
        editFlag = 0;
    }
    else {
        editFlag = 1;
    }
    
    NSMutableString *tempStr = [NSMutableString new];
    
    int spaceCount = 0;
    if (currentStr.length < 3 && currentStr.length > -1) {
        spaceCount = 0;
    }else if (currentStr.length < 7 && currentStr.length > 2) {
        spaceCount = 1;
    }else if (currentStr.length < 12 && currentStr.length > 6) {
        spaceCount = 2;
    }
    
    for (int i = 0; i < spaceCount; i++) {
        if (i == 0) {
            [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(0, 3)], @" "];
        }else if (i == 1) {
            [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(3, 4)], @" "];
        }else if (i == 2) {
            [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(7, 4)], @" "];
        }
    }
    
    if (currentStr.length == 11) {
        [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(7, 4)], @" "];
    }
    if (currentStr.length < 4) {
        [tempStr appendString:[currentStr substringWithRange:NSMakeRange(currentStr.length - currentStr.length % 3, currentStr.length % 3)]];
    }else if(currentStr.length > 3 && currentStr.length <12) {
        NSString *str = [currentStr substringFromIndex:3];
        [tempStr appendString:[str substringWithRange:NSMakeRange(str.length - str.length % 4, str.length % 4)]];
        if (currentStr.length == 11) {
            [tempStr deleteCharactersInRange:NSMakeRange(13, 1)];
        }
    }
    textField.text = tempStr;
    // 当前光标的偏移位置
    NSUInteger curTargetCursorPosition = targetCursorPosition;
    
    if (editFlag == 0) {
        //删除
        if (targetCursorPosition == 9 || targetCursorPosition == 4) {
            curTargetCursorPosition = targetCursorPosition - 1;
        }
    }else {
        //添加
        if (currentStr.length == 8 || currentStr.length == 4) {
            curTargetCursorPosition = targetCursorPosition + 1;
        }
    }
    UITextPosition *targetPosition = [textField positionFromPosition:[textField beginningOfDocument] offset:curTargetCursorPosition];
    [textField setSelectedTextRange:[textField textRangeFromPosition:targetPosition toPosition :targetPosition]];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSInteger length = textField.text.length - range.length + string.length;
    self.previousTextFieldContent = textField.text;
    self.previousSelection = textField.selectedTextRange;
    if (textField == self.phoneNumTF) {
        if (length > 13) {
            return NO;
        }
    } else if (textField == self.verificationCodeTF) {
        if (length > 6) {
            return NO;
        }
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
