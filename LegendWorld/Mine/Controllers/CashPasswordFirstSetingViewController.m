//
//  CashPasswordFirstSetingViewController.m
//  legend
//
//  Created by heyk on 15/12/1.
//  Copyright © 2015年 e3mo. All rights reserved.
//

#import "CashPasswordFirstSetingViewController.h"
#import "CashPasswordSetingSecondViewController.h"
#import "MainRequest.h"

@interface CashPasswordFirstSetingViewController (){
    
    NSTimer *timer;
    int count;
}

@end

@implementation CashPasswordFirstSetingViewController

- (void)dealloc{

    if (timer && [timer isValid]) {
        [timer invalidate];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置提现密码";
    UserModel *model = [LoginUserManager sharedManager].loginUser;
   //获取手机号
    NSString *noticeStr = [NSString stringWithFormat:@"请输入手机号%@收到的验证码",model.mobile_no];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:noticeStr];
    [str addAttribute:NSForegroundColorAttributeName  value:contentTitleColorStr  range:NSMakeRange(0, str.length)];
    [str addAttribute:NSForegroundColorAttributeName  value:mainColor  range:NSMakeRange(6, noticeStr.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14*widthRate] range:NSMakeRange(0, str.length)];
    _phoneNumLabel.attributedText = str;
    
    _verifyCodeField.textColor = contentTitleColorStr;
    
    [self setFlat:_verifyCodeBackView radius:4 color:contentTitleColorStr1 borderWith:1];
    [self setFlat:_verifyCodeSendButton radius:4 color:mainColor borderWith:1];
    [self setFlat:_verifyButton radius:4 color:mainColor borderWith:1];

    
    
    [self.verifyCodeSendButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.verifyCodeSendButton setTitleColor:mainColor forState:UIControlStateNormal];
    
    self.verifyCodeSendButton.titleLabel.font = [UIFont systemFontOfSize:15*widthRate];
    self.verifyButton.titleLabel.font = [UIFont systemFontOfSize:17*widthRate];
    self.verifyCodeField.font = [UIFont systemFontOfSize:15*widthRate];
    
    self.verifyBackHeight.constant = 44*widthRate;
    self.getVerifyCodeButtonHeight.constant = 44*widthRate;
    self.verifyButtonHeight.constant = 42*widthRate;
    
    self.verifyButton.alpha = 0.5;
    self.verifyButton.enabled = NO;
    
    [_verifyCodeField becomeFirstResponder];
}

-(void)setFlat:(UIView*)view radius:(CGFloat)radius color:(UIColor*)color borderWith:(CGFloat)borderWith
{
    CALayer * downButtonLayer = [view layer];
    [downButtonLayer setMasksToBounds:YES];
    [downButtonLayer setCornerRadius:radius];
    [downButtonLayer setBorderWidth:borderWith];
    [downButtonLayer setBorderColor:[color CGColor]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)timerAction{
    
    count--;
    if (count>0) {
        [self.verifyCodeSendButton setTitle:[NSString stringWithFormat:@"(%d)重新获取",count] forState:UIControlStateNormal];
    }
    else{
        if ([timer isValid]) {
            [timer invalidate];
        }
        [self setFlat:_verifyCodeSendButton radius:5 color:mainColor borderWith:0.5];
        [self.verifyCodeSendButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.verifyCodeSendButton setTitleColor:mainColor forState:UIControlStateNormal];
        
        count = 0;
    }
}

-(IBAction)clickGetVerifyCodeButton:(id)sender{
    [self.view endEditing:YES];
    UserModel *model = [LoginUserManager sharedManager].loginUser;
    if (count==0) {
        [self showHUD];
        NSDictionary *dic = @{@"device_id":[FrankTools getDeviceUUID],
                              @"token":[FrankTools getUserToken],
                              @"mobile_no":model.mobile_no?model.mobile_no:@"",
                              @"msg_type":@"9",
                              @"use_area":@"1"};
        [MainRequest RequestHTTPData:PATH(@"utility/message/sendMsg") parameters:dic success:^(id responseData) {
            count = 60;
            [self.verifyCodeSendButton setTitleColor:contentTitleColorStr1 forState:UIControlStateNormal];
            [self setFlat:_verifyCodeSendButton radius:5 color:contentTitleColorStr1 borderWith:0.5];
            [self.verifyCodeSendButton setTitle:[NSString stringWithFormat:@"(%d)重新获取",count] forState:UIControlStateNormal];
            
            if (timer.valid) {
                [timer invalidate];
            }
            timer =  [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(timerAction) userInfo:nil repeats:count];
            [self showHUDWithResult:YES message:@"短信发送成功"];
        } failed:^(NSDictionary *errorDic) {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }];
    }
}


- (IBAction)clickVerifyButton:(id)sender{
    UserModel *model = [LoginUserManager sharedManager].loginUser;
    if (![FrankTools isNull:self.verifyCodeField.text]) {
        NSDictionary *dic = @{@"device_id":[FrankTools getDeviceUUID],
                              @"mobile_no":model.mobile_no?model.mobile_no:@"",
                              @"use_area":@"1",
                              @"msg_type":@"9",
                              @"sms_code":self.verifyCodeField.text};
        [self showHUD];
        [MainRequest RequestHTTPData:PATH(@"utility/message/checkMsgCode") parameters:dic success:^(id responseData) {
            [self hideHUD];
            CashPasswordSetingSecondViewController *vc = [[CashPasswordSetingSecondViewController alloc] initWithNibName:@"CashPasswordSetingSecondViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        } failed:^(NSDictionary *errorDic) {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }];
    }
}

#pragma mark textField delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;{
    if ([self judageTextIsVaild:textField.text newText:string]) {
        self.verifyButton.alpha = 1;
        self.verifyButton.enabled = YES;
    }
    else{
        self.verifyButton.alpha = 0.5;
        self.verifyButton.enabled = NO;
    }
    return YES;
}

-(BOOL)judageTextIsVaild:(NSString*)str newText:(NSString*)str1{
    
    if ([str1 isEqualToString:@""]) {
        if (!str || [str isEqualToString:@""]) {
            return NO;
        }
        else{
            NSMutableString *newStr = [NSMutableString stringWithString:str];
            [newStr replaceCharactersInRange:NSMakeRange(str.length - 1, 1) withString:@""];
            if ([FrankTools isNull:newStr]) {
                return NO;
            }
            else return YES;
        }
    }
    return YES;
}

@end
