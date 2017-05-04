//
//  VerifyBankCardViewController.m
//  LegendWorld
//
//  Created by Frank on 2016/10/31.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "VerifyBankCardViewController.h"
#import "VerifyPhoneNumberController.h"
#import "UserDelegateViewController.h"

@interface VerifyBankCardViewController ()<UITextFieldDelegate>

@property (nonatomic, weak)UIImageView *logoIm;
@property (nonatomic, weak)UILabel *bankName;
@property (nonatomic, weak)UILabel *cardNumber;
@property (nonatomic, weak)UITextField *nameTx;
@property (nonatomic, weak)UITextField *idcardTx;
@property (nonatomic, weak)UITextField *phoneTx;
@property (nonatomic, weak)UILabel *tipLab;
@property (nonatomic, weak)UIButton *nextBtn;

@end

@implementation VerifyBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"验证银行卡信息";
    [self initFrameView];
}

-(void)initFrameView{
    self.view.backgroundColor = viewColor;
    UIView *bankView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, DeviceMaxWidth, 70*widthRate)];
    bankView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bankView];
    
    UIImageView *logoImage = [UIImageView new];
    [FrankTools setImgWithImgView:logoImage withImageUrl:[_bankDic objectForKey:@"bank_logo"] withPlaceHolderImage:imageWithName(@"creditCardNormalBank")];
    self.logoIm = logoImage;
    [bankView addSubview:logoImage];
    
    _logoIm.sd_layout
    .leftSpaceToView(bankView,15)
    .centerYEqualToView(bankView)
    .widthIs(40*widthRate)
    .heightEqualToWidth();
    
    UILabel *nameLab = [UILabel new];
    nameLab.text = [NSString stringWithFormat:@"%@",[_bankDic objectForKey:@"bank_info"]];
    nameLab.textColor = contentTitleColorStr1;
    nameLab.font = [UIFont systemFontOfSize:16];
    self.bankName = nameLab;
    [bankView addSubview:nameLab];
    
    nameLab.sd_layout
    .leftSpaceToView(logoImage,15)
    .topSpaceToView(bankView,15)
    .rightSpaceToView(bankView,15)
    .heightIs(20*widthRate);
    
    UILabel *bankNum = [UILabel new];
    bankNum.text = [NSString stringWithFormat:@"%@",[_bankDic objectForKey:@"bank_no"]];
    bankNum.textColor = contentTitleColorStr1;
    bankNum.font = [UIFont systemFontOfSize:14];
    self.cardNumber = bankNum;
    [bankView addSubview:bankNum];
    
    bankNum.sd_layout
    .leftEqualToView(_bankName)
    .rightEqualToView(_bankName)
    .bottomSpaceToView(bankView,10*widthRate)
    .heightIs(20*widthRate);
    
    UIView *inforView = [UIView new];
    inforView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:inforView];
    
    inforView.sd_layout
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(bankView,20)
    .heightIs(120);
    
    NSArray *nameArray = @[@"姓  名",@"身份证",@"手机号"];
    NSArray *placeArray = @[@"持卡人姓名",@"持卡人身份证号",@"银行预留手机号"];
    
    for (int i=0; i<nameArray.count; i++) {
        UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(15, i*40, 60, 40)];
        nameL.text = nameArray[i];
        nameL.textColor = contentTitleColorStr1;
        nameL.font = [UIFont systemFontOfSize:16];
        [inforView addSubview:nameL];
        
        UITextField *detailT = [[UITextField alloc] initWithFrame:CGRectMake(120, i*40, DeviceMaxWidth-130, 40)];
        detailT.delegate = self;
        detailT.placeholder = placeArray[i];
        detailT.textColor = contentTitleColorStr1;
        detailT.font = [UIFont systemFontOfSize:14];
        detailT.clearButtonMode = UITextFieldViewModeWhileEditing;
        [detailT addTarget:self action:@selector(textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
        [inforView addSubview:detailT];
        
        if (i != nameArray.count-1) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 40+i*40, DeviceMaxWidth-30, 0.5)];
            line.backgroundColor = tableDefSepLineColor;
            [inforView addSubview:line];
        }
        
        if (i == 0) {
            self.nameTx = detailT;
            self.nameTx.keyboardType = UIKeyboardTypeDefault;
        }else if (i == 1) {
            self.idcardTx = detailT;
            self.idcardTx.keyboardType = UIKeyboardTypeNamePhonePad;
        }else{
            self.phoneTx = detailT;
            self.phoneTx.keyboardType = UIKeyboardTypeDecimalPad;
            self.phoneTx.frame = CGRectMake(120, i*40, DeviceMaxWidth-180, 40);
            UIButton *tipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [tipBtn setImage:imageWithName(@"mine_wenhao") forState:UIControlStateNormal];
            [tipBtn addTarget:self action:@selector(clickTipButtonEvent) forControlEvents:UIControlEventTouchUpInside];
            [inforView addSubview:tipBtn];
            
            tipBtn.sd_layout
            .leftSpaceToView(self.phoneTx,10)
            .widthIs(20)
            .centerYEqualToView(self.phoneTx)
            .heightIs(20);
        }
    }
    
    UILabel *tipL = [UILabel new];
    tipL.textColor = mainColor;
//    tipL.text = @"您输入的手机号无效，请重新输入";
    tipL.font = [UIFont systemFontOfSize:15];
    tipL.textAlignment = NSTextAlignmentCenter;
    self.tipLab = tipL;
    [self.view addSubview:tipL];
    
    tipL.sd_layout
    .leftSpaceToView(self.view,15)
    .rightSpaceToView(self.view,15)
    .heightIs(20)
    .topSpaceToView(inforView,15);
    
    UIButton *agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [agreeBtn setTitle:@"同意《银联用户服务协议》" forState:UIControlStateNormal];
    agreeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [agreeBtn setTitleColor:contentTitleColorStr2 forState:UIControlStateNormal];
    [agreeBtn setImage:imageWithName(@"home_select_no") forState:UIControlStateNormal];
    [agreeBtn setImage:imageWithName(@"selected") forState:UIControlStateSelected];
    agreeBtn.selected = YES;
    agreeBtn.imageEdgeInsets = UIEdgeInsetsMake(0,0,0,agreeBtn.titleLabel.bounds.size.width+15);
    [agreeBtn addTarget:self action:@selector(clickAgreeEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:agreeBtn];
    
    agreeBtn.sd_layout
    .leftSpaceToView(self.view,15)
    .rightSpaceToView(self.view,15)
    .topSpaceToView(tipL,30)
    .heightIs(20*widthRate);
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:15];
    nextButton.backgroundColor = buttonGrayColor;
    nextButton.enabled = NO;
    nextButton.layer.cornerRadius = 5;
    nextButton.layer.masksToBounds = YES;
    [nextButton addTarget:self action:@selector(clickNextButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    self.nextBtn = nextButton;
    [self.view addSubview:nextButton];
    
    nextButton.sd_layout
    .leftSpaceToView(self.view,40)
    .rightSpaceToView(self.view,40)
    .topSpaceToView(agreeBtn,20)
    .heightIs(40);
}

- (void)clickAgreeEvent{
    UserDelegateViewController *userVc = [UserDelegateViewController new];
    userVc.sourceType = 1;
    [self.navigationController pushViewController:userVc animated:YES];
}

- (void)clickTipButtonEvent{
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"手机号" message:@"银行预留手机号是办理该银行卡时所填写的手机号。若没有预留，忘记或已停用，请联系银行客服更新处理" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alterView show];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

- (void)textFieldValueChange:(UITextField *)textField_{
    if (self.nameTx.text.length>0 && (self.idcardTx.text.length==15 || self.idcardTx.text.length==18) && self.phoneTx.text.length==11) {
        self.nextBtn.enabled = YES;
        self.nextBtn.backgroundColor = mainColor;
    }else{
        self.nextBtn.enabled = NO;
        self.nextBtn.backgroundColor = buttonGrayColor;
    }
}

- (void)clickNextButtonEvent{
    if (self.nameTx.text.length == 0) {
        self.tipLab.text = @"请输入持卡人姓名";
        return;
    }
    if (![FrankTools isValidateIDNum:self.idcardTx.text]) {
        self.tipLab.text = @"您输入的身份证号码有误";
        return;
    }
    if (![FrankTools isValidateMobile:self.phoneTx.text]) {
        self.tipLab.text = @"您输入的手机号码有误";
        return;
    }
    NSDictionary *dic = @{@"token":[FrankTools getUserToken],
                          @"device_id":[FrankTools getDeviceUUID],
                          @"real_name":[NSString stringWithFormat:@"%@",self.nameTx.text],
                          @"ID_card":[NSString stringWithFormat:@"%@",self.idcardTx.text],
                          @"mobile":[NSString stringWithFormat:@"%@",self.phoneTx.text]};
    [self showHUD];
    [MainRequest RequestHTTPData:PATH(@"Api/Cash/checkBankCardInfo") parameters:dic success:^(id responseData) {
        [self hideHUD];
        NSMutableDictionary *mDic = [[NSMutableDictionary alloc] initWithDictionary:_bankDic];
        [mDic setObject:self.nameTx.text forKey:@"real_name"];
        [mDic setObject:self.idcardTx.text forKey:@"ID_card"];
        [mDic setObject:self.phoneTx.text forKey:@"mobile"];
        VerifyPhoneNumberController *phoneNum = [VerifyPhoneNumberController new];
        phoneNum.addBankDic = [[NSMutableDictionary alloc] initWithDictionary:mDic];
        [self.navigationController pushViewController:phoneNum animated:YES];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        self.tipLab.text = [NSString stringWithFormat:@"%@",[errorDic objectForKey:@"error_msg"]];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
