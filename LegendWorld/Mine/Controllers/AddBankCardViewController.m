//
//  AddBankCardViewController.m
//  LegendWorld
//
//  Created by ios-dev-01 on 16/9/20.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "AddBankCardViewController.h"
#import "BankWithdrawViewController.h"
#import "MyBankCardViewController.h"
#import "VerifyBankCardViewController.h"

@interface AddBankCardViewController ()<RefreshingViewDelegate>

@property (nonatomic, weak) UIButton  *nextBtn;
@property (nonatomic, weak) UITextField *cardNumTx;

@end

@implementation AddBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加银行卡";
    [self initFrameView];
}

-(void)initFrameView
{
    self.view.backgroundColor = viewColor;
    UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, DeviceMaxWidth-30, 40)];
    tipLab.text = @"请绑定本人的银行卡";
    tipLab.font = [UIFont systemFontOfSize:14];
    tipLab.textColor = contentTitleColorStr2;
    [self.view addSubview:tipLab];
    
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    bgView.sd_layout
    .xIs(0)
    .topSpaceToView(tipLab,0)
    .widthIs(DeviceMaxWidth)
    .heightIs(40);
    
    UILabel *cardNum = [UILabel new];
    cardNum.text = @"卡号";
    cardNum.textColor = contentTitleColorStr1;
    cardNum.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:cardNum];
    
    cardNum.sd_layout
    .leftSpaceToView(bgView,15)
    .xIs(0)
    .widthIs(50)
    .heightIs(40);
    
    UITextField *cardNumTx = [UITextField new];
    cardNumTx.placeholder = @"请输入银行卡号";
    cardNumTx.textColor = contentTitleColorStr;
    cardNumTx.keyboardType = UIKeyboardTypeDecimalPad;
    cardNumTx.font = [UIFont systemFontOfSize:14];
    cardNumTx.clearButtonMode = UITextFieldViewModeWhileEditing;
    [cardNumTx addTarget:self action:@selector(textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
    [cardNumTx becomeFirstResponder];
    self.cardNumTx = cardNumTx;
    [bgView addSubview:self.cardNumTx];
    
    self.cardNumTx.sd_layout
    .leftSpaceToView(cardNum,40)
    .rightSpaceToView(bgView,15)
    .xIs(0)
    .heightIs(40);
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:15];
    nextButton.backgroundColor = buttonGrayColor;
    nextButton.layer.cornerRadius = 5;
    nextButton.layer.masksToBounds = YES;
    nextButton.enabled = NO;
    [nextButton addTarget:self action:@selector(clickNextButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    self.nextBtn = nextButton;
    [self.view addSubview:self.nextBtn];
    
    self.nextBtn.sd_layout
    .leftSpaceToView(self.view,40)
    .topSpaceToView(bgView,60)
    .rightSpaceToView(self.view, 40)
    .heightIs(40);
}

#pragma mark - 输入框事件
-(void)textFieldValueChange:(UITextField *)textField_
{
    if (self.cardNumTx.text.length >= 16 && self.cardNumTx.text.length <= 19) {
        self.nextBtn.backgroundColor = mainColor;
        self.nextBtn.enabled = YES;
    }else{
        self.nextBtn.backgroundColor = buttonGrayColor;
        self.nextBtn.enabled = NO;
    }
}

-(void)clickNextButtonEvent
{
    [self.cardNumTx resignFirstResponder];
    NSDictionary *dic = @{@"token":[FrankTools getUserToken],
                          @"device_id":[FrankTools getDeviceUUID],
                          @"bank_no":[NSString stringWithFormat:@"%@",self.cardNumTx.text]};
    [self showHUD];
    [MainRequest RequestHTTPData:PATH(@"Api/Cash/checkBankCardNo") parameters:dic success:^(id responseData) {
        [self hideHUD];
        VerifyBankCardViewController *verifyBankCard = [VerifyBankCardViewController new];
        verifyBankCard.bankDic = responseData;
        [self.navigationController pushViewController:verifyBankCard animated:YES];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

-(void)refreshingUI{
//    [self addCardNumberEvent];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.cardNumTx resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
