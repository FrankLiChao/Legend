//
//  NoticeViewController.m
//  LegendWorld
//
//  Created by Frank on 2016/11/1.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "NoticeViewController.h"
#import "NoticeTableViewCell.h"
#import "MJRefresh.h"
#import "MainRequest.h"
#import "MessageDetailViewController.h"
#import "WZLBadgeImport.h"
#import "MJExtension.h"
//#import "NoticeListModel.h"

@interface NoticeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak,nonatomic) UITableView *myTableView;
@property (assign,nonatomic)NSInteger pageNo;
@property (assign,nonatomic)NSInteger totalPage;
@property (strong,nonatomic)NSMutableArray *dataArray;
@property (strong,nonatomic)MessageModel *messageModel;
@end

@implementation NoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    _pageNo = 1;
    _dataArray = [NSMutableArray new];
    _messageModel = [MessageModel new];
    [self initFrameView];
    [self headerRefreshing];
}

-(void)initFrameView{
    UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight-64) style:UITableViewStylePlain];
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.backgroundColor = viewColor;
    tableV.showsVerticalScrollIndicator = NO;
    tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableV addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [tableV addFooterWithTarget:self action:@selector(footerRefreshing)];
    self.myTableView = tableV;
    [self.view addSubview:tableV];
}

-(void)headerRefreshing
{
    _pageNo = 1;
    [self requestData:_pageNo];
    [self.myTableView headerEndRefreshing];
}

-(void)footerRefreshing
{
    if (_pageNo >= _totalPage) {
        [FrankTools showAlertWithMessage:@"没有更多数据了~" withSuperView:self.view withHeih:DeviceMaxHeight-64];
        [self.myTableView footerEndRefreshing];
        return;
    }
    _pageNo++;
    [self requestData:_pageNo];
    [self.myTableView footerEndRefreshing];
}

- (void)requestData:(NSInteger)page{
    NSDictionary *dic = @{@"device_id":[FrankTools getDeviceUUID],
                                 @"token":[FrankTools getUserToken],
                                 @"page":[NSString stringWithFormat:@"%ld",(long)page]};
    [self showHUD];
    [MainRequest RequestHTTPData:PATH(@"api/notice/getNoticeList") parameters:dic success:^(id responseData) {
        if (page == 1) {
            self.totalPage = [[responseData objectForKey:@"total_page"] integerValue];
            _dataArray = [responseData objectForKey:@"notice_list"];
        } else {
            NSArray * tempA = [responseData objectForKey:@"notice_list"];
            if (tempA && tempA.count > 0) {
                NSMutableArray * tArray = [NSMutableArray arrayWithArray:_dataArray];
                [tArray addObjectsFromArray:tempA];
                _dataArray = tArray;
            }
        }
        if (self.dataArray.count > 0) {
            NSMutableArray *array = [NSMutableArray new];
            for (NoticeListModel *model in [NoticeListModel mj_objectArrayWithKeyValuesArray:self.dataArray]) {
                [array addObject:model];
            }
            _messageModel.notice_list = array;
            [self.myTableView reloadData];
        }
        [self hideHUD];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageModel.notice_list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * tifier = @"FrankCell";
    NoticeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:tifier];
    if (cell == nil) {
        cell = [[NoticeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!self.dataArray || self.dataArray.count <=0) {
        return cell;
    }
    
    NSDictionary *dic = self.dataArray[indexPath.row];
    if ([[dic objectForKey:@"type"] integerValue] == 1) {
        [cell.logoIm setImage:imageWithName(@"home_Solar_system")];
    }else{
        [cell.logoIm setImage:imageWithName(@"home_customer_service")];
    }
    if ([[dic objectForKey:@"type"] integerValue] == 1) {
        cell.nameLab.text = @"系统消息";
    }else {
        cell.nameLab.text = @"客服消息";
    }
//    cell.nameLab.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
    NSString *contentStr = [dic objectForKey:@"title"];
    cell.detailLab.text = [NSString stringWithFormat:@"%@",contentStr?contentStr:@""];
    cell.dataLab.text = [FrankTools distanceTimeWithBeforeTime:[[dic objectForKey:@"create_time_timestamp"] doubleValue]] ;
    if ([[dic objectForKey:@"is_read"] integerValue] == 0) {
        cell.logoIm.badgeCenterOffset = CGPointMake(-4, 7);
        [cell.logoIm showBadge];
    }else{
        //已读
        [cell.logoIm clearBadge];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageDetailViewController *messageDetailVC = [[MessageDetailViewController alloc] init];
    messageDetailVC.hidesBottomBarWhenPushed = YES;
    messageDetailVC.delegate = self;
    messageDetailVC.model = self.messageModel.notice_list[indexPath.row];
    [self.navigationController pushViewController:messageDetailVC animated:YES];
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
