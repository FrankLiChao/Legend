//
//  MyBankCardViewController.m
//  LegendWorld
//
//  Created by ios-dev-01 on 16/9/21.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "MyBankCardViewController.h"
#import "BankWithdrawViewController.h"
#import "AddBankCardViewController.h"
#import "MJRefresh.h"
#import "MyCardTableViewCell.h"
#import "MyCardDetailsViewController.h"
#import "BankWithdrawViewController.h"

@interface MyBankCardViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,RefreshingViewDelegate>

@property(weak,nonatomic)UITableView *myTableView;
@property(strong,nonatomic)NSMutableArray *dataArray;

@end

@implementation MyBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的银行卡";
    self.dataArray = [NSMutableArray new];
    [self initFrameView];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestData];
}

//登录刷新页面
-(void)refreshingUI{
    [self requestData];
}

-(void) requestData
{
    NSDictionary *dic = @{@"device_id":[FrankTools getDeviceUUID],
                          @"token":[FrankTools getUserToken]};
    [self showHUD];
    [MainRequest RequestHTTPData:PATH(@"api/cash/getCardList") parameters:dic success:^(id responseData) {
        [self hideHUD];
        [self.myTableView headerEndRefreshing];
        self.dataArray = [[NSMutableArray alloc] initWithArray:[responseData objectForKey:@"bank_info"]];
        [self.myTableView reloadData];
    } failed:^(NSDictionary *errorDic) {
        [self.myTableView headerEndRefreshing];
        [self hideHUD];
        if ([self isReLogin:errorDic]) {
            [self popLoginView:self];
        } else {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }
    }];
}

-(void) initFrameView
{
    UITableView *myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight) style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.backgroundColor = viewColor;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    __weak __typeof(self)weakSelf = self;
    [myTableView addHeaderWithCallback:^{
        [weakSelf requestData];
    }];
    self.myTableView = myTableView;
    [self.view addSubview:self.myTableView];
}

#pragma mark - UItabViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 40;
    }else{
        return 5;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 40)];
        bgView.backgroundColor = viewColor;
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, DeviceMaxWidth-30, 40)];
        titleLab.text = @"储蓄卡";
        titleLab.textColor = contentTitleColorStr2;
        titleLab.font = [UIFont systemFontOfSize:14];
        [bgView addSubview:titleLab];
        return bgView;
    }else{
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 5)];
        bgView.backgroundColor = viewColor;
        return bgView;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.dataArray.count;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * tifier = @"FrankCell";
    MyCardTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:tifier];
    if (cell == nil) {
        cell = [[MyCardTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 1) {
        cell.nameLab.hidden = YES;
        cell.detailLab.hidden = YES;
        cell.addCardLab.hidden = NO;
        [cell.logoIm setImage:imageWithName(@"addCreditCard")];//circle_plus //addCreditCard

    }else if (indexPath.section == 0){
        if (self.dataArray <= 0) {
            return cell;
        }cell.nameLab.hidden = NO;
        cell.detailLab.hidden = NO;
        cell.addCardLab.hidden = YES;
        NSDictionary *dic = self.dataArray[indexPath.row];
        FLLog(@"%@",[NSString stringWithFormat:@"%@",[dic objectForKey:@"bank_name"]]);
        [FrankTools setImgWithImgView:cell.logoIm withImageUrl:[dic objectForKey:@"bank_logo"] withPlaceHolderImage:placeSquareImg];
        cell.nameLab.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"bank_name"]];
        cell.detailLab.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"card_no"]];
        if (indexPath.row == self.dataArray.count-1) {
            cell.lineView.hidden = YES;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSDictionary *dic = self.dataArray[indexPath.row];
        if (self.isManagePage) {
            MyCardDetailsViewController *cardDetailVc = [MyCardDetailsViewController new];
            cardDetailVc.dataDic = dic;
            [self.navigationController pushViewController:cardDetailVc animated:YES];
        }else{
            BankWithdrawViewController *bankVc = [BankWithdrawViewController new];
            bankVc.dataDic = dic;
            [self.navigationController pushViewController:bankVc animated:YES];
        }
        
    }else if (indexPath.section == 1){//添加银行卡
        AddBankCardViewController *addBankView = [AddBankCardViewController new];
        [self.navigationController pushViewController:addBankView animated:YES];
        
    }
}

-(void)clickDeleteButtonEvent:(UIButton *)button_
{
    FLLog(@"点击删除银行卡");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"是否删除该银行卡!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"确定", nil];
    alert.tag = button_.tag;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        FLLog(@"确定删除");
        [self deleteBankCard:alertView.tag];
    }
}

-(void)deleteBankCard:(NSInteger)index
{
    [self showHUD];
    NSString *banId = [NSString stringWithFormat:@"%@",[self.dataArray[index] objectForKey:@"card_id"]];
    NSDictionary *dic = @{@"bank_id":banId,
                          @"token":[FrankTools getUserToken],
                          @"device_id":[FrankTools getDeviceUUID]};
    [MainRequest RequestHTTPData:PATH(@"api/cash/unlockCard") parameters:dic success:^(id responseData) {
        [self hideHUD];
        [self.dataArray removeObjectAtIndex:index];
        [self.myTableView reloadData];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
