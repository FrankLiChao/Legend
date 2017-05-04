//
//  WeChatWithdrawViewController.m
//  LegendWorld
//
//  Created by Frank on 2016/12/15.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "WeChatWithdrawViewController.h"
#import "WxWithdrawMoneyTableViewCell.h"
#import "WxAccountTableViewCell.h"
#import "WxMoneyTableViewCell.h"
#import "WXApi.h"
#import <ShareSDK/ShareSDK.h>
#import "WxAccountModel.h"
#import "MJExtension.h"
#import "EnterPasswordView.h"
#import "SetPayKeyViewController.h"
#import "WithdrawResultViewController.h"
#import "AddWxTableViewCell.h"
#import "VerificationForPayKeyViewController.h"

@interface WeChatWithdrawViewController ()<UITableViewDelegate,UITableViewDataSource,RefreshingViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property(nonatomic)BOOL isFirstEnter;
@property(nonatomic)NSInteger selectTag;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSString *increment;
@property(nonatomic)NSString *withdrawMoney;

@end

@implementation WeChatWithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"微信提现";
    self.isFirstEnter = YES;
    self.dataArray = [NSMutableArray new];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addWechatAccout)];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.backgroundColor = viewColor;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.rowHeight = UITableViewAutomaticDimension;
    self.myTableView.estimatedRowHeight = 200;
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"WxWithdrawMoneyTableViewCell" bundle:nil] forCellReuseIdentifier:@"WxWithdrawMoneyTableViewCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"WxAccountTableViewCell" bundle:nil] forCellReuseIdentifier:@"WxAccountTableViewCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"WxMoneyTableViewCell" bundle:nil] forCellReuseIdentifier:@"WxMoneyTableViewCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"AddWxTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddWxTableViewCell"];
    [self getUserdata]; //获取提现金额
}

-(void)getUserdata{
    NSDictionary *dic = @{@"device_id":[FrankTools getDeviceUUID],
                          @"token":[FrankTools getUserToken]};
    
    [MainRequest RequestHTTPData:PATH(@"api/user/getUserPage") parameters:dic success:^(id responseData) {
        if (responseData) {
            FLLog(@"%@",responseData);
            self.increment = [[responseData objectForKey:@"page_info"] objectForKey:@"increment"];
            [self initDataSource];
        }
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[NSString stringWithFormat:@"%@",[errorDic objectForKey:@"error_msg"]]];
    }];
}

-(void)initDataSource
{
    [self.dataArray removeAllObjects];
    [self getWechatAccout];
}

- (void)refreshingUI{
    [self initDataSource];
}

-(void)addWechatAccout{
    if ([WXApi isWXAppInstalled]){
        [ShareSDK cancelAuthorize:SSDKPlatformSubTypeWechatSession];
        [self sendAuthRequest];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"没有安装微信" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)getWechatAccout{
    NSDictionary *dic = @{@"device_id":[FrankTools getDeviceUUID],
                          @"token":[FrankTools getUserToken]};
    [self showHUDWithMessage:nil];
    [MainRequest RequestHTTPData:PATH(@"api/cash/getWxAccount") parameters:dic success:^(id responseData) {
        [self hideHUD];
        FLLog(@"%@",responseData);
        if(self.isFirstEnter) {
            NSArray *arr = [responseData objectForKey:@"account_list"];
            [self.dataArray  addObjectsFromArray:arr];
            [self.myTableView reloadData];
            //自动跳转到提现
            if (self.dataArray.count == 0) {
                [self sendAuthRequest];
            }else {
                [self.myTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
            self.isFirstEnter = NO;
        }else
        {
            NSArray *arr = [responseData objectForKey:@"account_list"];
            if (arr.count == 0) {
                [self sendAuthRequest];
            }else {
                [self.dataArray  addObjectsFromArray:arr];
                [self.myTableView reloadData];
                [self.myTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
        }
    } failed:^(NSDictionary *errorDic) {
        [self hideHUD];
        [self.dataArray removeAllObjects];
        [self.myTableView reloadData];
        if ([self isReLogin:errorDic]) {
            [self popLoginView:self];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"获取失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

-(void)sendAuthRequest
{
    [self showHUDWithMessage:nil];
    [ShareSDK getUserInfo:SSDKPlatformSubTypeWechatSession onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        if (state == SSDKResponseStateSuccess) {
            FLLog(@"%@",user.rawData);
            NSDictionary *dic = @{
                                  @"device_id":[FrankTools getDeviceUUID],
                                  @"token":[FrankTools getUserToken],
                                  @"openid":[NSString stringWithFormat:@"%@",[user.rawData objectForKey:@"openid"]],
                                  @"unionid":[NSString stringWithFormat:@"%@",[user.rawData objectForKey:@"unionid"]],
                                  @"nick_name":user.nickname,
                                  @"head_img":user.icon,
                                  @"sex":[NSString stringWithFormat:@"%@",[user.rawData objectForKey:@"sex"]],
                                  @"province":[NSString stringWithFormat:@"%@",[user.rawData objectForKey:@"province"]],
                                  @"city":[NSString stringWithFormat:@"%@",[user.rawData objectForKey:@"city"]],
                                  @"country":[NSString stringWithFormat:@"%@",[user.rawData objectForKey:@"country"]]
                                  };
            [MainRequest RequestHTTPData:PATH(@"api/cash/addWxAccount") parameters:dic success:^(id responseData) {
                [self hideHUD];
                if (responseData) {
                    [self initDataSource];
                }
            } failed:^(NSDictionary *errorDic) {
                [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
            }];
        }else {
            [self hideHUD];
        }
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1) {
//        return self.dataArray.count;
        return self.dataArray.count>0?self.dataArray.count:1;
    }else{
        return 1;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && self.dataArray.count != 0) {
        return YES;
    }
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete  && self.dataArray.count != 0) {
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:nil message:@"确定删除" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = indexPath.row;
        [alert show];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 15.0/2;
    }
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 15)];
    bgView.backgroundColor = [UIColor clearColor];
    return bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 0.01)];
    bgView.backgroundColor = [UIColor clearColor];
    return bgView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        WxWithdrawMoneyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WxWithdrawMoneyTableViewCell"];
        cell.moneyLab.text = [NSString stringWithFormat:@"%.2f元",[self.increment floatValue]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section == 2) {
        WxMoneyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WxMoneyTableViewCell"];
        [cell.sureBtn addTarget:self action:@selector(clickSureButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (self.dataArray.count == 0) {//AddWxTableViewCell
        AddWxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddWxTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    NSDictionary *dic = self.dataArray[indexPath.row];
    WxAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WxAccountTableViewCell"];
    cell.acountLab.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"nick_name"]];
    [FrankTools setImgWithImgView:cell.headIm withImageUrl:[dic objectForKey:@"head_img"] withPlaceHolderImage:defaultUserHead];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count == 0 && indexPath.section == 1) {
        [self initDataSource];
        return;
    }
    if (indexPath.section == 1) {
        self.selectTag = indexPath.row;
    }
}

-(void)clickSureButtonEvent:(UIButton *)button_{
    WxMoneyTableViewCell *cell = (WxMoneyTableViewCell *)button_.superview.superview;
    if ([self.increment floatValue] == 0) {
        [self showHUDWithResult:NO message:@"您的账户还没有可提现金额"];
        return;
    }
    if (self.dataArray.count == 0) {
        [self showHUDWithResult:NO message:@"请添加微信账户"];
        return;
    }
    if (cell.moneyLab.text.length == 0) {
        [self showHUDWithResult:NO message:@"请输入提现金额"];
        return;
    }
    if ([cell.moneyLab.text floatValue] > [self.increment floatValue]) {
        [self showHUDWithResult:NO message:@"提现金额不能大于提现余额"];
        return;
    }
    [self enterMyPayPassword:cell.moneyLab.text];
}

-(void)enterMyPayPassword:(NSString *)moneyStr{
    if ([FrankTools isPayPassword]) {
        [EnterPasswordView showWithContent:moneyStr comple:^(NSString *password) {
            NSString *passwordKey = [NSString stringWithFormat:@"%@%@",password,DES_KEY];
            NSString *md5Password = [[FrankTools sharedInstance] getMd5_32Bit_String:passwordKey];
            NSDictionary *dic = @{@"device_id":[FrankTools getDeviceUUID],
                                  @"token":[FrankTools getUserToken],
                                  @"payment_pwd":md5Password?md5Password:@""};
            
            [MainRequest RequestHTTPData:PATH(@"api/user/checkPaymentPassword") parameters:dic success:^(id responseData) {
                [self takeCashRequestBankId:password :moneyStr];
            } failed:^(NSDictionary *errorDic) {
                if ([[errorDic objectForKey:@"error_code"] integerValue] == 2042101) {
                    self.withdrawMoney = moneyStr;
                    [self showPasswordErrorAlter];
                }else{
                    [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
                }
            }];
            
        }];
    }else{
        [self showSetPasswordVC];
    }
}

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
    alter.tag = 99;
    [alter show];
}

-(void)takeCashRequestBankId:(NSString *)password :(NSString *)moneyStr
{
    [self showHUDWithMessage:nil];
    NSString *passwordKey = [NSString stringWithFormat:@"%@%@",password,DES_KEY];
    NSString *md5Password = [[FrankTools sharedInstance] getMd5_32Bit_String:passwordKey];
    NSString *WxId = [self.dataArray[self.selectTag] objectForKey:@"id"];
    NSDictionary *dic = @{@"device_id":[FrankTools getDeviceUUID],
                          @"token":[FrankTools getUserToken],
                          @"bank_id":WxId?WxId:@"",
                          @"money":moneyStr,
                          @"payment_pwd":md5Password?md5Password:@"",
                          @"type":@"3"};
    [MainRequest RequestHTTPData:PATH(@"api/cash/takeCash") parameters:dic success:^(id responseData) {
        [self showHUDWithResult:YES message:@"提现成功" completion:^{
            [self toBankResultViewController:moneyStr];
        }];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

-(void)toBankResultViewController:(NSString *)moneyStr{//微信提现
    //    FLLog(@"%@",_dataDic);
    NSDictionary *dic = self.dataArray[self.selectTag];
    WithdrawResultViewController *resultVc = [WithdrawResultViewController new];
    resultVc.moneyStr = moneyStr;
    resultVc.bankDetail = [NSString stringWithFormat:@"%@",[dic objectForKey:@"nick_name"]];
    resultVc.isWx = YES;
    [self.navigationController pushViewController:resultVc animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 99)
    {
        //-- 密码错误Alert
        if (buttonIndex == 0)
        {
            //-- 重试
            [self enterMyPayPassword:self.withdrawMoney];
        }
        else if (buttonIndex == 1)
        {
            //-- 忘记密码
            VerificationForPayKeyViewController *verifiVc = [VerificationForPayKeyViewController new];
            [self.navigationController pushViewController:verifiVc animated:YES];
        }
        return;
    }else if (buttonIndex == 1) {
        NSDictionary *dic = [self.dataArray objectAtIndex:alertView.tag];
        NSString *wx_id = [dic objectForKey:@"id"];
        [self deleteWechatAccountWithId:wx_id :alertView.tag];
    }
}

-(void)deleteWechatAccountWithId:(NSString *)wx_id :(NSInteger)index
{
    NSDictionary *dic = @{@"device_id":[FrankTools getDeviceUUID],
                          @"token":[FrankTools getUserToken],
                          @"wx_id":wx_id?wx_id:@""};
    [self showHUDWithMessage:nil];
    [MainRequest RequestHTTPData:PATH(@"api/cash/deleteWxAccount") parameters:dic success:^(id responseData) {
        [self showHUDWithResult:YES message:@"删除成功"];
        [ShareSDK cancelAuthorize:SSDKPlatformSubTypeWechatSession];
        [self.dataArray removeObjectAtIndex:index];
        [self.myTableView reloadData];
        if (self.dataArray.count != 0) {
            [self.myTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:@"删除失败"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
