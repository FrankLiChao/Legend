//
//  AgreementViewController.m
//  LegendWorld
//
//  Created by 文荣 on 16/9/14.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "AgreementViewController.h"
#import "FrankTools.h"
#import "MainRequest.h"
#import "OneYuanDelegateModel.h"
#import "ProductModel.h"
#import "SBJsonWriter.h"
#import "PayMethodViewController.h"
#import "CertificationUploadViewController.h"
#import "AgentSuccessController.h"
#import "VerificationStateViewController.h"

@interface AgreementViewController ()<RefreshingViewDelegate>

//UI Controls
@property (weak, nonatomic) IBOutlet UIButton *joinBtn;
@property (weak, nonatomic) IBOutlet UITextView *agreeTV;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

//Models
@property (strong, nonatomic) NSDictionary *userData;
@property (strong, nonatomic) NSDictionary *returnData;
@property (strong, nonatomic) NSString *real_auth_status;
@property (strong, nonatomic) NSString *errorCode;

@end

@implementation AgreementViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"VIP申请";
    self.real_auth_status = @"4";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.joinBtn setBackgroundImage:[UIImage backgroundImageWithColor:[UIColor themeColor] cornerRadius:6] forState:UIControlStateNormal];
    [self.joinBtn setBackgroundImage:[UIImage backgroundImageWithColor:[UIColor noteTextColor] cornerRadius:6] forState:UIControlStateDisabled];
    
    self.checkBtn.selected = NO;
    self.joinBtn.enabled = NO;
    
    [self requestData];
}

#pragma mark - RefreshingViewDelegate
- (void)refreshingUI{
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.userData = [[NSUserDefaults standardUserDefaults] objectForKey:userLoginDataToLocal];
    if ([[self.userData objectForKey:@"real_auth_status"] integerValue] == 4) {
        [self.joinBtn setTitle:@"去认证" forState:UIControlStateNormal];
    } else {
        [self.joinBtn setTitle:@"即刻加入" forState:UIControlStateNormal];
    }
//    self.joinBtn.enabled = NO;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.agreeTV.contentOffset = CGPointZero;
}
- (void)dealloc{

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
// 同意阅读协议
- (IBAction)agreeBtnEvent:(id)sender {
    self.checkBtn.selected = !self.checkBtn.selected;
    self.joinBtn.enabled = self.checkBtn.isSelected;
}

/*
 * real_auth_status: 0表示待审核，1审核中，2已通过，3未通过，4未申请
 */
- (IBAction)joinEvent {
    if ([self.errorCode integerValue] == 5041004) {
        [self showHUDWithResult:NO message:@"实名认证资料已提交，等待审核"];
    } else if ([self.errorCode integerValue] == 5041005) {
        [self showHUDWithResult:NO message:@"实名认证审核中，请耐心等待"];
    } else if ([self.errorCode integerValue] == 5041002) {
        [self showHUDWithResult:NO message:@"商户未设置一元成代理商品，请联系代理商"];
    } else if ([self.errorCode integerValue] == 5041006) {
        VerificationStateViewController *loanView = [VerificationStateViewController new];
        [self.navigationController pushViewController:loanView animated:YES];
    } else if ([self.errorCode integerValue] == 5041001) {
        CertificationUploadViewController *certiView = [CertificationUploadViewController new];
        [self.navigationController pushViewController:certiView animated:YES];
    } else if ([self.errorCode integerValue] == 5041003) {
        AgentSuccessController *agentView = [AgentSuccessController new];
        [self.navigationController pushViewController:agentView animated:YES];
    } else {
        [self addOrder:self.returnData];
    }
}

#pragma mark - Custom Actions
- (void)requestData {
    if ([FrankTools loginIsOrNot:self]) {
        NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],
                                     @"token":[FrankTools getUserToken]};
        [self showHUD];
        [MainRequest RequestHTTPData:PATHShop(@"/api/Order/oneYuanAgent") parameters:parameters success:^(id response) {
            self.returnData = response;
            [self hideHUD];
        } failed:^(NSDictionary *errorDic) {
            [self hideHUD];
            self.errorCode = [NSString stringWithFormat:@"%@",[errorDic objectForKey:@"error_code"]];
            if ([self.errorCode integerValue] == 5041003) {
                AgentSuccessController *agentView = [AgentSuccessController new];
                [self.navigationController pushViewController:agentView animated:YES];
            }
        }];
    }
}

- (void)addOrder:(NSDictionary *)response {
    OneYuanDelegateModel *model = [OneYuanDelegateModel mj_objectWithKeyValues:response[@"one_yuan_agent_info"]];
    if (!model) {
        return ;
    }
    NSArray *goodsList = @[@{@"goods_id" : model.goods_id,
                             @"goods_number": @"1",
                             @"attr_id":@"0"
                             }];
    NSDictionary *dic = @{@"device_id":[FrankTools getDeviceUUID],
                          @"token":[FrankTools getUserToken],
                          @"realname":@"  ",
                          @"area_id":@"  ",
                          @"address":@"  ",
                          @"mobile":model.mobile,
                          @"goods_amount":model.goods_amount,
                          @"order_amount":model.order_amount,
                          @"is_endorse": model.is_endorse,
                          @"pay_type": @"1",
                          @"goods_list":[[SBJsonWriter new] stringWithObject:goodsList],
                          @"is_one_yuan_agent": model.is_one_yuan_agent,
                          };
    [MainRequest RequestHTTPData:PATHShop(@"/api/Order/addOrder") parameters:dic success:^(id response) {
        PayMethodViewController *controller = [[PayMethodViewController alloc] init];
        NSString *string = response[@"order_number"];
//        controller.jumpTag = 1;
        controller.isFromOneYuanDelegate = YES;
        controller.orderNum = string;
        controller.orderMoney = @"1";
        controller.orderPayType = OrderPayTypeNormal;
        [self.navigationController pushViewController:controller animated:YES];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

@end
