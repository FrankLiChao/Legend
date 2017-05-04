//
//  BankWithdrawViewController.m
//  LegendWorld
//
//  Created by ios-dev-01 on 16/9/20.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "BankWithdrawViewController.h"
#import "EnterPasswordView.h"
#import "WithdrawResultViewController.h"
#import "VerificationForPayKeyViewController.h"
#import "SetPayKeyViewController.h"

@interface BankWithdrawViewController ()<UIAlertViewDelegate>

@property(weak,nonatomic)UILabel *bankName;
@property(weak,nonatomic)UITextField *moneyTx;
@property(strong,nonatomic)NSString *increment;

@end

@implementation BankWithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现（银行卡）";
    [self initFrameView];
}

-(void)initFrameView
{
    self.view.backgroundColor = viewColor;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 30*widthRate, DeviceMaxWidth, 80)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UILabel *bankType = [[UILabel alloc] initWithFrame:CGRectMake(15*widthRate, 0, 50, 40)];
    bankType.text = @"储蓄卡";
    bankType.textColor = contentTitleColorStr;
    bankType.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:bankType];
    
    UILabel *bankName = [UILabel new];
    bankName.text = [NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"bank_name"]];
    bankName.textColor = mainColor;
    bankName.font = [UIFont systemFontOfSize:15];
    self.bankName = bankName;
    [bgView addSubview:self.bankName];
    
    self.bankName.sd_layout
    .leftSpaceToView(bankType,20*widthRate)
    .topEqualToView(bankType)
    .widthIs(250)
    .heightIs(40);
    
    UIImageView *arrowImage = [UIImageView new];
    [arrowImage setImage:imageWithName(@"down_arrow")];
    [bgView addSubview:arrowImage];
    
    arrowImage.sd_layout
    .rightSpaceToView(bgView,15*widthRate)
    .centerYEqualToView(bankType)
    .widthIs(12)
    .heightEqualToWidth();
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(10*widthRate, 40-0.5, DeviceMaxWidth-10*widthRate, 0.5)];
    lineV.backgroundColor = tableDefSepLineColor;
    [bgView addSubview:lineV];
    
    UILabel *moneyLab = [UILabel new];
    moneyLab.text = @" 金  额";
    moneyLab.font = [UIFont systemFontOfSize:15];
    moneyLab.textColor = contentTitleColorStr;
    [bgView addSubview:moneyLab];
    
    moneyLab.sd_layout
    .leftEqualToView(bankType)
    .topSpaceToView(lineV,0)
    .widthRatioToView(bankType,1)
    .heightIs(40);
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userLoginDataToLocal"];
    self.increment = [dic objectForKey:@"money"];
    FLLog(@"dic = %@",dic);
    UITextField *moneyTx = [UITextField new];
    moneyTx.placeholder = [NSString stringWithFormat:@"当前可提现金额：￥%@",_increment?_increment:@""];
    moneyTx.textColor = contentTitleColorStr;
    moneyTx.keyboardType = UIKeyboardTypeDecimalPad;
    moneyTx.font = [UIFont systemFontOfSize:15];
    self.moneyTx = moneyTx;
    [bgView addSubview:self.moneyTx];
    
    self.moneyTx.sd_layout
    .leftEqualToView(bankName)
    .topEqualToView(moneyLab)
    .widthRatioToView(bankName,1)
    .heightRatioToView(bankName,1);
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 80-0.5, DeviceMaxWidth, 0.5)];
    lineView.backgroundColor = tableDefSepLineColor;
    [bgView addSubview:lineView];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"提交" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    sureBtn.backgroundColor = mainColor;
    sureBtn.layer.cornerRadius = 4;
    sureBtn.layer.masksToBounds = YES;
    [sureBtn addTarget:self action:@selector(clickSureBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    
    sureBtn.sd_layout
    .leftSpaceToView(self.view,40*widthRate)
    .rightSpaceToView(self.view,40*widthRate)
    .heightIs(40*widthRate)
    .topSpaceToView(bgView,30*widthRate);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.moneyTx resignFirstResponder];
}

-(void)clickSureBtnEvent
{
    [self.moneyTx resignFirstResponder];
    if (self.moneyTx.text.length <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入提现金额" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }else{
        int money_num = [self.moneyTx.text intValue];
        int incrementX = [_increment intValue];
        if (money_num > incrementX) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"余额不足" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return;
        }
    }
    
    [self enterMyPayPassword];
}

-(void)showPasswordErrorAlter{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"密码错误"
                                                   delegate:self
                                          cancelButtonTitle:@"重试"
                                          otherButtonTitles:@"忘记密码", nil];
    alter.tag = 1;
    [alter show];
}

- (void)enterMyPayPassword{
    if ([FrankTools isPayPassword]) {
        [EnterPasswordView showWithContent:self.moneyTx.text comple:^(NSString *password) {
            [self showHUD];
            NSString *passwordKey = [NSString stringWithFormat:@"%@%@",password,DES_KEY];
            NSString *md5Password = [[FrankTools sharedInstance] getMd5_32Bit_String:passwordKey];
            NSDictionary *dic = @{@"device_id":[FrankTools getDeviceUUID],
                                  @"token":[FrankTools getUserToken],
                                  @"payment_pwd":md5Password?md5Password:@""
                                  };
            
            [MainRequest RequestHTTPData:PATH(@"api/user/checkPaymentPassword") parameters:dic success:^(id responseData) {
                [self hideHUD];
                [self takeCashRequestBankId:password];
            } failed:^(NSDictionary *errorDic) {
                if ([[errorDic objectForKey:@"error_code"] integerValue] == 2042101) {
                    [self hideHUD];
                    [self showPasswordErrorAlter];
                } else {
                    [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
                }
            }];
        }];
    } else {
        [self showSetPasswordVC];
    }
}

#pragma - mark 忘记密码
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        //-- 密码错误Alert
        if (buttonIndex == 0) {
            //-- 重试
            [self enterMyPayPassword];
        } else if (buttonIndex == 1) {
            //-- 忘记密码
            VerificationForPayKeyViewController *verifiVc = [VerificationForPayKeyViewController new];
            [self.navigationController pushViewController:verifiVc animated:YES];
        }
    }
}

- (void)takeCashRequestBankId:(NSString *)password{
    [self showHUD];
    NSString *bank_id = [NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"card_id"]];//id
    NSString *passwordKey = [NSString stringWithFormat:@"%@%@",password,DES_KEY];
    NSString *md5Password = [[FrankTools sharedInstance] getMd5_32Bit_String:passwordKey];
    NSDictionary *dic = @{@"device_id":[FrankTools getDeviceUUID],
                          @"token":[FrankTools getUserToken],
                          @"bank_id":bank_id?bank_id:@"",
                          @"money":self.moneyTx.text?self.moneyTx.text:@"",
                          @"payment_pwd":md5Password?md5Password:@"",
                          @"type":@"1"};
    [MainRequest RequestHTTPData:PATH(@"api/cash/takeCash") parameters:dic success:^(id responseData) {
        [self hideHUD];
        [self toBankResultViewController];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

- (void)toBankResultViewController{
    WithdrawResultViewController *resultVc = [WithdrawResultViewController new];
    resultVc.moneyStr = [NSString stringWithFormat:@"%@",self.moneyTx.text?self.moneyTx.text:@""];
    NSString *bankStr = [_dataDic objectForKey:@"card_no"];
    resultVc.bankDetail = [NSString stringWithFormat:@"%@ (尾号%@)",[_dataDic objectForKey:@"bank_name"],[bankStr substringFromIndex:bankStr.length-4]];
    [self.navigationController pushViewController:resultVc animated:YES];
}

- (void)showSetPasswordVC
{
    SetPayKeyViewController *setVc = [SetPayKeyViewController new];
    [self.navigationController pushViewController:setVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
