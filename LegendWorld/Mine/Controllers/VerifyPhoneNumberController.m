//
//  VerifyPhoneNumberController.m
//  LegendWorld
//
//  Created by Frank on 2016/11/7.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "VerifyPhoneNumberController.h"

@interface VerifyPhoneNumberController ()

@property (nonatomic,weak)UITextField *verifTx;
@property (nonatomic,weak)UILabel   *tipLab;
@property (nonatomic,weak)UIButton *getVerfyBtn;
@property (nonatomic,weak)UIButton *sureButton;
@property (strong, nonatomic) NSTimer *countDownTimer;
@property (nonatomic) NSInteger secondsCountDown;

@end

@implementation VerifyPhoneNumberController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"短信验证";
    [self initFrameView];
    
    __weak typeof(self) weakSelf = self;
    self.backBarBtnEvent = ^{
        if (weakSelf.countDownTimer) {
            [weakSelf.countDownTimer invalidate];
            weakSelf.countDownTimer = nil;
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}

-(void)initFrameView{
    
    self.view.backgroundColor = viewColor;
    UILabel *phoneLab = [[UILabel alloc] initWithFrame:CGRectMake(15*widthRate, 0, DeviceMaxWidth-30*widthRate, 40)];
    phoneLab.text = [NSString stringWithFormat:@"验证码发送至手机%@",[FrankTools replacePhoneNumber:[_addBankDic objectForKey:@"mobile"]]];
    phoneLab.textColor = contentTitleColorStr2;
    phoneLab.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:phoneLab];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, DeviceMaxWidth, 40)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UIButton *yLab = [UIButton buttonWithType:UIButtonTypeCustom];
    yLab.frame = CGRectMake(15*widthRate, 0, 80, 40);
    [yLab setTitle:@"验证码" forState:UIControlStateNormal];
    [yLab setTitleColor:contentTitleColorStr1 forState:UIControlStateNormal];
    yLab.titleLabel.font = [UIFont systemFontOfSize:16];
    [yLab setImage:imageWithName(@"phoneNum") forState:UIControlStateNormal];
    yLab.imageEdgeInsets = UIEdgeInsetsMake(0,0,0,yLab.titleLabel.bounds.size.width+8);
    [bgView addSubview:yLab];
    
    UIButton *getVerfyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [getVerfyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getVerfyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    getVerfyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    getVerfyBtn.backgroundColor = mainColor;
    getVerfyBtn.frame = CGRectMake(DeviceMaxWidth-90*widthRate, 0, 90*widthRate, 40);
    [getVerfyBtn addTarget:self action:@selector(getVerificationCode) forControlEvents:UIControlEventTouchUpInside];
    self.getVerfyBtn = getVerfyBtn;
    [bgView addSubview:getVerfyBtn];
    
    UITextField *verifTx = [UITextField new];
    verifTx.placeholder = @"短信验证码";
    verifTx.textColor = contentTitleColorStr1;
    verifTx.font = [UIFont systemFontOfSize:14];
    verifTx.keyboardType = UIKeyboardTypeNumberPad;
    self.verifTx = verifTx;
    [verifTx addTarget:self action:@selector(verifEvent:) forControlEvents:UIControlEventEditingChanged];
    [bgView addSubview:verifTx];
    
    verifTx.sd_layout
    .leftSpaceToView(yLab,10*widthRate)
    .rightSpaceToView(getVerfyBtn,10*widthRate)
    .topSpaceToView(bgView,0)
    .heightIs(40);
    
    UILabel *tipLab = [UILabel new];
    tipLab.textColor = mainColor;
    tipLab.font = [UIFont systemFontOfSize:12];
    tipLab.textAlignment = NSTextAlignmentCenter;
    self.tipLab = tipLab;
    [self.view addSubview:tipLab];
    
    tipLab.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(bgView,30)
    .widthIs(DeviceMaxWidth-30)
    .heightIs(20);
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"完成" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    sureBtn.backgroundColor = buttonGrayColor;
    sureBtn.enabled = NO;
    sureBtn.layer.cornerRadius = 6;
    sureBtn.layer.masksToBounds = YES;
    [sureBtn addTarget:self action:@selector(addBankCardEvent) forControlEvents:UIControlEventTouchUpInside];
    self.sureButton = sureBtn;
    [self.view addSubview:sureBtn];
    
    sureBtn.sd_layout
    .leftSpaceToView(self.view,40*widthRate)
    .rightSpaceToView(self.view,40*widthRate)
    .topSpaceToView(bgView,60*widthRate)
    .heightIs(40);
    
}

-(void)verifEvent:(UITextField *)textFied_{
    if (self.verifTx.text.length>0 && self.verifTx.text.length<=6) {
        self.sureButton.backgroundColor = mainColor;
        self.sureButton.enabled = YES;
    }else{
        self.sureButton.backgroundColor = buttonGrayColor;
        self.sureButton.enabled = NO;
    }
}

-(void)addBankCardEvent{
    [self.view endEditing:YES];
    if (self.verifTx.text.length == 0) {
        self.tipLab.text = @"请输入短信验证码";
    }
    NSDictionary *dic = @{@"device_id":[FrankTools getDeviceUUID],
                          @"use_area":@"1",
                          @"msg_type":@"22",
                          @"mobile_no":[NSString stringWithFormat:@"%@",[_addBankDic objectForKey:@"mobile"]],
                          @"sms_code":[NSString stringWithFormat:@"%@",self.verifTx.text]};
    [self showHUDWithMessage:nil];
    [MainRequest RequestHTTPData:PATH(@"utility/message/checkMsgCode") parameters:dic success:^(id responseData) {
        NSDictionary *dic = @{@"token":[FrankTools getUserToken],
                              @"device_id":[FrankTools getDeviceUUID],
                              @"bank_id":[NSString stringWithFormat:@"%@",[_addBankDic objectForKey:@"bank_id"]],
                              @"bank_no":[NSString stringWithFormat:@"%@",[_addBankDic objectForKey:@"bank_no"]],
                              @"real_name":[NSString stringWithFormat:@"%@",[_addBankDic objectForKey:@"real_name"]],
                              @"ID_card":[NSString stringWithFormat:@"%@",[_addBankDic objectForKey:@"ID_card"]],
                              @"mobile":[NSString stringWithFormat:@"%@",[_addBankDic objectForKey:@"mobile"]],
                              @"sms_token":[NSString stringWithFormat:@"%@",[responseData objectForKey:@"sms_token"]]};
        [MainRequest RequestHTTPData:PATH(@"api/Cash/addBankCard") parameters:dic success:^(id responseData) {
            FLLog(@"%@",responseData);
            [self showHUDWithResult:YES message:@"添加银行卡成功"];
            NSArray *viewArray = self.navigationController.viewControllers;
            if (viewArray.count>2) {
                if (self.countDownTimer) {
                    [self.countDownTimer invalidate];
                    self.countDownTimer = nil;
                }
                [self.navigationController popToViewController:viewArray[2] animated:YES];
                
            }
        } failed:^(NSDictionary *errorDic) {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];

}

- (void)getVerificationCode{
    NSDictionary *dic = @{@"token":[FrankTools getUserToken],
                          @"device_id":[FrankTools getDeviceUUID],
                          @"use_area":@"1",
                          @"msg_type":@"22",
                          @"mobile_no":[NSString stringWithFormat:@"%@",[_addBankDic objectForKey:@"mobile"]]};
    [self showHUD];
    [MainRequest RequestHTTPData:PATH(@"utility/message/sendMsg") parameters:dic success:^(id responseData) {
        self.secondsCountDown = 60;//60秒倒计时
        [self.getVerfyBtn setTitle:[NSString stringWithFormat:@"%ld秒获取",(long)self.secondsCountDown] forState:UIControlStateNormal];
        self.getVerfyBtn.backgroundColor = buttonGrayColor;
        self.getVerfyBtn.enabled = NO;
        self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
        [self showHUDWithResult:YES message:@"验证码发送成功"];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

-(void)timeFireMethod
{
    //倒计时-1
    self.secondsCountDown--;
    //修改倒计时标签现实内容
    [self.getVerfyBtn setTitle:[NSString stringWithFormat:@"%ld秒获取",(long)self.secondsCountDown] forState:UIControlStateNormal];
    self.getVerfyBtn.enabled = NO;
    //当倒计时到0时，做需要的操作，比如验证码过期不能提交
    if(self.secondsCountDown==0){
        [self.countDownTimer invalidate];
        [self.getVerfyBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        self.getVerfyBtn.backgroundColor = mainColor;
        self.getVerfyBtn.enabled = YES;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
