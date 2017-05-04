//
//  CashPasswordSetingSecondViewController.m
//  legend
//
//  Created by heyk on 15/12/1.
//  Copyright © 2015年 e3mo. All rights reserved.
//

#import "CashPasswordSetingSecondViewController.h"
#import "MainRequest.h"

static  int cashPassowrdCount = 6;

@interface CashPasswordSetingSecondViewController ()<UITextFieldDelegate>{

    UITextField *responsTextField;
    BOOL bOnFisrtPage;
    NSString *firstPassword;
    
}

@end

@implementation CashPasswordSetingSecondViewController


-(void)dealloc{

    [responsTextField resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置提现密码";
    self.inPutHeight.constant = 45*widthRate;
    self.tipLabel.font = [UIFont systemFontOfSize:14*widthRate];
     self.messageLabel.font = [UIFont systemFontOfSize:14*widthRate];
    self.messageLabel.textColor = mainColor;
    
    CALayer * downButtonLayer = [_inputView layer];
    [downButtonLayer setMasksToBounds:YES];
    [downButtonLayer setCornerRadius:0];
    [downButtonLayer setBorderWidth:1];
    [downButtonLayer setBorderColor:mainColor.CGColor];
    
    
    responsTextField = [[UITextField alloc] init];
    responsTextField.delegate = self;
    
    [self.view addSubview:responsTextField];
    responsTextField.keyboardType = UIKeyboardTypeNumberPad;
    [responsTextField becomeFirstResponder];
    
    bOnFisrtPage = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged) name:UITextFieldTextDidChangeNotification object:nil];
    
    [self setBord];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    FLLog(@"点击事件");
    [responsTextField becomeFirstResponder];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [responsTextField becomeFirstResponder];
}

-(void)setBord{
    for (int i=0; i<cashPassowrdCount-1; i++) {
        UIView *view = [_inputView viewWithTag:i+1];
        if (view) {
            float w = ([UIScreen mainScreen].bounds.size.width- 20)/6;
            CALayer *TopBorder = [CALayer layer];
            TopBorder.frame = CGRectMake(w, 0.0f,1, self.inPutHeight.constant);
            TopBorder.backgroundColor = [UIColor colorWithRed:229.0/255 green:218.0/255 blue:217.0/255 alpha:1].CGColor;
            [view.layer addSublayer:TopBorder];
        }

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startSeting{
      [responsTextField resignFirstResponder];
    [self showHUDWithMessage:@"设置中..."];
    NSString *passwordKey = [NSString stringWithFormat:@"%@%@",responsTextField.text,DES_KEY];
    NSString *md5Password = [[FrankTools sharedInstance] getMd5_32Bit_String:passwordKey];
    NSDictionary *dic = @{@"device_id":[FrankTools getDeviceUUID],
                          @"payment_pwd":md5Password?md5Password:@"",
                          @"token":[FrankTools getUserToken]
                          };
    [MainRequest RequestHTTPData:PATH(@"api/user/setPaymentPassword") parameters:dic success:^(id responseData) {
        responsTextField.text = @"";
        [self showHUDWithResult:YES message:@"设置成功"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:havePayPassword];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (self.navigationController.viewControllers.count>=3) {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-3] animated:YES];
        }
        else   [self.navigationController popToRootViewControllerAnimated:YES];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        [responsTextField becomeFirstResponder];
        [self toFistPage];
    }];
}


#pragma mark  UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    NSMutableString *str = [NSMutableString stringWithString:textField.text];
    if ([string isEqualToString:@""]) {
        [str replaceCharactersInRange:NSMakeRange(str.length - 1, 1) withString:@""];
    }
    else   [str appendString:string];
    
    if (str.length>cashPassowrdCount) {
        return NO;
    }
    
    return YES;

}

-(void)toFistPage{

    self.tipLabel.text = @"请设置传说提现密码用于提现";
    firstPassword = nil;
    responsTextField.text = nil;
    [self textChanged];
    [UIView animateWithDuration:0.25
                     animations:^{
                         
                         CGRect frame = _inputView.frame;
                         frame.origin.x = DeviceMaxWidth;
                         
                         _inputView.frame = frame;
                         
                     } completion:^(BOOL finished) {
                         
                         CGRect frame = _inputView.frame;
                         frame.origin.x = 10;
                         _inputView.frame = frame;
                         
                         bOnFisrtPage = YES;
                         
                     }];
}

-(void)toSecondPage{
    self.tipLabel.text = @"请再次输入密码";
    firstPassword = responsTextField.text;
    responsTextField.text = nil;
    [self textChanged];
    self.messageLabel.text = nil;
    [UIView animateWithDuration:0.25
                     animations:^{
                         
                         CGRect frame = _inputView.frame;
                         frame.origin.x = -DeviceMaxWidth;
                         
                         _inputView.frame = frame;
                         
                     } completion:^(BOOL finished) {
                         
                         CGRect frame = _inputView.frame;
                         frame.origin.x = 10;
                         _inputView.frame = frame;
                         
                         bOnFisrtPage = NO;
                         
                     }];
}

-(void)judageContent{

    if (![responsTextField.text isEqualToString:firstPassword]) {
        
        self.messageLabel.text = @"两次输入密码不一致";
        [self toFistPage];
    }
    else{
        [self startSeting];
    }
}


-(void)textChanged{

    for (int i=0; i<cashPassowrdCount; i++) {
        
        int tag = i+1;
        UIImageView *imageV = [_inputView viewWithTag:tag];
        if (imageV) {
            
            if (responsTextField.text.length >=tag) imageV.image = [UIImage imageNamed:@"yuan"];
            else{
                imageV.image = nil;
                FLLog(@"---");
            }
            
        }
        
    }
    
    if (responsTextField.text.length == cashPassowrdCount) {
        if (bOnFisrtPage) {
            [self toSecondPage];
        }
        else{
            [self judageContent];
        }
        
    }
    
}

@end
