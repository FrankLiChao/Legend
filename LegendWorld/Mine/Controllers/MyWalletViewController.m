//
//  MyWalletViewController.m
//  LegendWorld
//
//  Created by ios-dev-01 on 16/9/17.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "MyWalletViewController.h"
#import "MyWalletTableViewCell.h"
#import "WithdrawViewController.h"
#import "MyBankCardViewController.h"
#import "MyIncomeViewController.h"

@interface MyWalletViewController ()<UITableViewDataSource,UITableViewDelegate,RefreshingViewDelegate>

@property(nonatomic,weak)UIScrollView *myScrollView;
@property(nonatomic,weak)UITableView *myTableView;
@property(nonatomic,weak)UILabel *surplusMoneyLab;//余额
@property(nonatomic,weak)UILabel *TodayIncomeMoneyLab;//今日收益
@property(nonatomic,weak)UILabel *totalIncomeMoneyLab;//总收益
@property(nonatomic,weak)UIView *headView;
@property(nonatomic,weak)UIImage *nowImage;
@property(nonatomic,weak)UILabel *bankNum;
@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,strong)NSArray *imageArray;
@property(nonatomic)NSInteger myBankNum;

@end

@implementation MyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的钱包";
    self.edgesForExtendedLayout = UIRectEdgeTop;
    self.imageArray = @[@"mine_envelope",@"mine_money",@"mine_money_box",@"mine_shopping",@"mine_guanlian",@"mine_zhitui",@"mine_fenhong",@"mine_jiangli",@"mine_tokIncome"];
    UIBarButtonItem *myCard = [[UIBarButtonItem alloc] initWithTitle:@"我的收益" style:UIBarButtonItemStylePlain target:self action:@selector(clickMyIncomeEvent)];
    self.navigationItem.rightBarButtonItem = myCard;
    
    [self requestData];
    
    [self initFrameView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestCardCount];
}

-(void)requestCardCount{
    NSDictionary *dic = @{@"token":[FrankTools getUserToken],
                          @"device_id":[FrankTools getDeviceUUID]};
    [MainRequest RequestHTTPData:PATH(@"api/Cash/getValidCardCount") parameters:dic success:^(id responseData) {
        self.myBankNum = [[responseData objectForKey:@"count"] integerValue];
        self.bankNum.text = [NSString stringWithFormat:@"%ld",(long)self.myBankNum];
        FLLog(@"%@",responseData);
    } failed:^(NSDictionary *errorDic) {
        
    }];
}

#pragma mark - 登录刷新页面
-(void)refreshingUI{
    [self requestData];
    [self requestCardCount];
}

- (void)requestData{
    [self showHUD];
    NSDictionary *dic = @{@"device_id":[FrankTools getDeviceUUID],
                          @"token":[FrankTools getUserToken]};
    [MainRequest RequestHTTPData:PATH(@"api/cash/transationRecordList") parameters:dic success:^(id responseData) {
        self.dataArray = [responseData objectForKey:@"task_list"];
        if (self.dataArray && self.dataArray.count>0) {
            self.myTableView.frame = CGRectMake(0, CGRectGetHeight(self.headView.frame)+40, DeviceMaxWidth, 40*widthRate+self.dataArray.count*70*widthRate);
            [self.myTableView reloadData];
            [self initUI:responseData];
            [self.myScrollView setupAutoContentSizeWithBottomView:self.myTableView bottomMargin:10];
        }
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

-(void)initUI :(NSDictionary *)dataDic{//balance
//    NSString *surplusMoney = [[[NSUserDefaults standardUserDefaults] objectForKey:userLoginDataToLocal] objectForKey:@"money"];
//    self.surplusMoneyLab.text = [NSString stringWithFormat:@"%.2f",[surplusMoney floatValue]];
    self.TodayIncomeMoneyLab.text = [NSString stringWithFormat:@"%.2f",[[dataDic objectForKey:@"day_income"] floatValue]];
    self.totalIncomeMoneyLab.text = [NSString stringWithFormat:@"%.2f",[[dataDic objectForKey:@"total_income"] floatValue]];
    self.bankNum.text = [NSString stringWithFormat:@"%ld",(long)self.myBankNum];
    self.surplusMoneyLab.text = [NSString stringWithFormat:@"%.2f",[[dataDic objectForKey:@"balance"] floatValue]];
}

-(void)initFrameView
{
    UIScrollView *myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight-64)];
    myScrollView.backgroundColor = viewColor;
    myScrollView.showsVerticalScrollIndicator = NO;
    self.myScrollView = myScrollView;
    [self.view addSubview:self.myScrollView];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 231*widthRate)];
    headView.backgroundColor = mainColor;
    self.headView = headView;
    [myScrollView addSubview:self.headView];
    
    UILabel *surplusLab = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 10*widthRate, DeviceMaxWidth-20*widthRate, 20*widthRate)];
    surplusLab.text = @"余额";
    surplusLab.font = [UIFont systemFontOfSize:16];
    surplusLab.textColor = [UIColor whiteColor];
    surplusLab.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:surplusLab];
    
    UILabel *surplusMoneyLab = [UILabel new];
    surplusMoneyLab.text = [[[NSUserDefaults standardUserDefaults] objectForKey:userLoginDataToLocal] objectForKey:@"money"];
    surplusMoneyLab.font = [UIFont systemFontOfSize:35];
    surplusMoneyLab.textColor = [UIColor whiteColor];
    surplusMoneyLab.textAlignment = NSTextAlignmentCenter;
    self.surplusMoneyLab = surplusMoneyLab;
    [headView addSubview:self.surplusMoneyLab];
    
    self.surplusMoneyLab.sd_layout
    .leftEqualToView(surplusLab)
    .rightEqualToView(surplusLab)
    .topSpaceToView(surplusLab,10*widthRate)
    .heightIs(40*widthRate);
    
    UIButton *withdrawBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [withdrawBtn setTitle:@"提现" forState:UIControlStateNormal];
    withdrawBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [withdrawBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    withdrawBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    withdrawBtn.layer.borderWidth = 1;
    withdrawBtn.layer.cornerRadius = 5;
    withdrawBtn.layer.masksToBounds = YES;
    [withdrawBtn addTarget:self action:@selector(clickWithdrawButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:withdrawBtn];
    
    withdrawBtn.sd_layout
    .leftSpaceToView(headView,130*widthRate)
    .rightSpaceToView(headView,130*widthRate)
    .heightIs(40*widthRate)
    .topSpaceToView(surplusMoneyLab,15*widthRate);
    
    UILabel *tipLab = [UILabel new];
    tipLab.text = @"注：最低提现额20元";
    tipLab.textColor = [UIColor whiteColor];
    tipLab.font = [UIFont systemFontOfSize:12];
    tipLab.textAlignment = NSTextAlignmentCenter;
//    [headView addSubview:tipLab];
    
    tipLab.sd_layout
    .leftSpaceToView(headView,10)
    .rightSpaceToView(headView,10)
    .topSpaceToView(withdrawBtn,10*widthRate)
    .heightIs(15);
    
    UILabel *TodayIncomeMoneyLab = [UILabel new];
    TodayIncomeMoneyLab.text = @"0.00";
    TodayIncomeMoneyLab.font = [UIFont systemFontOfSize:22];
    TodayIncomeMoneyLab.textColor = [UIColor whiteColor];
    TodayIncomeMoneyLab.textAlignment = NSTextAlignmentCenter;
    self.TodayIncomeMoneyLab = TodayIncomeMoneyLab;
    [headView addSubview:self.TodayIncomeMoneyLab];
    
    self.TodayIncomeMoneyLab.sd_layout
    .leftSpaceToView(headView,50*widthRate)
    .topSpaceToView(withdrawBtn,30*widthRate)
    .widthIs(DeviceMaxWidth/2-50*widthRate)
    .heightIs(30*widthRate);
    
    UILabel *TodayIncomeLab = [UILabel new];
    TodayIncomeLab.text = @"今日收益";
    TodayIncomeLab.font = [UIFont systemFontOfSize:13];
    TodayIncomeLab.textColor = [UIColor whiteColor];
    TodayIncomeLab.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:TodayIncomeLab];
    
    TodayIncomeLab.sd_layout
    .leftSpaceToView(headView,50*widthRate)
    .bottomSpaceToView(headView,10*widthRate)
    .widthIs(DeviceMaxWidth/2-50*widthRate)
    .heightIs(30*widthRate);
    
    UILabel *totalIncomemLab = [UILabel new];
    totalIncomemLab.text = @"0.00";
    totalIncomemLab.font = [UIFont systemFontOfSize:22];
    totalIncomemLab.textColor = [UIColor whiteColor];
    totalIncomemLab.textAlignment = NSTextAlignmentCenter;
    self.totalIncomeMoneyLab = totalIncomemLab;
    [headView addSubview:self.totalIncomeMoneyLab];
    
    self.totalIncomeMoneyLab.sd_layout
    .rightSpaceToView(headView,50*widthRate)
    .topSpaceToView(withdrawBtn,30*widthRate)
    .widthIs(DeviceMaxWidth/2-50*widthRate)
    .heightIs(30*widthRate);
    
    UILabel *totalIncomeLab = [UILabel new];
    totalIncomeLab.text = @"总收益";
    totalIncomeLab.font = [UIFont systemFontOfSize:13];
    totalIncomeLab.textColor = [UIColor whiteColor];
    totalIncomeLab.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:totalIncomeLab];
    
    totalIncomeLab.sd_layout
    .rightSpaceToView(headView,50*widthRate)
    .bottomSpaceToView(headView,10*widthRate)
    .widthIs(DeviceMaxWidth/2-50*widthRate)
    .heightIs(30*widthRate);
    
    UIView *bankView = [UIView new];
    myScrollView.backgroundColor = [UIColor whiteColor];
    [self.myScrollView addSubview:bankView];
    
    bankView.sd_layout
    .leftSpaceToView(myScrollView,0)
    .rightSpaceToView(myScrollView,0)
    .topSpaceToView(headView,0)
    .heightIs(40);
    
    UILabel *nameL = [UILabel new];
    nameL.text = @"银行卡管理";
    nameL.textColor = contentTitleColorStr1;
    nameL.font = [UIFont systemFontOfSize:14];
    [bankView addSubview:nameL];
    
    nameL.sd_layout
    .leftSpaceToView(bankView,15*widthRate)
    .widthIs(200)
    .yIs(0)
    .heightIs(40);
    
    UIImageView *arrowImage = [UIImageView new];
    [arrowImage setImage:imageWithName(@"rightjiantou")];
    [bankView addSubview:arrowImage];
    
    arrowImage.sd_layout
    .rightSpaceToView(bankView,10*widthRate)
    .centerYEqualToView(bankView)
    .widthIs(12*widthRate)
    .heightIs(12*widthRate);
    
    UILabel *bankNum = [UILabel new];
    bankNum.text = @"1";
    bankNum.textColor = contentTitleColorStr2;
    bankNum.font = [UIFont systemFontOfSize:14];
    bankNum.textAlignment = NSTextAlignmentRight;
    self.bankNum = bankNum;
    [bankView addSubview:bankNum];
    
    bankNum.sd_layout
    .rightSpaceToView(arrowImage,4*widthRate)
    .yIs(0)
    .widthIs(100)
    .heightIs(40);
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 40-0.5, DeviceMaxWidth, 0.5)];
    lineV.backgroundColor = tableDefSepLineColor;
    [bankView addSubview:lineV];
    
    UIButton *bankBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bankBtn.frame = CGRectMake(0, 0, DeviceMaxWidth, 40);
    [bankBtn addTarget:self action:@selector(clickMyBankEvent) forControlEvents:UIControlEventTouchUpInside];
    [bankView addSubview:bankBtn];
    
    UITableView *myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 231*widthRate+40, DeviceMaxWidth, 40*widthRate+_dataArray.count*70*widthRate) style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.scrollEnabled = NO;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView = myTableView;
    [myScrollView addSubview:self.myTableView];
    
    [myScrollView setupAutoContentSizeWithBottomView:self.myTableView bottomMargin:10];
}

#pragma mark - UItabViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40*widthRate;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 40*widthRate)];
    bgView.backgroundColor = viewColor;
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15*widthRate, 0, DeviceMaxWidth-30*widthRate, 40*widthRate)];
    lab.text = @"交易明细";
    lab.textColor = contentTitleColorStr1;
    lab.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:lab];
    
    UILabel *timeLab = [UILabel new];
    timeLab.text = @"今日";
    timeLab.textColor = contentTitleColorStr1;
    timeLab.font = [UIFont systemFontOfSize:14];
    timeLab.textAlignment = NSTextAlignmentRight;
//    [bgView addSubview:timeLab];
    
    timeLab.sd_layout
    .rightSpaceToView(bgView,10)
    .xIs(0)
    .widthIs(100)
    .heightIs(40*widthRate);
    
    return bgView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70*widthRate;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * tifier = @"FrankCell";
    MyWalletTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:tifier];
    if (cell == nil) {
        cell = [[MyWalletTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = _dataArray[indexPath.row];
    cell.name.text =  [self getTypeValue:[[dic objectForKey:@"type"] integerValue]];
    [cell.typeImage setImage:self.nowImage];
    cell.data.text = [FrankTools LongTimeToString:[dic objectForKey:@"etime"] withFormat:@"YYYY-MM-dd HH:mm:ss"];
    cell.money.text = [NSString stringWithFormat:@"%.2f",[[dic objectForKey:@"money"] floatValue]];
    if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"money"]] floatValue] > 0) {
        cell.moneyType.text = @"收入";
    }else{
        cell.moneyType.text = @"支出";
    }
    return cell;
}

#pragma mark - 提现
-(void)clickWithdrawButtonEvent
{
    FLLog(@"点击提现按钮");
    WithdrawViewController *withdrawView = [WithdrawViewController new];
    [self.navigationController pushViewController:withdrawView animated:YES];
}

-(void)clickMyIncomeEvent{
    MyIncomeViewController *myIncomeVc = [MyIncomeViewController new];
    [self.navigationController pushViewController:myIncomeVc animated:YES];
}

-(void)clickMyBankEvent
{
    FLLog(@"点击我的银行卡按钮");
    MyBankCardViewController *myBankView = [MyBankCardViewController new];
    myBankView.isManagePage = YES;
    [self.navigationController pushViewController:myBankView animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)getTypeValue:(NSInteger)type{
    NSString *typeString = nil;
    switch (type) {
        case 1:
            typeString = @"广告收入";
            self.nowImage = imageWithName(_imageArray[0]);
            break;
        case 2:
            typeString = @"提现";
            self.nowImage = imageWithName(_imageArray[2]);
            break;
        case 3:
            typeString = @"提现返回";
            self.nowImage = imageWithName(_imageArray[2]);
            break;
        case 4:
            typeString = @"微信退款";
            self.nowImage = imageWithName(_imageArray[0]);
            break;
        case 5:
            typeString = @"发红包";
            self.nowImage = imageWithName(_imageArray[0]);
            break;
        case 6:
            typeString = @"发红包未抢完退款";
            self.nowImage = imageWithName(_imageArray[0]);
            break;
        case 7:
            typeString = @"抢红包收入";
            self.nowImage = imageWithName(_imageArray[0]);
            break;
        case 8:
            typeString = @"升级活动";
            self.nowImage = imageWithName(_imageArray[0]);
            break;
        case 9:
            typeString = @"手机余额充值扣除";
            self.nowImage = imageWithName(_imageArray[0]);
            break;
        case 10:
            typeString = @"商品购买扣除";
            self.nowImage = imageWithName(_imageArray[3]);
            break;
        case 11:
            typeString = @"商品购买返点";
            self.nowImage = imageWithName(_imageArray[3]);
            break;
        case 12:
            typeString = @"系统红包";
            self.nowImage = imageWithName(_imageArray[0]);
            break;
        case 13:
            typeString = @"商品购买退款";
            self.nowImage = imageWithName(_imageArray[3]);
            break;
        case 14:
            typeString = @"商家商品购买分成";
            self.nowImage = imageWithName(_imageArray[0]);
            break;
        case 15:
            typeString = @"任务收入";
            break;
        case 16:
            typeString = @"手机充值退款";
            self.nowImage = imageWithName(_imageArray[0]);
            break;
        case 17:
            typeString = @"当月分享经济收入";
            self.nowImage = imageWithName(_imageArray[6]);
            break;
        case 18:
            typeString = @"用户代言系统收入";
            self.nowImage = imageWithName(_imageArray[1]);
            break;
        case 19:
            typeString = @"活动奖励系统收入";
            self.nowImage = imageWithName(_imageArray[7]);
            break;
        case 20:
            typeString = @"支付收益";
            self.nowImage = imageWithName(_imageArray[8]);
            break;
        default:
            break;
    }
    return typeString;
}

@end
