//
//  PayMethodViewController.m
//  LegendWorld
//
//  Created by 文荣 on 16/9/14.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "PayMethodViewController.h"
#import "OrderPaySuccessViewController.h"
#import "OrderDetailViewController.h"
#import "MyOrderViewController.h"
#import "AgentSuccessController.h"
#import "TOCardGuideViewController.h"
#import "UserDelegateViewController.h"
#import "PaySelectTableViewCell.h"

#import "Order.h"
#import "DealdetailsViewController.h"
#import "EnterPasswordView.h"
#import "AgentSuccessController.h"
#import "ListOrderModel.h"
#import "VerificationForPayKeyViewController.h"
#import "SetPayKeyViewController.h"

#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

@interface PayMethodViewController ()<UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, weak) UIButton *agreeBtn;
@property (nonatomic, weak) UIButton *payBtn;


@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *subTitleArray;
@property (nonatomic, strong) NSArray *images;

@property (nonatomic, strong) Order *currentOrder;

@end

@implementation PayMethodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"支付方式";
    
    __weak typeof (self) weakSelf = self;
    self.backBarBtnEvent = ^{
        [weakSelf inform];
    };
    
    BOOL isBalanceEnough = [[self getUserData].money doubleValue] >= [self.orderMoney doubleValue];
    
    self.titleArray = @[@"微信支付",@"支付宝支付",@"钱包支付"];
    self.subTitleArray = @[@"推荐有微信账号用户",@"推荐有支付宝账号用户", isBalanceEnough ? @"推荐使用" : @"账户余额不足"];
    self.images = @[@"icon_wechat_pay", @"icon_zhifubao_pay", @"balance_pay"];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    
    UIButton *agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.agreeBtn = agreeBtn;
    self.agreeBtn.selected = YES;
    [self.agreeBtn setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
    [self.agreeBtn setImage:[UIImage imageNamed:@"check"] forState:UIControlStateSelected];
    [self.agreeBtn addTarget:self action:@selector(agreebuttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *protocolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    protocolBtn.titleLabel.font = [UIFont noteTextFont];
    [protocolBtn setTitle:@"同意《传说服务平台协议》" forState:UIControlStateNormal];
    [protocolBtn setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    [protocolBtn addTarget:self action:@selector(clickProtocolEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.payBtn = payBtn;
    self.payBtn.frame = CGRectMake(30, 60, DeviceMaxWidth - 60, 40);
    [self.payBtn setBackgroundImage:[UIImage backgroundImageWithColor:[UIColor themeColor] cornerRadius:6] forState:UIControlStateNormal];
    [self.payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    [self.payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.payBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.isFromOneYuanDelegate) {
        [self.payBtn setTitle:@"支付¥1元" forState:UIControlStateNormal];
    }
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 120)];
    footer.backgroundColor = [UIColor clearColor];
    [footer addSubview:self.agreeBtn];
    [footer addSubview:self.payBtn];
    [footer addSubview:protocolBtn];
    
    protocolBtn.sd_layout
    .centerXEqualToView(footer)
    .widthIs(170)
    .heightIs(20)
    .topSpaceToView(footer, 20);
    
    self.agreeBtn.sd_layout
    .rightSpaceToView(protocolBtn, 3)
    .widthIs(20)
    .heightIs(20)
    .topEqualToView(protocolBtn);
    
    self.tableView.tableFooterView = footer;
    self.tableView.rowHeight = 60;
    self.tableView.sectionHeaderHeight = 35;
    self.tableView.separatorColor = [UIColor seperateColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"PaySelectTableViewCell" bundle:nil] forCellReuseIdentifier:@"PaySelectTableViewCell"];
    
    if (isBalanceEnough) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    } else {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAlipayResultCallBack:) name:NOTIFICATION_ALIPAY_RESULT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWechatPayResultCallBack:) name:NOTIFICATION_WECHATPAY_RESULT object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_ALIPAY_RESULT object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_WECHATPAY_RESULT object:nil];
}

- (void)clickProtocolEvent:(UIButton *)button {
    UserDelegateViewController *vc = [UserDelegateViewController new];
    vc.sourceType = 0;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Event
- (void)inform {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您确定要放弃付款？"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    alert.tag = 2;
    [alert show];
}


- (NSInteger)getPayTypeBySelectIndex:(NSInteger)index {
    NSInteger payType = 0;
    switch (index) {
        case 0:
            payType = 3;
            break;
        case 1:
            payType = 2;
            break;
        case 2:
            payType = 1;
            break;
        default:
            break;
    }
    return payType;
}

- (void)agreebuttonPressed:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    self.payBtn.enabled = sender.isSelected;
}

- (void)buttonPressed:(id)sender {
    NSInteger payType = [self getPayTypeBySelectIndex:[self.tableView indexPathForSelectedRow].row];
    if (payType == 1) {
        //余额支付
        [self enterMyPayPassword];
    } else {
        [self showHUDWithMessage:nil];
        NSDictionary *param = @{@"device_id": [FrankTools getDeviceUUID], @"token": [FrankTools getUserToken],@"pay_type":@(payType),@"trade_no":self.orderNum,@"flag":@(self.orderPayType)};
        __weak typeof (self) weakSelf = self;
        [MainRequest RequestHTTPData:PATHShop(@"api/ShoppingCart/orderPay") parameters:param success:^(id response) {
            Order *order = [[Order alloc] init];
            order.signature_data = [response objectForKey:@"signature_data"];
            order.sigatureData = [SignaturedataModel mj_objectWithKeyValues:[response objectForKey:@"signature_data"]];
            order.trade_no = [response objectForKey:@"trade_no"];
            weakSelf.currentOrder = order;
            if (payType == 2) {
                [weakSelf alipayOrder:order wapComplete:^(BOOL bsuccess, NSString *message) {
                    [weakSelf showHUDWithResult:bsuccess message:message completion:^{
                        if (bsuccess) {
                            [weakSelf paySuccess];
                        }
                    }];
                }];
            } else if (payType == 3) {
                NSString *appid = [[response objectForKey:@"signature_data"] objectForKey:@"appid"];
                NSString *partnerid = [[response objectForKey:@"signature_data"] objectForKey:@"partnerid"];
                [weakSelf wechatPayOrder:order appId:appid partnerId:partnerid];
            }
        } failed:^(NSDictionary *errorDic) {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }];
    }
}

- (void)enterMyPayPassword {
    if ([FrankTools isPayPassword]) {//密码验证
        __weak typeof(self) weakSelf = self;
        [EnterPasswordView showWithContent:[NSString stringWithFormat:@"%@",self.orderMoney] comple:^(NSString *password) {
            NSDictionary *dic = @{@"device_id":[FrankTools getDeviceUUID],
                                  @"token":[FrankTools getUserToken],
                                  @"payment_pwd":password};
            NSMutableDictionary *muDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
            NSString *passwordKey = [NSString stringWithFormat:@"%@%@",password,DES_KEY];
            NSString *md5Password = [[FrankTools sharedInstance] getMd5_32Bit_String:passwordKey];
            [muDic setObject:md5Password?md5Password:@"" forKey:@"payment_pwd"];
            [MainRequest RequestHTTPData:PATH(@"api/user/checkPaymentPassword") parameters:muDic success:^(id responseData) {
                if (weakSelf.orderNum){
                    [weakSelf dealPay];
                }
            } failed:^(NSDictionary *errorDic) {
                //显示找回密码
                if ([[errorDic objectForKey:@"error_code"] integerValue] == 2042101) {
                    [weakSelf showPasswordErrorAlter];
                } else {
                    [weakSelf showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
                }
            }];
        }];
    } else {
        SetPayKeyViewController *setVc = [SetPayKeyViewController new];
        setVc.payMethodVC = self;
        [self.navigationController pushViewController:setVc animated:YES];
    }
}

- (void)dealPay {
    [self showHUDWithMessage:nil];
    NSInteger payType = [self getPayTypeBySelectIndex:[self.tableView indexPathForSelectedRow].row];
    NSDictionary *dic = @{@"device_id":[FrankTools getDeviceUUID],
                          @"token":[FrankTools getUserToken],
                          @"trade_no":self.orderNum,
                          @"pay_type":@(payType),
                          @"flag":@(self.orderPayType)};
    NSMutableDictionary *muDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    [MainRequest RequestHTTPData:PATHShop(@"api/ShoppingCart/orderPay") parameters:muDic success:^(id responseData) {
        self.currentOrder = [Order mj_objectWithKeyValues:responseData];
        self.currentOrder.sigatureData = [SignaturedataModel mj_objectWithKeyValues:[responseData objectForKey:@"signature_data"]];
        [self showHUDWithResult:YES message:@"余额支付成功" completion:^{
            [self paySuccess];
        }];
        [self updateUserData];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

- (void)paySuccess {
    if (self.isFromOneYuanDelegate) {
        AgentSuccessController *agentSuccess = [[AgentSuccessController alloc] init];
        [self.navigationController pushViewController:agentSuccess animated:YES];
        return;
    }
    OrderPaySuccessViewController *paySuccess = [[OrderPaySuccessViewController alloc] init];
    paySuccess.order_id = self.order_id?self.order_id:@"";
    [self.navigationController pushViewController:paySuccess animated:YES];
}

- (void)showPasswordErrorAlter {
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"密码错误"
                                                   delegate:self
                                          cancelButtonTitle:@"重试"
                                          otherButtonTitles:@"忘记密码", nil];
    alter.tag = 1;
    [alter show];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"请选择支付方式";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PaySelectTableViewCell *cell = (PaySelectTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"PaySelectTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.title.text = self.titleArray[indexPath.row];
    cell.selectedBtn.tag = indexPath.row;
    cell.iconImahe.image = [UIImage imageNamed:_images[indexPath.row]];
    cell.subTitle.text = self.subTitleArray[indexPath.row];
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        BOOL isBalanceEnough = [[self getUserData].money doubleValue] >= [self.orderMoney doubleValue];
        if (!isBalanceEnough) {
            return tableView.indexPathForSelectedRow;
        }
    }
    return indexPath;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        //-- 密码错误Alert
        if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"重试"]) {
            [self enterMyPayPassword];
        } else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"忘记密码"]) {
            VerificationForPayKeyViewController *verifiVc = [VerificationForPayKeyViewController new];
            verifiVc.payMethodVC = self;
            [self.navigationController pushViewController:verifiVc animated:YES];
        }
    } else if (alertView.tag == 2) {
        if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"确定"]) {
            AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            UITabBarController *root = (UITabBarController *)app.window.rootViewController;
            if ([root.viewControllers containsObject:self.navigationController]) {
                NSInteger numberOfVC = self.navigationController.viewControllers.count;
                for (NSInteger i = numberOfVC - 2; i >= 0; i--) {
                    UIViewController *vc = [self.navigationController.viewControllers objectAtIndex:i];
                    if ([vc isKindOfClass:[OrderDetailViewController class]] || [vc isKindOfClass:[MyOrderViewController class]]) {
                        [self.navigationController popToViewController:vc animated:YES];
                        return;
                    }
                }
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else {
                UserModel *user = [self getUserData];
                if ([user.tocard_grade integerValue] <= 0) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                } else {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }
        }
    }
}

#pragma mark - 支付宝支付
- (void)alipayOrder:(Order *)order wapComplete:(void(^)(BOOL bsuccess, NSString *message))complete{
    [[AlipaySDK defaultService] payOrder:order.signature_data fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSInteger code = [[resultDic objectForKey:@"resultStatus"] integerValue];
        switch (code) {//用户中途取消
            case 9000:
                complete(YES,@"支付成功");
                break;
            case 6001:
                complete(NO,@"支付取消");
                break;
            default:
                complete(NO,@"支付失败");
                break;
        }
    }];
}

- (void)handleAlipayResultCallBack:(NSNotification *)noti {
    NSDictionary *resultDic = [noti object];
    NSInteger code = [[resultDic objectForKey:@"resultStatus"] integerValue];
    switch (code) {//用户中途取消
        case 9000: {
            __weak typeof (self) weakSelf = self;
            [self showHUDWithResult:YES message:@"支付成功" completion:^{
                [weakSelf paySuccess];
            }];
            break;
        }
        case 6001:
            [self showHUDWithResult:NO message:@"支付取消"];
            break;
        default:
            [self showHUDWithResult:NO message:@"支付失败"];
            break;
    }
}

#pragma mark - 微信支付
- (void)wechatPayOrder:(Order *)order appId:(NSString *)appId partnerId:(NSString *)partnerId {
    PayReq *wxreq             = [[PayReq alloc] init];
    wxreq.openID              = appId ? appId : @"";
    wxreq.partnerId           = partnerId ? partnerId : @"";
    wxreq.prepayId            = [NSString stringWithFormat:@"%@",order.sigatureData.prepayid];
    wxreq.nonceStr            = [NSString stringWithFormat:@"%@",order.sigatureData.noncestr];
    wxreq.timeStamp           = [order.sigatureData.timestamp intValue];
    wxreq.package             = [NSString stringWithFormat:@"%@",order.sigatureData.weixin_package];
    wxreq.sign                = [NSString stringWithFormat:@"%@",order.sigatureData.sign];;
    [WXApi sendReq:wxreq];
}

- (void)handleWechatPayResultCallBack:(NSNotification *)noti {
    PayResp *response = [noti object];
    if (response.errCode == 0) {
        __weak typeof (self) weakSelf = self;
        [self showHUDWithResult:YES message:@"支付成功" completion:^{
             [weakSelf paySuccess];
        }];
    } else if (response.errCode == -2) {
        [self showHUDWithResult:NO message:@"支付取消"];
    } else {
        [self showHUDWithResult:NO message:@"支付失败"];
    }
}

@end
