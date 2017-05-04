//
//  AdvertViewController.m
//  LegendWorld
//
//  Created by 文荣 on 16/9/22.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "AdvertViewController.h"
#import "AdvertModel.h"
#import "AdvertTableViewCell.h"
#import "MyAdListTableViewCell.h"
#import "ShareAdverViewController.h"
#import "QuestionAdverViewController.h"
#import "DownAdverViewController.h"
#import "EndorseAdverController.h"
#import "OrderAdverViewController.h"
#import "SelectAdverViewController.h"
#import "MJRefresh.h"
#import "GPClassifyPageView.h"

typedef NS_ENUM(NSInteger, AdDetailType) {
    RegisterAd = 1, // 注册
    AnswerAd,   // 回答
    SelecteAd,  // 选择
    ShareAd,    // 分享
    DownloadAd, // 下载
    CmdAd,      // 口令
    EndorsementAd   // 代言
};

@interface AdvertViewController ()<GPClassifyPageDelegate, UITableViewDelegate, UITableViewDataSource,RefreshingViewDelegate>

@property (weak, nonatomic) IBOutlet GPClassifyPageView *customView;
@property (nonatomic, strong)NSMutableArray *tableViews;
@property (nonatomic, strong)NSMutableArray *adListDatasource;
@property (nonatomic, strong)NSMutableArray *myAdListDatasource;
@property (nonatomic, strong)NSMutableArray *saveAdListDatasource;
@property (nonatomic, assign)NSInteger type;
@property (nonatomic, assign)NSInteger index;

@end

@implementation AdvertViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"抢广告";
    self.automaticallyAdjustsScrollViewInsets = NO;
    for (NSInteger i = 0; i < 3; i++) {
        UITableView *myTableView = [[UITableView alloc]initWithFrame:CGRectMake(DeviceMaxWidth*i, 0, DeviceMaxWidth, 504)];
        myTableView.backgroundColor = [UIColor whiteColor];
        if (i == 1) {
            [myTableView registerNib:[UINib nibWithNibName:@"MyAdListTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyAdListTableViewCell"];
            
        }else {
            [myTableView registerNib:[UINib nibWithNibName:@"AdvertTableViewCell" bundle:nil] forCellReuseIdentifier:@"AdvertTableViewCell"];
        }
        myTableView.delegate = self;
        myTableView.dataSource = self;
        [myTableView addHeaderWithTarget:self action:@selector(headerRefresh)];
        [myTableView addFooterWithTarget:self action:@selector(footerRefresh)];
        myTableView.tableFooterView = [UIView new];
        //知识点 当滑动时，让快速停止下来
        myTableView.decelerationRate = UIScrollViewDecelerationRateFast;
        // AdvertTableViewCell
        myTableView.tag = 100 + i;
        myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableViews addObject:myTableView];
    }
    self.customView.pagesView = self.tableViews;
    self.customView.pagesName = @[@"未读",@"已读",@"收藏"];
    self.customView.curPage = 0;
    self.customView.delegate = self;
    [self.customView setupView];
    self.index = 1;
}

#pragma mark - Refresh
- (void)headerRefresh {
    FLLog(@"刷新Header");
    self.index = 1;
    [self refreshUIWithPage];
}
- (void)footerRefresh{
     FLLog(@"刷新Footer");
    self.index++;
    [self refreshUIWithPage];
    
}

#pragma mark - 登录刷新
-(void)refreshingUI{
    [self refreshUIWithPage];
}

#pragma mark - UITableViewDatasource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 100) {
        return self.adListDatasource.count;
    } else if(tableView.tag == 101) {
        return self.myAdListDatasource.count;
    }
    return self.saveAdListDatasource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 100) {
       return 90 + 200*widthRate;
    } else if(tableView.tag == 101) {
       return 65 + 200*widthRate;
    }
    return 90 + 200*widthRate;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 100) {
        AdvertModel *temp = self.adListDatasource[indexPath.row];
        AdvertTableViewCell *cell = (AdvertTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"AdvertTableViewCell"];
        [cell configWithModel:temp];
        return cell;
    } else if(tableView.tag == 101) {
        MyAdListTableViewCell *cell = (MyAdListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MyAdListTableViewCell"];
        [cell configWithModel:self.myAdListDatasource[indexPath.row]];
        return cell;
    }
    AdvertTableViewCell *cell = (AdvertTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"AdvertTableViewCell"];
    [cell configWithModel:self.saveAdListDatasource[indexPath.row]];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AdvertModel *tempModel;
    if (tableView.tag == 100) {
        tempModel = self.adListDatasource[indexPath.row];
    } else if(tableView.tag == 101) {
        tempModel = self.myAdListDatasource[indexPath.row];
    } else {
        tempModel = self.saveAdListDatasource[indexPath.row];
    }
    AdverBaseViewController *controller;
    switch (tempModel.ad_type) {
        case RegisterAd://注册
        {
            
        }
            break;
        case AnswerAd:
        {
            controller = [[QuestionAdverViewController alloc] initWithBaseModel:tempModel];
        }
            break;
        case SelecteAd:
        {
            controller = [[SelectAdverViewController alloc] initWithBaseModel:tempModel];
        }
            break;
        case ShareAd:
        {
            controller = [[ShareAdverViewController alloc] initWithBaseModel:tempModel];
        }
            break;
        case DownloadAd:
        {
            controller = [[DownAdverViewController alloc] initWithBaseModel:tempModel];
        }
            break;
        case CmdAd:
        {
            controller = [[OrderAdverViewController alloc] initWithBaseModel:tempModel];
        }
            break;
        case EndorsementAd:
        {
            controller = [[EndorseAdverController alloc] initWithBaseModel:tempModel];
        }
            break;
        default:
            break;
    }
    controller.baseModel = tempModel;
    [self.navigationController pushViewController:controller animated:YES];

}

- (void)selectedPage:(NSInteger)page {
    self.type = page;
    self.index = 1;
    [self refreshUIWithPage];
}

- (void)refreshUIWithPage {
     __weak __typeof(self) weakSelf = self;
    if (self.type == 0) {
        [AdvertModel loadDataWithAdList:weakSelf.index success:^(NSArray *adList) {
            UITableView *tempTableView = weakSelf.tableViews[0];
            if (weakSelf.index != 1) {
                [weakSelf.adListDatasource addObjectsFromArray:adList];
                [tempTableView footerEndRefreshing];
            } else {
                [weakSelf.adListDatasource removeAllObjects];
                weakSelf.adListDatasource = [NSMutableArray arrayWithArray:adList];
                [tempTableView headerEndRefreshing];
            }
            [tempTableView reloadData];
        } failed:^(NSDictionary *errorDic) {
            if ([weakSelf isReLogin:errorDic]) {
                [weakSelf popLoginView:weakSelf];
            }else{
                [weakSelf showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
            }
        }];
    } else if (self.type == 1) {
        [MyAdvertModel loadDataWithMyAdList:weakSelf.index success:^(NSArray *myAdList) {
            UITableView *tempTableView = weakSelf.tableViews[1];
            if (weakSelf.index != 1) {
                [weakSelf.myAdListDatasource addObjectsFromArray:myAdList];
                [tempTableView footerEndRefreshing];
            } else {
                [weakSelf.myAdListDatasource removeAllObjects];
                weakSelf.myAdListDatasource = [NSMutableArray arrayWithArray:myAdList];
                [tempTableView headerEndRefreshing];
            }
            [tempTableView reloadData];
        } failed:^(NSDictionary *errorDic) {
            if ([weakSelf isReLogin:errorDic]) {
                [weakSelf popLoginView:weakSelf];
            }else{
                [weakSelf showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
            }
        }];
    } else {
        [AdvertModel loadDataWithCollectionAdList:weakSelf.index success:^(NSArray *CollectionadList) {
            UITableView *tempTableView = weakSelf.tableViews[2];
            if (weakSelf.index != 1) {
                [weakSelf.saveAdListDatasource addObjectsFromArray:CollectionadList];
                [tempTableView footerEndRefreshing];
            } else {
                [weakSelf.saveAdListDatasource removeAllObjects];
                weakSelf.saveAdListDatasource = [NSMutableArray arrayWithArray:CollectionadList];
                [tempTableView headerEndRefreshing];
            }
            [tempTableView reloadData];
        } failed:^(NSDictionary *errorDic) {
            if ([weakSelf isReLogin:errorDic]) {
                [weakSelf popLoginView:weakSelf];
            }else{
                [weakSelf showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
            }
        }];
    }
}
#pragma mark - 懒加载
- (NSMutableArray *)tableViews {
    if (!_tableViews) {
        _tableViews = [NSMutableArray new];
    }
    return _tableViews;
}
- (NSMutableArray *)adListDatasource {
    if (!_adListDatasource) {
        _adListDatasource = [NSMutableArray array];
    }
    return _adListDatasource;
}
- (NSMutableArray *)myAdListDatasource {
    if (!_myAdListDatasource) {
        _myAdListDatasource = [NSMutableArray array];
    }
    return _myAdListDatasource;

}
- (NSMutableArray *)saveAdListDatasource {
    if (!_saveAdListDatasource) {
        _saveAdListDatasource = [NSMutableArray array];
    }
    return _saveAdListDatasource;
}
@end
