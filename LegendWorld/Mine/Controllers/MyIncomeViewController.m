//
//  MyIncomeViewController.m
//  LegendWorld
//
//  Created by Frank on 2016/10/27.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "MyIncomeViewController.h"
#import "WithdrawViewController.h"
#import "IncomeTitleTabCell.h"
#import "IncomeContentTableCell.h"
#import "KeepOnViewController.h"
#import "WaitShareViewController.h"
#import "IncomeDetailViewController.h"
#import "UserIncomeModel.h"
#import "ChooseView.h"
#import "IncomeListModel.h"
#import "LoadControl.h"
#import "MJRefresh.h"
#import "BecomeDelegateViewController.h"

@interface MyIncomeViewController ()<UITableViewDelegate,UITableViewDataSource,ChooseViewDelegate>

@property (nonatomic,weak)UITableView *myTableView;
@property (strong,nonatomic)UserIncomeModel *userIncomeModel;
@property (strong,nonatomic)UserModel   *userModel;
@property (strong,nonatomic)NSArray     *incomeList;
@property (strong,nonatomic) NSMutableDictionary *group;
@property (strong,nonatomic) NSArray *sortKeys;

@property (nonatomic,strong) NSString *nextDate;
@property (nonatomic,strong) NSString *lastDate;
@end

@implementation MyIncomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收益";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提现" style:UIBarButtonItemStylePlain target:self action:@selector(jumpWithdrawEvent)];
    [self initData];
    [self initFrameView];
    [self requestData:@""];
}

-(void)headerRefresh{
    [self initData];
    [self requestData:@""];
}

-(void)initData{
    self.incomeList = [NSArray new];
    self.userModel = [self getUserData];
    self.group = [NSMutableDictionary new];
}

-(void)requestData:(NSString *)typeStr{
    [self showHUDWithMessage:nil];
    NSDictionary *dic1 = @{@"token":[FrankTools getUserToken],
                           @"device_id":[FrankTools getDeviceUUID]};
    [MainRequest RequestHTTPData:PATH(@"Api/Cash/getMyIncome") parameters:dic1 success:^(id responseData1) {
        [self.myTableView headerEndRefreshing];
        self.userIncomeModel = [UserIncomeModel parseResponse:responseData1];
        NSDictionary *dic2 = @{@"token":[FrankTools getUserToken],
                              @"device_id":[FrankTools getDeviceUUID],
                              @"next_date":@"",
                               @"type":[NSString stringWithFormat:@"%@",([typeStr integerValue]!=0)?typeStr:@""]};
        [MainRequest RequestHTTPData:PATH(@"Api/Cash/myIncomeList") parameters:dic2 success:^(id responseData2) {
            self.incomeList = [IncomeListModel parseResponse:responseData2];
            self.nextDate = [responseData2 objectForKey:@"next_date"];
            self.lastDate = [responseData2 objectForKey:@"last_date"];
            for (IncomeListModel *model in self.incomeList) {
                if (![[self.group allKeys] containsObject:model.finish_date]) {
                    NSMutableArray *array = [NSMutableArray arrayWithObject:model];
                    [self.group setObject:array forKey:model.finish_date];
                } else {
                    NSMutableArray *array = [self.group objectForKey:model.finish_date];
                    [array addObject:model];
                }
            }
            self.sortKeys = [[self.group allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                NSString *finishDate1 = (NSString *)obj1;
                NSString *finishDate2 = (NSString *)obj2;
                NSDateFormatter *formater = [[NSDateFormatter alloc] init];
                formater.dateFormat = @"yyy-MM-dd";
                NSDate *date1 = [formater dateFromString:finishDate1];
                NSDate *date2 = [formater dateFromString:finishDate2];
                if ([date1 compare:date2] == NSOrderedDescending) {
                    return NSOrderedAscending;
                } else if ([date1 compare:date2] == NSOrderedAscending) {
                    return NSOrderedDescending;
                }
                return NSOrderedSame;
            }];
            [self.myTableView reloadData];
            [self hideHUD];
        } failed:^(NSDictionary *errorDic) {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }];
    } failed:^(NSDictionary *errorDic) {
        [self.myTableView headerEndRefreshing];
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

- (void)loadMoreData:(LoadControl *)loadControl {
    NSDictionary *dic2 = @{@"token":[FrankTools getUserToken],
                           @"device_id":[FrankTools getDeviceUUID],
                           @"next_date":self.nextDate,
                           @"type":@""};
    [MainRequest RequestHTTPData:PATH(@"Api/Cash/myIncomeList") parameters:dic2 success:^(id responseData2) {
        self.nextDate = [responseData2 objectForKey:@"next_date"];
        self.lastDate = [responseData2 objectForKey:@"last_date"];
        NSArray *appendArr = [IncomeListModel parseResponse:responseData2];
        
        for (IncomeListModel *model in appendArr) {
            if (![[self.group allKeys] containsObject:model.finish_date]) {
                NSMutableArray *array = [NSMutableArray arrayWithObject:model];
                [self.group setObject:array forKey:model.finish_date];
            } else {
                NSMutableArray *array = [self.group objectForKey:model.finish_date];
                [array addObject:model];
            }
        }
        
        NSMutableArray *mutableList = [NSMutableArray arrayWithArray:self.incomeList];
        [mutableList addObjectsFromArray:appendArr];
        self.sortKeys = [[self.group allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSString *finishDate1 = (NSString *)obj1;
            NSString *finishDate2 = (NSString *)obj2;
            NSDateFormatter *formater = [[NSDateFormatter alloc] init];
            formater.dateFormat = @"yyy-MM-dd";
            NSDate *date1 = [formater dateFromString:finishDate1];
            NSDate *date2 = [formater dateFromString:finishDate2];
            if ([date1 compare:date2] == NSOrderedDescending) {
                return NSOrderedAscending;
            } else if ([date1 compare:date2] == NSOrderedAscending) {
                return NSOrderedDescending;
            }
            return NSOrderedSame;
        }];
        self.incomeList = [mutableList copy];
        [self.myTableView reloadData];
        [loadControl endLoading:YES];
    } failed:^(NSDictionary *errorDic) {
        [loadControl endLoading:NO];
    }];
}

-(void)initFrameView{
    UITableView *tabview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight-64) style:UITableViewStylePlain];
    tabview.delegate = self;
    tabview.dataSource = self;
    tabview.backgroundColor = viewColor;
    tabview.showsVerticalScrollIndicator = NO;
    tabview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tabview addHeaderWithTarget:self action:@selector(headerRefresh)];

    self.myTableView = tabview;
    [self.view addSubview:tabview];
    
    __weak typeof (self) weakSelf = self;
    LoadControl *loadControl = [[LoadControl alloc] initWithScrollView:self.myTableView];
    loadControl.color = [UIColor noteTextColor];
    loadControl.displayCondition = ^{
        BOOL isDisplay = weakSelf.incomeList.count > 0;
        return isDisplay;
    };
    loadControl.loadAllCondition= ^{
        BOOL isLoadAll = [weakSelf.nextDate isEqualToString:weakSelf.lastDate];
        return isLoadAll;
    };
    [loadControl addTarget:self action:@selector(loadMoreData:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    } else {
        return 40*widthRate;
    }
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 40*widthRate)];
    bgView.backgroundColor = viewColor;
    UILabel *dataLab = [UILabel new];
    dataLab.text = self.sortKeys[section-1];
    dataLab.textColor = contentTitleColorStr2;
    dataLab.font = [UIFont systemFontOfSize:14];
    dataLab.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:dataLab];
    
    dataLab.sd_layout
    .centerYEqualToView(bgView)
    .centerXEqualToView(bgView)
    .widthIs(100)
    .heightIs(40*widthRate);

    if (section == 0) {
        return nil;
    }else if (section == 1) {
        UILabel *incomeDetail = [[UILabel alloc] initWithFrame:CGRectMake(15*widthRate, 0, 100, 40*widthRate)];
        incomeDetail.text = @"收益明细";
        incomeDetail.textColor = contentTitleColorStr2;
        incomeDetail.font = [UIFont systemFontOfSize:14];
        [bgView addSubview:incomeDetail];
        
        UIButton *chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [chooseBtn setTitle:@"筛选" forState:UIControlStateNormal];
        [chooseBtn setTitleColor:contentTitleColorStr2 forState:UIControlStateNormal];
        [chooseBtn setImage:imageWithName(@"triangle") forState:UIControlStateNormal];
        [chooseBtn addTarget:self action:@selector(clickSelectEvent) forControlEvents:UIControlEventTouchUpInside];
        chooseBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        chooseBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 65*widthRate, 0, 0);
        [bgView addSubview:chooseBtn];
        
        chooseBtn.sd_layout
        .rightSpaceToView(bgView,10*widthRate)
        .topSpaceToView(bgView,0)
        .widthIs(80*widthRate)
        .heightIs(40*widthRate);

        return bgView;
    }
    return bgView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.group.count + 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    NSString *key = [self.sortKeys objectAtIndex:section - 1];
    NSArray *incomeList = [self.group objectForKey:key];
    return incomeList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 195*widthRate;
    }else{
        return 70*widthRate;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString * tifier = @"FrankCell";
        IncomeTitleTabCell * fcell = [tableView dequeueReusableCellWithIdentifier:tifier];
        if (fcell == nil) {
            fcell = [[IncomeTitleTabCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tifier];
        }
        fcell.selectionStyle = UITableViewCellSelectionStyleNone;
        [fcell.goOnBtn addTarget:self action:@selector(clickGoOnEvent) forControlEvents:UIControlEventTouchUpInside];
        [fcell.waiBtn addTarget:self action:@selector(clickWaitEvent) forControlEvents:UIControlEventTouchUpInside];
        fcell.nameLab.text = [NSString stringWithFormat:@"%@",_userModel.user_name];
        [FrankTools setImgWithImgView:fcell.headIm withImageUrl:_userModel.photo_url withPlaceHolderImage:defaultUserHead];
        NSString *honor_grade =  [NSString stringWithFormat:@"mine_grade_v%ld", (long)[_userModel.honor_grade integerValue]];
        if ([_userModel.honor_grade integerValue] == 0) {
            fcell.imagaTag.hidden = YES;
        }else{
            fcell.imagaTag.hidden = NO;
            [fcell.imagaTag setImage:imageWithName(honor_grade)];
        }
        NSString *today_income = [NSString stringWithFormat:@"今日收益：%.2f",[_userIncomeModel.today_income floatValue]];
        fcell.todayIncome.attributedText = [FrankTools setFontColor:mainColor WithString:today_income WithRange:NSMakeRange(5, today_income.length-5)];
        NSString *total_income = [NSString stringWithFormat:@"总收益：%.2f",[_userIncomeModel.total_income floatValue]];//total_income
        fcell.totalIncome.attributedText = [FrankTools setFontColor:mainColor WithString:total_income WithRange:NSMakeRange(4, total_income.length-4)];
        fcell.goonMoney.text = [NSString stringWithFormat:@"%.2f",[_userIncomeModel.process_income floatValue]];
        
        fcell.waitMoney.text = _userIncomeModel.weekshare_pre_income.length>0?_userIncomeModel.weekshare_pre_income:@"0.00";
        return fcell;
    }else{
        static NSString * tifiCell = @"tifiCell";
        IncomeContentTableCell * cell = [tableView dequeueReusableCellWithIdentifier:tifiCell];
        if (cell == nil) {
            cell = [[IncomeContentTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tifiCell];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString *key = [self.sortKeys objectAtIndex:indexPath.section - 1];
        NSArray *incomeList = [self.group objectForKey:key];
        IncomeListModel *model = incomeList[indexPath.row];
        NSString *imageStr = @"";
        if ([model.share_type integerValue] == 2 || [model.share_type integerValue] == 19) {
            imageStr = @"mine_guanlian";
            cell.nameLab.text = @"广告收益2";
        }else if ([model.share_type integerValue] == 4 || [model.share_type integerValue] == 18) {
            imageStr = @"mine_zhitui";
            cell.nameLab.text = @"广告收益1";
        }else if ([model.share_type integerValue] == 5){
            imageStr = @"mine_fenhong";
            cell.nameLab.text = @"广告收益3";
        }else if ([model.share_type integerValue] == 16) {//mine_jiangli
            imageStr = @"mine_jiangli";
            cell.nameLab.text = @"支付分润2";
        }else if ([model.share_type integerValue] == 17) {
            imageStr = @"mine_fenhong";
            cell.nameLab.text = @"支付分润1";
        }
        [cell.logoIm setImage:imageWithName(imageStr)];
        cell.moneyLab.text = [NSString stringWithFormat:@"%.2f",[model.money floatValue]];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return;
    }
    NSString *key = [self.sortKeys objectAtIndex:indexPath.section - 1];
    NSArray *incomeList = [self.group objectForKey:key];
    IncomeListModel *model = incomeList[indexPath.row];
    IncomeDetailViewController *detailVc = [IncomeDetailViewController new];
    detailVc.income_id = model.income_id;
    if ([model.share_type integerValue] == 16 || [model.share_type integerValue] == 17) {//表示分润和奖励收益
        detailVc.isTok = YES;
    }
    [self.navigationController pushViewController:detailVc animated:YES];
}

#pragma mark - 点击事件
-(void)clickSelectEvent{ //点击筛选
    ChooseView *chooseView = [[ChooseView alloc] initWithFrame:self.view.bounds];
    chooseView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:chooseView];
}

-(void)ChooseTypeEvet:(NSInteger)type{
    [self initData];
    if (type == 0) {
        [self requestData:@"4"];//直推收益
    }else if (type == 1) {
        [self requestData:@"2"];//关联收益
    }else if (type == 2) {
        [self requestData:@"5"];//每周分红
    }else if (type == 3) {
        [self requestData:@"17"];//分润收益
    }else if (type == 4) {
        [self requestData:@"16"];//奖励收益
    }
}

-(void)clickGoOnEvent{
    KeepOnViewController *goOnVc = [KeepOnViewController new];
    [self.navigationController pushViewController:goOnVc animated:YES];
}

-(void)clickWaitEvent{
    if ([self.userIncomeModel.grade integerValue] > 0) {
        WaitShareViewController *waitVc = [WaitShareViewController new];
        [self.navigationController pushViewController:waitVc animated:YES];
    }else {
        BecomeDelegateViewController *becomeVc = [BecomeDelegateViewController new];
        [self.navigationController pushViewController:becomeVc animated:YES];
    }
}

-(void)jumpWithdrawEvent{
    WithdrawViewController *withD = [WithdrawViewController new];
    [self.navigationController pushViewController:withD animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
