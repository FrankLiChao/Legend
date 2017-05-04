//
//  WithdrawViewController.m
//  LegendWorld
//
//  Created by ios-dev-01 on 16/9/19.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "WithdrawViewController.h"
#import "WithdrawTypeCell.h"
#import "CashListViewController.h"
#import "AddBankCardViewController.h"
#import "BankWithdrawViewController.h"
#import "MyBankCardViewController.h"
#import "MyCardTableViewCell.h"
#import "WeChatWithdrawViewController.h"

@interface WithdrawViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,weak)UITableView *myTableView;
@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,strong)NSDictionary  *bankDic;

@end

@implementation WithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现方式";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提现记录" style:UIBarButtonItemStylePlain target:self action:@selector(clickWithdrawRecordEvent)];
    
    self.dataArray = @[@[@"微信提现",@"银行卡提现",@"支付宝"],@[@"推荐使用",@"可以使用",@"暂未开通"],@[@"mine_weixin",@"mine_yinlian",@"mine_zhifubao"]];
    
    [self initFrameView];
    [self requestData];
}

- (void)requestData{
    NSDictionary *dic = @{@"device_id":[FrankTools getDeviceUUID],
                          @"token":[FrankTools getUserToken]};
    [self showHUD];
    [MainRequest RequestHTTPData:PATH(@"api/Cash/getLastTakeCashCard") parameters:dic success:^(id responseData) {
        self.bankDic = [responseData objectForKey:@"cards"];
        [self.myTableView reloadData];
        [self hideHUD];
    } failed:^(NSDictionary *errorDic) {
        if ([self isReLogin:errorDic]) {
            [self hideHUD];
            [self popLoginView:self];
        } else {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }
    }];
}

- (void)initFrameView
{
    UITableView *myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight-64) style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.backgroundColor = viewColor;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView = myTableView;
    [self.view addSubview:self.myTableView];
}

#pragma mark - UItabViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 40*widthRate;
    }else{
        return 0;
    }
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 40*widthRate)];
    bgView.backgroundColor = viewColor;
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(20*widthRate, 0, DeviceMaxWidth-40*widthRate, 40*widthRate)];
    lab.text = @"请选择提现方式";
    lab.textColor = contentTitleColorStr1;
    lab.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:lab];
    
    return bgView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.bankDic.count>0) {
            return 1;
        }
        return 0;
    }
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0) {
//        return 80;
//    }
    return 65*widthRate;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString * ftifier = @"FCell";
        WithdrawTypeCell * fcell = [tableView dequeueReusableCellWithIdentifier:ftifier];
        if (fcell == nil) {
            fcell = [[WithdrawTypeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ftifier];
        }
        fcell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.bankDic.count>0) {
            FLLog(@"%@",self.bankDic);
            [FrankTools setImgWithImgView:fcell.logoImage withImageUrl:[self.bankDic objectForKey:@"logo"] withPlaceHolderImage:placeHolderImg];
            NSString *bankNumStr = [NSString stringWithFormat:@"%@",[self.bankDic objectForKey:@"card_no"]];
            if (bankNumStr.length > 4) {
                bankNumStr = [bankNumStr substringFromIndex:bankNumStr.length-4];
            }
            fcell.name.text = [NSString stringWithFormat:@"%@  尾号%@",[self.bankDic objectForKey:@"bank_name"],bankNumStr];
            fcell.nameDescribe.text = @"已绑定银行卡";
        }
        return fcell;
    }
    static NSString * tifier = @"FrankCell";
    WithdrawTypeCell * cell = [tableView dequeueReusableCellWithIdentifier:tifier];
    if (cell == nil) {
        cell = [[WithdrawTypeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *nameArray = self.dataArray[0];
    NSArray *describeArray = self.dataArray[1];
    NSArray *imageArray = self.dataArray[2];
    cell.name.text = nameArray[indexPath.row];
    cell.nameDescribe.text = describeArray[indexPath.row];
    [cell.logoImage setImage:imageWithName(imageArray[indexPath.row])];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        BankWithdrawViewController *bankVc = [BankWithdrawViewController new];
        bankVc.dataDic = self.bankDic;
        [self.navigationController pushViewController:bankVc animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == 0) {
        FLLog(@"微信提现");
        WeChatWithdrawViewController *wcVc = [WeChatWithdrawViewController new];
        [self.navigationController pushViewController:wcVc animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 1) {
        FLLog(@"银行卡提现");
        if (self.bankDic.count > 0) { //用户添加了银行卡
            //选择银行卡
            MyBankCardViewController *myBankCard = [MyBankCardViewController new];
            [self.navigationController pushViewController:myBankCard animated:YES];
                                
        }else{ //未添加银行卡则去添加
            AddBankCardViewController *addBankView = [AddBankCardViewController new];
            [self.navigationController pushViewController:addBankView animated:YES];
        }
    }else if (indexPath.section == 1 && indexPath.row == 2){
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂未开通" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alterView show];
        FLLog(@"支付宝提现");
    }
}

#pragma mark - 提现记录
-(void)clickWithdrawRecordEvent
{
    FLLog(@"提现记录");
    CashListViewController *recordView = [CashListViewController new];
    [self.navigationController pushViewController:recordView animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
