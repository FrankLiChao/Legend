//
//  MyCardDetailsViewController.m
//  LegendWorld
//
//  Created by Frank on 2016/10/31.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "MyCardDetailsViewController.h"
#import "EnterPasswordView.h"
#import "VerificationForPayKeyViewController.h"
#import "SetPayKeyViewController.h"

@interface MyCardDetailsViewController ()<UIAlertViewDelegate>

@end

@implementation MyCardDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"银行卡详情";
    [self initFrameView];
}

-(void)initFrameView{
    FLLog(@"%@",_dataDic);
    self.view.backgroundColor = viewColor;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 150*widthRate)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UIImageView *logoIm = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15*widthRate, 50*widthRate, 50*widthRate)];
    [FrankTools setImgWithImgView:logoIm withImageUrl:[_dataDic objectForKey:@"bank_logo"] withPlaceHolderImage:placeSquareImg];
    [bgView addSubview:logoIm];
    
    UILabel *nameLab = [UILabel new];
    nameLab.text = [NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"bank_name"]];
    nameLab.textColor = contentTitleColorStr1;
    nameLab.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:nameLab];
    
    nameLab.sd_layout
    .leftSpaceToView(logoIm,15)
    .topSpaceToView(bgView,15*widthRate)
    .rightSpaceToView(bgView,15)
    .heightIs(20*widthRate);
    
    UILabel *detailLab = [UILabel new];
    detailLab.text = [NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"card_no"]];
    detailLab.textColor = contentTitleColorStr2;
    detailLab.font = [UIFont systemFontOfSize:13];
    [bgView addSubview:detailLab];
    
    detailLab.sd_layout
    .leftEqualToView(nameLab)
    .topSpaceToView(nameLab,5*widthRate)
    .rightEqualToView(nameLab)
    .heightIs(20*widthRate);
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(15, 70*widthRate-0.5, DeviceMaxWidth-15, 0.5)];
    lineV.backgroundColor = tableDefSepLineColor;
    [bgView addSubview:lineV];
    
    UILabel *oneLimitLab = [UILabel new];
    oneLimitLab.text = @"单笔提现限额";
    oneLimitLab.textColor = contentTitleColorStr1;
    oneLimitLab.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:oneLimitLab];
    
    oneLimitLab.sd_layout
    .leftSpaceToView(bgView,15)
    .topSpaceToView(lineV,0)
    .widthIs(150)
    .heightIs(40*widthRate);
    
    UILabel *oneLimitMoney = [UILabel new];
    oneLimitMoney.text = @"5000元";
    oneLimitMoney.textColor = contentTitleColorStr1;
    oneLimitMoney.font = [UIFont systemFontOfSize:16];
    oneLimitMoney.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:oneLimitMoney];
    
    oneLimitMoney.sd_layout
    .rightSpaceToView(bgView,15)
    .topEqualToView(oneLimitLab)
    .widthIs(150)
    .heightIs(40*widthRate);
    
    UIView *lineVV = [[UIView alloc] initWithFrame:CGRectMake(15, 110*widthRate-0.5, DeviceMaxWidth-15, 0.5)];
    lineVV.backgroundColor = tableDefSepLineColor;
    [bgView addSubview:lineVV];
    
    UILabel *dayLimitLab = [UILabel new];
    dayLimitLab.text = @"每日提现限额";
    dayLimitLab.textColor = contentTitleColorStr1;
    dayLimitLab.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:dayLimitLab];
    
    dayLimitLab.sd_layout
    .leftSpaceToView(bgView,15)
    .topSpaceToView(lineVV,0)
    .widthIs(150)
    .heightIs(40*widthRate);
    
    UILabel *dayLimitMoney = [UILabel new];
    dayLimitMoney.text = @"20000元";
    dayLimitMoney.textColor = contentTitleColorStr1;
    dayLimitMoney.font = [UIFont systemFontOfSize:16];
    dayLimitMoney.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:dayLimitMoney];
    
    dayLimitMoney.sd_layout
    .rightSpaceToView(bgView,15)
    .topEqualToView(dayLimitLab)
    .widthIs(150)
    .heightIs(40*widthRate);
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setTitle:@"解除绑定" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    deleteBtn.backgroundColor = mainColor;
    deleteBtn.layer.cornerRadius = 6;
    deleteBtn.layer.masksToBounds = YES;
    [deleteBtn addTarget:self action:@selector(clickDeleteButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteBtn];
    
    deleteBtn.sd_layout
    .leftSpaceToView(self.view,40*widthRate)
    .rightSpaceToView(self.view,40*widthRate)
    .topSpaceToView(bgView,60)
    .heightIs(40);
}

-(void)clickDeleteButtonEvent{
    [self enterMyPayPassword];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"是否删除该银行卡!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"确定", nil];
//    [alert show];
}

-(void)enterMyPayPassword
{
    FLLog(@"%d",[FrankTools isPayPassword]);
    if ([FrankTools isPayPassword]) {//密码验证
        __weak typeof(self) weakSelf = self;
        
        [EnterPasswordView showWithContent:nil comple:^(NSString *password) {
            
            NSDictionary *dic = @{@"device_id":[FrankTools getDeviceUUID],
                                  @"token":[FrankTools getUserToken]};
            NSMutableDictionary *muDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
            NSString *passwordKey = [NSString stringWithFormat:@"%@%@",password,DES_KEY];
            NSString *md5Password = [[FrankTools sharedInstance] getMd5_32Bit_String:passwordKey];
            
            [muDic setObject:md5Password?md5Password:@"" forKey:@"payment_pwd"];
            
            [MainRequest RequestHTTPData:PATH(@"api/user/checkPaymentPassword") parameters:muDic success:^(id responseData) {
                [self deleteBankCard];
            } failed:^(NSDictionary *errorDic) {
                //显示找回密码
                if ([[errorDic objectForKey:@"error_code"] integerValue] == 2042101) {
                    [weakSelf showPasswordErrorAlter];
                }else{
                    [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
                }
            }];
        }];
    }
    else{
        [self showSetPasswordVC];
    }
}

#pragma makr UIAlertView delegate
-(void)showSetPasswordVC{
    SetPayKeyViewController *setVc = [SetPayKeyViewController new];
    [self.navigationController pushViewController:setVc animated:YES];
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

#pragma - mark 忘记密码
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1)
    {
        //-- 密码错误Alert
        if (buttonIndex == 0)
        {
            //-- 重试
            [self enterMyPayPassword];
        }
        else if (buttonIndex == 1)
        {
            //-- 忘记密码
            VerificationForPayKeyViewController *verifiVc = [VerificationForPayKeyViewController new];
            [self.navigationController pushViewController:verifiVc animated:YES];
        }
    }
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 1) {
//        FLLog(@"确定删除");
//        [self deleteBankCard];
//    }
//}

-(void)deleteBankCard
{
    __weak typeof (self) weakSelf = self;
    [self showHUD];
    NSString *banId = [NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"card_id"]];
    NSDictionary *dic = @{@"bank_id":banId,
                          @"token":[FrankTools getUserToken],
                          @"device_id":[FrankTools getDeviceUUID]};
    [MainRequest RequestHTTPData:PATH(@"api/cash/unlockCard") parameters:dic success:^(id responseData) {
        [weakSelf showHUDWithResult:YES message:@"解除绑定成功" completion:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
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
