//
//  OrderSearchViewController.m
//  LegendWorld
//
//  Created by wenrong on 16/11/9.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "OrderSearchViewController.h"
#import "OrderSearchCell.h"
#import "OrderModel.h"
#import "MyMemberTitleView.h"
#import "LoadControl.h"
#import "OrderDetailViewController.h"

@interface OrderSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *goodsSearchTableView;
@property (nonatomic, strong) NSMutableArray *orderListArr;
@property (nonatomic, strong) NSMutableArray *goodsListArr;
@property (nonatomic) NSInteger pageIndex;
@property (nonatomic) NSInteger maxPageIndex;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIView *resultZeroView;
@end

@implementation OrderSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageIndex = 1;
    self.orderListArr = [NSMutableArray array];
    self.goodsListArr = [NSMutableArray array];
    
    self.title = @"搜索订单";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(clickSystemButton)];
    rightItem.enabled = NO;
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 30)];
    self.searchBar = searchBar;
    self.searchBar.delegate = self;
    self.searchBar.backgroundImage = [UIImage new];
    self.searchBar.tintColor = [UIColor themeColor];
    self.searchBar.textColor = [UIColor bodyTextColor];
    self.searchBar.placeholder = @"请输入商品名称";
    self.navigationItem.titleView = self.searchBar;
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.resultZeroView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, DeviceMaxWidth, DeviceMaxHeight - 104)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(DeviceMaxWidth/2 - 44, 68, 88, 88)];
    imageView.image = [UIImage imageNamed:@"noOrder"];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(DeviceMaxWidth/2 - 75, 200, 150, 21)];
    label.text = @"未搜索相关订单哦~";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor noteTextColor];
    label.font = [UIFont systemFontOfSize:16];
    
    [self.resultZeroView addSubview:label];
    [self.resultZeroView addSubview:imageView];
    [self.view addSubview:self.resultZeroView];
    
    self.resultZeroView.hidden = YES;
    
    self.goodsSearchTableView.rowHeight = 96;
    [self.goodsSearchTableView registerNib:[UINib nibWithNibName:@"OrderSearchCell" bundle:nil] forCellReuseIdentifier:@"OrderSearchCell"];

    __weak typeof (self) weakSelf = self;
    LoadControl *loadControl = [[LoadControl alloc] initWithScrollView:self.goodsSearchTableView];
    loadControl.color = [UIColor noteTextColor];
    loadControl.displayCondition = ^{
        BOOL isDisplay = weakSelf.orderListArr.count > 0;
        return isDisplay;
    };
    loadControl.loadAllCondition = ^{
        BOOL isLoadAll = weakSelf.pageIndex >= weakSelf.maxPageIndex;
        return isLoadAll;
    };
    [loadControl addTarget:self action:@selector(loadMoreData:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - Custom
- (void)clickSystemButton {
    [self netRequset];
}

- (void)netRequset {
    [self.searchBar endEditing:YES];
    [self showHUDWithMessage:@"搜索中"];
    [self.orderListArr removeAllObjects];
    [self.goodsListArr removeAllObjects];
    NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],@"token":[FrankTools getUserToken],@"status_type":[NSNumber numberWithInteger:-1],@"keyword":self.searchBar.text,@"page":[NSNumber numberWithInteger:self.pageIndex]};
    [MainRequest RequestHTTPData:PATHShop(@"Api/Order/getOrderList") parameters:parameters success:^(id response) {
        for (OrderModel *model in [OrderModel parseResponse:response]) {
            [self.orderListArr addObject:model];
            [self.goodsListArr addObject:[ProductModel mj_objectArrayWithKeyValuesArray:model.goods_list]];
        }
        self.resultZeroView.hidden = self.goodsListArr.count != 0;
        self.maxPageIndex = [[response objectForKey:@"total_page"] integerValue];
        [self showHUDWithResult:YES message:@"查询成功"];
        [self.goodsSearchTableView reloadData];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

- (void)loadMoreData:(LoadControl *)loadControl {
    self.pageIndex ++;
    NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],@"token":[FrankTools getUserToken],@"status_type":[NSNumber numberWithInteger:-1],@"keyword":self.searchBar.text,@"page":[NSNumber numberWithInteger:self.pageIndex]};
    [MainRequest RequestHTTPData:PATHShop(@"Api/Order/getOrderList") parameters:parameters success:^(id response) {
        for (OrderModel *model in [OrderModel parseResponse:response]) {
            [self.orderListArr addObject:model];
            [self.goodsListArr addObject:[ProductModel mj_objectArrayWithKeyValuesArray:model.goods_list]];
        }
        [loadControl endLoading:YES];
        self.maxPageIndex = [[response objectForKey:@"total_page"] integerValue];
        [self.goodsSearchTableView reloadData];
    } failed:^(NSDictionary *errorDic) {
        [loadControl endLoading:NO];
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

- (NSString *)getOrderStatusDescByOrder:(OrderModel *)order {
    if (order.is_after == 1) {
        return @"申请退款中";
    } else if (order.is_after == 2) {
        return @"退款已完成";
    } else if (order.is_after == 3) {
        return @"退款关闭";
    }
    NSInteger orderStatus = [order.order_status integerValue];
    NSString *desc = nil;
    //'0未付款,1已付款,2已发货,3已收货,4已评价,5已退货,6已取消,7无效,8充值失败',
    switch (orderStatus) {
        case 0:{
            desc = @"待付款";
            break;
        }
        case 1:{
            desc = @"待收货";
            break;
        }
        case 2:{
            desc = @"待收货";
            break;
        }
        case 3:{
            desc = @"待评价";
            break;
        }
        case 4:{
            desc = @"已完成";
            break;
        }
        case 5:{
            desc = @"退款已完成";
            break;
        }
        case 6:{
            desc = @"已取消";
            break;
        }
        case 7:{
            desc = @"已取消";
            break;
        }
        case 8:{
            desc = @"充值失败";
            break;
        }
        default:
            break;
    }
    return desc;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orderListArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.orderListArr.count > 0 ? 45 : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MyMemberTitleView *myMemberTitleV = [[[NSBundle mainBundle] loadNibNamed:@"MyMemberTitleView" owner:self options:nil] firstObject];
    myMemberTitleV.titleLab.text = @"相关订单";
    myMemberTitleV.memberLeftLab.hidden = YES;
    return myMemberTitleV;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderSearchCell *orderSearchCell = [tableView dequeueReusableCellWithIdentifier:@"OrderSearchCell"];
    OrderModel *orderModel = self.orderListArr[indexPath.row];
    ProductModel *goodsModel = self.goodsListArr[indexPath.row][0];
    orderSearchCell.timeLab.text = orderModel.create_time;
    orderSearchCell.goodsPriceLab.text = [NSString stringWithFormat:@"¥%@",orderModel.order_money];
    orderSearchCell.goodsNameLab.text = goodsModel.title;
    [FrankTools setImgWithImgView:orderSearchCell.goodsImg withImageUrl:goodsModel.img withPlaceHolderImage:placeHolderImg];
    orderSearchCell.statusLab.text = [self getOrderStatusDescByOrder:orderModel];
    return orderSearchCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrderDetailViewController *orderDetailVC = [[OrderDetailViewController alloc] init];
    orderDetailVC.hidesBottomBarWhenPushed = YES;
    OrderModel *orderModel = self.orderListArr[indexPath.row];
    orderDetailVC.orderId = [orderModel.order_id integerValue];
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self netRequset];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.navigationItem.rightBarButtonItem.enabled = self.searchBar.text.length > 0;
}

@end
