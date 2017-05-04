//
//  KeepOnViewController.m
//  LegendWorld
//
//  Created by Frank on 2016/11/7.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "KeepOnViewController.h"
#import "GPClassifyPageView.h"
#import "MJRefresh.h"
#import "IncomeContentTableCell.h"
#import "IncomeListModel.h"
#import "IncomeDetailViewController.h"
#import "AgreementViewController.h"

@interface KeepOnViewController ()<UITableViewDelegate,UITableViewDataSource,GPClassifyPageDelegate>

@property (weak,nonatomic)GPClassifyPageView *customView;
@property (nonatomic, strong)NSMutableArray *tableViews;
@property (nonatomic, strong)NSArray *incomeList;
@property (strong,nonatomic) NSMutableDictionary *group;
@property (strong,nonatomic) NSArray *sortKeys;
@property (weak,nonatomic)UIView *bgView;//引导成为代理的View
@property (nonatomic)NSInteger index;
@end

@implementation KeepOnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"进行中的收益";
    self.tableViews = [NSMutableArray new];
    [self initFrameView];
//    [self requestData];
}

-(void)requestData :(NSInteger)page{
    NSString *typeStr = @"";
    if (page == 1) {
        typeStr = @"4";
    }else if (page == 2) {
        typeStr = @"2";
    }else if (page == 3) {
        typeStr = @"5";
    }
    NSDictionary *dic = @{@"token":[FrankTools getUserToken],
                          @"device_id":[FrankTools getDeviceUUID],
                          @"next_date":@"",
                          @"type":typeStr};
    [self showHUDWithMessage:nil];
    [MainRequest RequestHTTPData:PATH(@"Api/Cash/processIncome") parameters:dic success:^(id responseData) {
        [self hideHUD];
        self.incomeList = [IncomeListModel parseProcessResponse:responseData];
        for (IncomeListModel *model in self.incomeList) {
            if (![[self.group allKeys] containsObject:model.create_date]) {
                NSMutableArray *array = [NSMutableArray arrayWithObject:model];
                [self.group setObject:array forKey:model.create_date];
            } else {
                NSMutableArray *array = [self.group objectForKey:model.create_date];
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
        UITableView *mTableView = self.tableViews[page];
        if (self.bgView) {
            [self.bgView removeFromSuperview];
            self.bgView = nil;
        }
        [mTableView reloadData];
    } failed:^(NSDictionary *errorDic) {
        if ([[errorDic objectForKey:@"error_code"] integerValue] == 4000404) {
            [self hideHUD];
            [self initNullView];
        }else{
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }
    }];
}

-(void)initFrameView{
    for (NSInteger i = 0; i < 4; i++) {
        UITableView *myTableView = [[UITableView alloc] initWithFrame:CGRectMake(DeviceMaxWidth*i, 0, DeviceMaxWidth, DeviceMaxHeight-64) style:UITableViewStylePlain];
        myTableView.backgroundColor = viewColor;
        myTableView.delegate = self;
        myTableView.dataSource = self;
//        [myTableView addHeaderWithTarget:self action:@selector(headerRefresh)];
//        [myTableView addFooterWithTarget:self action:@selector(footerRefresh)];
        //知识点 当滑动时，让快速停止下来
        myTableView.decelerationRate = UIScrollViewDecelerationRateFast;
        myTableView.tag = 100 + i;
        myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableViews addObject:myTableView];
    }
    GPClassifyPageView *customView = [[GPClassifyPageView alloc] initWithPagesView:self.tableViews names:@[@"全部",@"广告收益1",@"广告收益2",@"已取消"] andFrame:CGRectMake(0, 0, DeviceMaxWidth*4, DeviceMaxHeight-64)];
    self.customView = customView;
    [self.view addSubview:self.customView];
    self.customView.curPage = 0;
    self.customView.delegate = self;
    [self.customView setupView];
    
}

-(void)initNullView{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(DeviceMaxWidth*2, 0, DeviceMaxWidth, DeviceMaxHeight-64)];
    self.bgView = bgView;
//    self.bgView.hidden = YES;
    [self.customView.contentScrollView addSubview:bgView];
    
    UIImageView *titilIm = [UIImageView new];
    [titilIm setImage:imageWithName(@"mine_defaultdelegate")];
    [bgView addSubview:titilIm];
    
    titilIm.sd_layout
    .centerXEqualToView(bgView)
    .topSpaceToView(bgView,90)
    .widthIs(175*widthRate)
    .heightIs(150*widthRate);
    
    UILabel *textLab = [UILabel new];
    textLab.font = [UIFont systemFontOfSize:13];
    textLab.text = @"您目前尚未成为VIP用户，请先申请哦~";
    textLab.textColor = mainColor;
    textLab.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:textLab];
    
    textLab.sd_layout
    .centerXEqualToView(bgView)
    .topSpaceToView(titilIm,40*widthRate)
    .widthIs(DeviceMaxWidth-30)
    .heightIs(20);
    
    UIButton *invateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [invateBtn setTitle:@"申请成为VIP" forState:UIControlStateNormal];
    [invateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    invateBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    invateBtn.backgroundColor = mainColor;
    invateBtn.layer.cornerRadius = 6;
    invateBtn.layer.masksToBounds = YES;
    [invateBtn addTarget:self action:@selector(clickBecomeDelegate) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:invateBtn];
    
    invateBtn.sd_layout
    .leftSpaceToView(bgView,40*widthRate)
    .rightSpaceToView(bgView,40*widthRate)
    .heightIs(40)
    .topSpaceToView(textLab,40*widthRate);
}

- (void)selectedPage:(NSInteger)page {
    self.index = page;
    FLLog(@"%ld",page);
    self.incomeList = [[NSArray alloc] init];
    self.group = [NSMutableDictionary new];
    self.sortKeys = [[NSArray alloc] init];
    [self requestData:page];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40*widthRate;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 40*widthRate)];
    bgView.backgroundColor = viewColor;
    
    UILabel *dataLab = [UILabel new];
    dataLab.text = self.sortKeys[section];
    dataLab.textColor = contentTitleColorStr2;
    dataLab.textAlignment = NSTextAlignmentCenter;
    dataLab.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:dataLab];
    
    dataLab.sd_layout
    .centerXEqualToView(bgView)
    .widthIs(100)
    .yIs(0)
    .heightIs(40*widthRate);
    if (section == 0) {
        UILabel *detailLab = [[UILabel alloc] initWithFrame:CGRectMake(15*widthRate, 0, 100, 40*widthRate)];
        detailLab.text = @"收益明细";
        detailLab.textColor = contentTitleColorStr2;
        detailLab.font = [UIFont systemFontOfSize:14];
        [bgView addSubview:detailLab];
    }
    return bgView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.group.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [self.sortKeys objectAtIndex:section];
    NSArray *incomeList = [self.group objectForKey:key];
    return incomeList.count;;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70*widthRate;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * tifier = @"FrankCell";
    IncomeContentTableCell * cell = [tableView dequeueReusableCellWithIdentifier:tifier];
    if (cell == nil) {
        cell = [[IncomeContentTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *key = [self.sortKeys objectAtIndex:indexPath.section];
    NSArray *incomeList = [self.group objectForKey:key];
    IncomeListModel *model = incomeList[indexPath.row];
    NSString *imageStr = @"";
    if ([model.share_type integerValue] == 2) {
        imageStr = @"mine_guanlian";
        cell.nameLab.text = @"广告收益2";
    }else if ([model.share_type integerValue] == 4) {
        imageStr = @"mine_zhitui";
        cell.nameLab.text = @"广告收益1";
    }else{
        imageStr = @"mine_fenhong";
        cell.nameLab.text = @"广告收益3";
    }
    [cell.logoIm setImage:imageWithName(imageStr)];
    cell.moneyLab.text = [NSString stringWithFormat:@"%.2f",[model.money floatValue]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [self.sortKeys objectAtIndex:indexPath.section];
    NSArray *incomeList = [self.group objectForKey:key];
    IncomeListModel *model = incomeList[indexPath.row];
    IncomeDetailViewController *detailVc = [IncomeDetailViewController new];
    detailVc.income_id = model.income_id;
    detailVc.isProcessPage = YES;
    if (self.index == 3) {
        detailVc.isCansole = YES;
    }
    [self.navigationController pushViewController:detailVc animated:YES];
}

-(void)clickBecomeDelegate{
    AgreementViewController *agreeVc = [AgreementViewController new];
    [self.navigationController pushViewController:agreeVc animated:YES];
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
