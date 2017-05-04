//
//  CashViewController.m
//  legend
//
//  Created by heyk on 15/11/30.
//  Copyright © 2015年 e3mo. All rights reserved.
//

#import "CashListViewController.h"
#import "CashListModel.h"
#import "CashListCell.h"
#import "MJRefresh.h"
#import "MJExtension.h"

@interface CashListViewController ()<RefreshingViewDelegate>{
    NSInteger page;      //当前页数
    NSInteger allPno;   //总页数
}
@property (nonatomic,strong)NSMutableArray *dataList;


@end

@implementation CashListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:viewColor];
    self.title = @"提现记录";
    self.dataList = [[NSMutableArray alloc] init];
    
    page = 1;
    _atableView.showsVerticalScrollIndicator = NO;
    [self reloadData];
    [_atableView addHeaderWithCallback:^{
        [self headerRefresh];
    }];
    [_atableView addFooterWithCallback:^{
        [self footerRefresh];
    }];
    
}

//下拉刷新
- (void)headerRefresh
{
    page = 1;
    [self reloadData];
    [_atableView headerEndRefreshing];
}

//上拉加载
- (void)footerRefresh
{
    if (page >= allPno) {
        [FrankTools showAlertWithMessage:@"没有更多数据了~" withSuperView:self.view withHeih:DeviceMaxHeight-80];
        [_atableView footerEndRefreshing];
        return;
    }
    page++;
    [self reloadData];
    [_atableView footerEndRefreshing];
}

-(void)viewWillAppear:(BOOL)animated  {

    [super viewWillAppear:animated];
    [self performSelector:@selector(restoreContentInset) withObject:nil afterDelay:0.1];
    
}

-(void)restoreContentInset{
    [_atableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
}
- (void)reloadData{
    NSDictionary *dic = @{@"device_id":[FrankTools getDeviceUUID],
                          @"token":[FrankTools getUserToken],
                          @"page":@"1"};
    [self showHUD];
    [MainRequest RequestHTTPData:PATH(@"api/cash/getWithdrawalList") parameters:dic success:^(id responseData) {
        NSArray *list = [responseData objectForKey:@"withdrawal_list"];
        NSMutableArray *results = [NSMutableArray array];
        for (int i = 0; i < list.count; i++) {
            NSDictionary *dataDic = [list objectAtIndex:i];
            CashListModel *model =  [CashListModel mj_objectWithKeyValues:dataDic];
            [results addObject:model];
        }
        int totalPage = [[responseData objectForKey:@"total_page"] intValue];
        BOOL bNeedStopRefresh = NO;
        if (page == 1) {
            bNeedStopRefresh = YES;
            [self.dataList removeAllObjects];
        }
        [self.dataList addObjectsFromArray:results];
        
        if (totalPage <= page) {//已经是最后一页
            FLLog(@"没有更多的数据");
        } else {
            page++;
        }
        [_atableView  reloadData];
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

-(void)refreshingUI{
    [self headerRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableView Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {//行高
    
    CashListModel *model = [_dataList objectAtIndex:indexPath.row];
    if (model.bSelected) {
        return 206*widthRate;
    }
    
    return 81*widthRate;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {//行数
    
    return _dataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
  
    NSString *identifierStr = @"CashListCell1";
    CashListModel *model = [_dataList objectAtIndex:indexPath.row];
    if (model.bSelected) {
        identifierStr = @"CashListCell";;
    }
    
    CashListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
    
    if (!cell) {
        cell = [CashListCell getInstanceWithReuseIdentifier:identifierStr];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    [cell setUIWithModel:model clickResponse:^(UITableViewCell *cell) {
        model.bSelected = !model.bSelected;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


@end
