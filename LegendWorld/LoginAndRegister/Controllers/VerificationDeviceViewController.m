//
//  VerificationDeviceViewController.m
//  LegendWorld
//
//  Created by Frank on 2016/11/21.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "VerificationDeviceViewController.h"

@interface VerificationDeviceViewController ()

@property (nonatomic,weak)UITextField *verifTx;
@property (nonatomic,weak)UIButton *getVerfyBtn;
@property (nonatomic,weak)UIButton *sureButton;
@property (strong, nonatomic) NSTimer *countDownTimer;
@property (nonatomic) NSInteger secondsCountDown;

@end

@implementation VerificationDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设备校验";
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
    UIImageView *logoIm = [UIImageView new];
    [logoIm setImage:imageWithName(@"LegendImg")];
    [self.view addSubview:logoIm];
    
    logoIm.sd_layout
    .centerXEqualToView(self.view)
    .yIs(85)
    .widthIs(76)
    .heightIs(55);
    
    UIButton *getVerfyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [getVerfyBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [getVerfyBtn setTitleColor:mainColor forState:UIControlStateNormal];
    getVerfyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    getVerfyBtn.layer.borderWidth = 0.5;
    getVerfyBtn.layer.borderColor = mainColor.CGColor;
    [getVerfyBtn addTarget:self action:@selector(getVerificationCode) forControlEvents:UIControlEventTouchUpInside];
    self.getVerfyBtn = getVerfyBtn;
    [self.view addSubview:getVerfyBtn];
    
    getVerfyBtn.sd_layout
    .topSpaceToView(logoIm,60)
    .widthIs(80)
    .rightSpaceToView(self.view,40)
    .heightIs(30);
    
    UITextField *verifTx = [UITextField new];
    verifTx.placeholder = @"请输入验证码";
    verifTx.textColor = contentTitleColorStr1;
    verifTx.font = [UIFont systemFontOfSize:14];
    verifTx.keyboardType = UIKeyboardTypeNumberPad;
    self.verifTx = verifTx;
    [verifTx addTarget:self action:@selector(verifEvent:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:verifTx];
    
    verifTx.sd_layout
    .leftSpaceToView(self.view,40)
    .rightSpaceToView(getVerfyBtn,0)
    .topSpaceToView(logoIm,50)
    .heightIs(40);
    
    UIView *lineV = [UIView new];
    lineV.backgroundColor = tableDefSepLineColor;
    [self.view addSubview:lineV];
    
    lineV.sd_layout
    .leftSpaceToView(self.view,40)
    .rightSpaceToView(self.view,40)
    .heightIs(0.5)
    .topSpaceToView(getVerfyBtn,0);
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"完成" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn setBackgroundImage:[UIImage backgroundImageWithColor:buttonGrayColor] forState:UIControlStateNormal];
    sureBtn.layer.cornerRadius = 6;
    sureBtn.layer.masksToBounds =  YES;
    sureBtn.enabled = NO;
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [sureBtn addTarget:self action:@selector(clickSureButton:) forControlEvents:UIControlEventTouchUpInside];
    self.sureButton = sureBtn;
    [self.view addSubview:sureBtn];
    
    sureBtn.sd_layout
    .leftSpaceToView(self.view,40)
    .rightSpaceToView(self.view,40)
    .heightIs(40)
    .topSpaceToView(getVerfyBtn,40);
    
}

-(void)clickSureButton:(UIButton *)button_{
    if (self.verifTx.text.length == 0) {
        [self showHUDWithResult:NO message:@"请输入验证码"];
        return;
    }
    if (self.verifTx.text.length != 6) {
        [self showHUDWithResult:NO message:@"请输入正确的验证码"];
        return;
    }
    self.sureButton.enabled = YES;
    NSDictionary *dic = @{@"device_id":[FrankTools getDeviceUUID],
                          @"use_area":@"1",
                          @"msg_type":@"1",
                          @"mobile_no":[NSString stringWithFormat:@"%@",self.mobile_no],
                          @"sms_code":[NSString stringWithFormat:@"%@",self.verifTx.text]};
    [self showHUD];
    [MainRequest RequestHTTPData:PATH(@"utility/message/checkMsgCode") parameters:dic success:^(id responseData) {
        [self hideHUD];
        FLLog(@"%@",responseData);
        [self.delegate checkUserDevice:[NSString stringWithFormat:@"%@",[responseData objectForKey:@"sms_token"]]];
        [self.navigationController popViewControllerAnimated:YES];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

-(void)getVerificationCode{
    NSDictionary *dic = @{@"token":[FrankTools getUserToken],
                          @"device_id":[FrankTools getDeviceUUID],
                          @"use_area":@"1",
                          @"msg_type":@"1",
                          @"mobile_no":[NSString stringWithFormat:@"%@",self.mobile_no]
                          };
    [self showHUDWithMessage:nil];
    [MainRequest RequestHTTPData:PATH(@"utility/message/sendMsg") parameters:dic success:^(id responseData) {
        [self showHUDWithResult:YES message:@"短信发送成功"];
        self.secondsCountDown = 60;//60秒倒计时
        //开始倒计时
        [self.getVerfyBtn setTitle:[NSString stringWithFormat:@"%ld秒获取",(long)self.secondsCountDown] forState:
         UIControlStateNormal];
        self.getVerfyBtn.layer.borderColor = contentTitleColorStr1.CGColor;
        [self.getVerfyBtn setTitleColor:contentTitleColorStr1 forState:UIControlStateNormal];
        self.getVerfyBtn.enabled = NO;
        self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
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
        self.getVerfyBtn.layer.borderColor = mainColor.CGColor;
        [self.getVerfyBtn setTitleColor:mainColor forState:UIControlStateNormal];
        self.getVerfyBtn.enabled = YES;
    }
    
}

-(void)verifEvent:(UITextField *)textField_{
    if (self.verifTx.text.length == 6) {
        [self.sureButton setBackgroundImage:[UIImage backgroundImageWithColor:mainColor] forState:UIControlStateNormal];
        self.sureButton.enabled = YES;
    }else{
        [self.sureButton setBackgroundImage:[UIImage backgroundImageWithColor:buttonGrayColor] forState:UIControlStateNormal];
        self.sureButton.enabled = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
