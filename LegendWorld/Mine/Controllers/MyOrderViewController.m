//
//  MyOrderViewController.m
//  LegendWorld
//
//  Created by 文荣 on 16/9/19.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "MyOrderViewController.h"
#import "OrderDetailViewController.h"
#import "PayMethodViewController.h"
#import "EvaluationNewViewController.h"
#import "OrderSearchViewController.h"
#import "DealSuccessViewController.h"

#import "SwitchView.h"
#import "MyOrderCollectionViewCell.h"
#import "MyOrderTableViewCell.h"



@interface MyOrderViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, SwitchViewDelegate, refreshOrderDetailPro,RefreshingViewDelegate, OrderDetailViewControllerDelegate, MyOrderTableViewCellDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) SwitchView *switchView;

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) NSArray *orders;

@property (nonatomic, strong) NSMutableArray *firstAppearIndex;//分页页码数
@property (nonatomic, strong) NSMutableArray *pages;//分页页码数
@property (nonatomic, strong) NSMutableArray *maxPages;//最大页码数

@end

@implementation MyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的订单";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    __weak typeof (self) weakSelf = self;
    self.backBarBtnEvent = ^{
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        UITabBarController *root = (UITabBarController *)app.window.rootViewController;
        if ([root.viewControllers containsObject:weakSelf.navigationController]) {
            if ([weakSelf.navigationController.viewControllers indexOfObject:weakSelf] == 1) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } else {
                NSInteger goToIndex = ModelIndexMine;
                root.selectedIndex = goToIndex;
                UINavigationController *nav = (UINavigationController *)[root.viewControllers objectAtIndex:goToIndex];
                [nav popToRootViewControllerAnimated:YES];
            }
        } else {
            NSInteger goToIndex = ModelIndexMine;
            root.selectedIndex = goToIndex;
            UINavigationController *nav = (UINavigationController *)[root.viewControllers objectAtIndex:goToIndex];
            [nav popToRootViewControllerAnimated:YES];
            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    };
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SearchWhite"]
                                                                    style:UIBarButtonItemStylePlain target:self
                                                                   action:@selector(searchBtnClick)];
    self.navigationItem.rightBarButtonItem = rightBarBtn;

    self.pageIndex = MIN(self.pageIndex, 4);
    
    self.pages = [NSMutableArray arrayWithArray:@[@1,@1,@1,@1,@1]];
    self.maxPages = [NSMutableArray arrayWithArray:@[@1,@1,@1,@1,@1]];
    self.firstAppearIndex = [NSMutableArray arrayWithArray:@[@(NO),@(NO),@(NO),@(NO),@(NO)]];
    [self.firstAppearIndex replaceObjectAtIndex:self.pageIndex withObject:@(YES)];
    
    self.titleArray = @[@"全部",@"待付款",@"待收货",@"待评价",@"售后"];
    SwitchView *switchView = [[SwitchView alloc] initWithTitles:self.titleArray
                                                  selectedColor:[UIColor themeColor]
                                            unselecteTitleColor:[UIColor bodyTextColor]];
    self.switchView = switchView;
    self.switchView.delegate = self;
    [self.view addSubview:self.switchView];
    
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);
    [self.collectionView registerNib:[UINib nibWithNibName:@"MyOrderCollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:@"MyOrderCollectionViewCell"];

    NSMutableArray *temp = [NSMutableArray array];
    for (NSInteger i = 0; i < self.titleArray.count; i++) {
        [temp addObject:[NSArray array]];
    }
    self.orders = [temp copy];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self refreshDataWithHUD];
    NSDictionary *param = @{@"device_id": [FrankTools getDeviceUUID], @"token": [FrankTools getUserToken]};
    [MainRequest RequestHTTPData:PATHShop(@"Api/Order/getStatusNum") parameters:param success:^(id response) {
        NSInteger order_zero = [[response objectForKey:@"order_zero"] integerValue];
        NSInteger order_two = [[response objectForKey:@"order_two"] integerValue];
        NSInteger order_three = [[response objectForKey:@"order_three"] integerValue];
        NSInteger order_four = [[response objectForKey:@"order_four"] integerValue];
        
        [self.switchView setBadgeValue:order_zero atIndex:1];
        [self.switchView setBadgeValue:order_two atIndex:2];
        [self.switchView setBadgeValue:order_three atIndex:3];
        [self.switchView setBadgeValue:order_four atIndex:4];
        [self updateUI];
    } failed:^(NSDictionary *errorDic) {
        [self updateUI];
    }];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.switchView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 40);
}

#pragma mark - Event
- (void)updateUI {
    [self.collectionView reloadData];
    [self.collectionView setContentOffset:CGPointMake(self.pageIndex * CGRectGetWidth(self.collectionView.bounds), self.collectionView.contentOffset.y)];
    [self.switchView setCurrentIndex:self.pageIndex];
}

- (void)searchBtnClick {
    OrderSearchViewController *orderSearchVC = [[OrderSearchViewController alloc] init];
    [self.navigationController pushViewController:orderSearchVC animated:YES];
}

- (NSInteger)getTypeByPageIndex:(NSInteger)index {
    NSInteger type = -1;
    switch (self.pageIndex) {
        case 0:
            type = -1;
            break;
        case 1:
            type = 0;
            break;
        case 2:
            type = 2;
            break;
        case 3:
            type = 3;
            break;
        case 4:
            type = 4;
            break;
        default:
            break;
    }
    return type;
}

- (void)refreshDataWithHUD {
    [self showHUDWithMessage:nil];
    NSInteger type = [self getTypeByPageIndex:self.pageIndex];
    NSDictionary *param = @{@"device_id":[FrankTools getDeviceUUID], @"token":[FrankTools getUserToken], @"status_type":@(type), @"page":@(1)};
    [MainRequest RequestHTTPData:PATHShop(@"Api/Order/getOrderList") parameters:param success:^(id response) {
        [self.pages replaceObjectAtIndex:self.pageIndex withObject:@1];
        [self.maxPages replaceObjectAtIndex:self.pageIndex withObject:@([[response objectForKey:@"total_page"] integerValue])];
        NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self.orders];
        NSArray *curOrders = [OrderModel parseOrderListResponse:response];
        [tempArr replaceObjectAtIndex:self.pageIndex withObject:curOrders];
        self.orders = [tempArr copy];
        [self updateUI];
        [self hideHUD];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

- (void)refreshControlDidRefresh:(RefreshControl *)refreshControl {
    NSInteger type = [self getTypeByPageIndex:self.pageIndex];
    NSDictionary *param = @{@"device_id":[FrankTools getDeviceUUID], @"token":[FrankTools getUserToken], @"status_type":@(type), @"page":@(1)};
    [MainRequest RequestHTTPData:PATHShop(@"Api/Order/getOrderList") parameters:param success:^(id response) {
        [self.pages replaceObjectAtIndex:self.pageIndex withObject:@1];
        [self.maxPages replaceObjectAtIndex:self.pageIndex withObject:@([[response objectForKey:@"total_page"] integerValue])];
        NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self.orders];
        NSArray *curOrders = [OrderModel parseOrderListResponse:response];
        [tempArr replaceObjectAtIndex:self.pageIndex withObject:curOrders];
        self.orders = [tempArr copy];
        [self updateUI];
        [refreshControl endRefreshing:YES];
    } failed:^(NSDictionary *errorDic) {
        [refreshControl endRefreshing:NO];
    }];
}

- (void)loadControlDidLoad:(LoadControl *)load {
    NSInteger type = [self getTypeByPageIndex:self.pageIndex];
    NSInteger nextPage = [[self.pages objectAtIndex:self.pageIndex] integerValue] + 1;
    
    NSDictionary *param = @{@"device_id":[FrankTools getDeviceUUID], @"token":[FrankTools getUserToken], @"status_type":@(type), @"page":@(nextPage)};
    [MainRequest RequestHTTPData:PATHShop(@"Api/Order/getOrderList") parameters:param success:^(id response) {
        [self.pages replaceObjectAtIndex:self.pageIndex withObject:@(nextPage)];
        [self.maxPages replaceObjectAtIndex:self.pageIndex withObject:@([[response objectForKey:@"total_page"] integerValue])];
        NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self.orders];
        NSMutableArray *subTempArr = [NSMutableArray arrayWithArray:[self.orders objectAtIndex:self.pageIndex]];
        NSArray *curOrders = [OrderModel parseOrderListResponse:response];
        [subTempArr addObjectsFromArray:curOrders];
        [tempArr replaceObjectAtIndex:self.pageIndex withObject:subTempArr];
        self.orders = [tempArr copy];
        [self updateUI];
        [load endLoading:YES];
    } failed:^(NSDictionary *errorDic) {
        [load endLoading:NO];
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

- (NSString *)getActionBtnTitleByOrder:(OrderModel *)order {
    NSInteger orderStatus = [order.order_status integerValue];
    NSString *desc = @"查看详情";
    if (order.is_after > 0 && (self.switchView.currentLabelIndex == 0 || self.switchView.currentLabelIndex == 4)) {
        return desc;
    }
    //'0未付款,1已付款,2已发货,3已收货,4已评价,5已退货,6已取消,7无效,8充值失败',
    if (orderStatus == 0) {
        desc = @"付款";
    } else if (orderStatus == 1 || orderStatus == 2) {
        desc = @"确认收货";
    } else if (orderStatus == 3) {
        desc = @"去评价";
    }
    return desc;
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyOrderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyOrderCollectionViewCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.orderTableView.dataSource = self;
    cell.orderTableView.delegate = self;
    cell.orderTableView.rowHeight = 140;
    cell.orderTableView.sectionHeaderHeight = 0;
    cell.orderTableView.sectionFooterHeight = 10;
    cell.orderTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 10)];
    cell.orderTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
    cell.orderTableView.backgroundColor = [UIColor clearColor];
    cell.orderTableView.separatorColor = [UIColor seperateColor];
    cell.orderTableView.tag = indexPath.row;
    [cell.orderTableView registerNib:[UINib nibWithNibName:@"MyOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyOrderTableViewCell"];
    [cell.refreshControl addTarget:self action:@selector(refreshControlDidRefresh:) forControlEvents:UIControlEventValueChanged];
    [cell.loadControl addTarget:self action:@selector(loadControlDidLoad:) forControlEvents:UIControlEventValueChanged];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    MyOrderCollectionViewCell *mycell = (MyOrderCollectionViewCell *)cell;
    NSArray *orders = [self.orders objectAtIndex:indexPath.row];
    __weak typeof (self) weakSelf = self;
    mycell.loadControl.displayCondition = ^{
        NSArray *arr = [weakSelf.orders objectAtIndex:indexPath.row];
        BOOL isDisplay = arr.count > 0;
        return isDisplay;
    };
    mycell.loadControl.loadAllCondition = ^{
        NSInteger curPage = [[weakSelf.pages objectAtIndex:indexPath.row] integerValue];
        NSInteger maxPage = [[weakSelf.maxPages objectAtIndex:indexPath.row] integerValue];
        BOOL isLoadAll = curPage >= maxPage;
        return isLoadAll;
    };
    mycell.emptyImg.hidden = orders.count > 0;
    mycell.emptyLabel.hidden = orders.count > 0;
    [mycell.orderTableView reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 40);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.collectionView == scrollView && (self.collectionView.isDragging || self.collectionView.isDecelerating)) {
        if (scrollView.contentSize.width != 0) {
            CGFloat percent = scrollView.contentOffset.x / scrollView.contentSize.width;
            [self.switchView scrollViewDidScrollPercent:percent];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.collectionView == scrollView) {
        NSInteger pageIndex = ceil(scrollView.contentOffset.x/CGRectGetWidth(scrollView.bounds));
        pageIndex = MAX(0, pageIndex);
        pageIndex = MIN(pageIndex, self.titleArray.count - 1);
        if (self.pageIndex == pageIndex) {
            return;
        }
        self.pageIndex = pageIndex;
        [self.switchView setCurrentIndex:self.pageIndex];
        NSArray *arr = [self.orders objectAtIndex:self.pageIndex];
        BOOL isFirstAppear = [[self.firstAppearIndex objectAtIndex:self.pageIndex] boolValue];
        if (arr.count <= 0 && !isFirstAppear) {
            [self.firstAppearIndex replaceObjectAtIndex:self.pageIndex withObject:@(YES)];
            [self refreshDataWithHUD];
        }
    }
}

#pragma mark - UITableViewDelegate, UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSArray *orders = [self.orders objectAtIndex:tableView.tag];
    return orders.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *orders = [self.orders objectAtIndex:tableView.tag];
    OrderModel *order = [orders objectAtIndex:indexPath.section];
    GoodsModel *goods = [order.order_goods firstObject];
    MyOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyOrderTableViewCell"];
    [cell.goodsImg sd_setImageWithURL:[NSURL URLWithString:goods.goods_thumb] placeholderImage:placeHolderImg];
    cell.goodsNameLabel.text = goods.goods_name;
    cell.goodsCountLabel.text = [NSString stringWithFormat:@"X%ld",(long)goods.goods_number];
    cell.orderPriceLabel.text = [NSString stringWithFormat:@"¥%@",order.order_money];
    cell.orderstatusLabel.text = [NSString stringWithFormat:@"状态：%@", [self getOrderStatusDescByOrder:order]];
    [cell.seeDetailBtn setTitle:[self getActionBtnTitleByOrder:order] forState:UIControlStateNormal];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *orders = [self.orders objectAtIndex:tableView.tag];
    OrderModel *order = [orders objectAtIndex:indexPath.section];
    OrderDetailViewController *orderDetail = [[OrderDetailViewController alloc] init];
    orderDetail.orderId = [order.order_id integerValue];
    orderDetail.delegate = self;
    [self.navigationController pushViewController:orderDetail animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - SwitchViewDelegate
- (void)swithView:(SwitchView *)switchView didSelectItemAtIndex:(NSInteger)index {
    self.pageIndex = index;
    [UIView animateWithDuration:0.25 animations:^{
        [self.collectionView setContentOffset:CGPointMake(self.pageIndex * CGRectGetWidth(self.collectionView.bounds), self.collectionView.contentOffset.y)];
    } completion:^(BOOL finished) {
        NSArray *arr = [self.orders objectAtIndex:self.pageIndex];
        BOOL isFirstAppear = [[self.firstAppearIndex objectAtIndex:self.pageIndex] boolValue];
        if (arr.count <= 0 && !isFirstAppear) {
            [self.firstAppearIndex replaceObjectAtIndex:self.pageIndex withObject:@(YES)];
            [self refreshDataWithHUD];
        }
    }];
}

#pragma mark - MyOrderTableViewCellDelegate
- (void)myOrderCell:(MyOrderTableViewCell *)cell didClickedActionBtn:(UIButton *)sender {
    MyOrderCollectionViewCell *cCell = [[self.collectionView visibleCells] firstObject];
    NSIndexPath *indexPath = [cCell.orderTableView indexPathForCell:cell];
    NSArray *orders = [self.orders objectAtIndex:cCell.orderTableView.tag];
    OrderModel *order = [orders objectAtIndex:indexPath.section];
    if ([sender.currentTitle isEqualToString:@"付款"]) {
        PayMethodViewController *payMethod = [[PayMethodViewController alloc] init];
        payMethod.orderNum = order.order_number;
        payMethod.order_id = order.order_id;
        payMethod.orderMoney = order.order_money;
        payMethod.orderPayType = OrderPayTypeNormal;
        [self.navigationController pushViewController:payMethod animated:YES];
    } else if ([sender.currentTitle isEqualToString:@"确认收货"]) {
        if ([order.order_status integerValue] == 1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"当前订单未发货，无法确认收货"
                                                           delegate:nil
                                                  cancelButtonTitle:@"知道了"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        
        if (order.is_after == 1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"该订单中包含有退款记录的商品，确认收货将关闭退款。"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确认收货", nil];
            alert.tag = indexPath.section;
            [alert show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"您要确认收货吗？"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确认收货", nil];
            alert.tag = indexPath.section;
            [alert show];
        }
    } else if ([sender.currentTitle isEqualToString:@"去评价"]) {
        EvaluationNewViewController *evaluation = [[EvaluationNewViewController alloc] init];
        evaluation.order_id = order.order_id;
        evaluation.seller_id = order.seller_info.seller_id;
        evaluation.modelDataArr = [order.order_goods copy];
        [self.navigationController pushViewController:evaluation animated:YES];
    } else if ([sender.currentTitle isEqualToString:@"查看详情"]) {
        OrderDetailViewController *orderDetail = [[OrderDetailViewController alloc] init];
        orderDetail.orderId = [order.order_id integerValue];
        orderDetail.delegate = self;
        [self.navigationController pushViewController:orderDetail animated:YES];
    }
}

#pragma mark - RefreshingViewDelegate
- (void)refreshingUI {
    
}

#pragma mark - refreshOrderDetailPro
- (void)refreshOrderDetailAct {
    
}

#pragma mark - OrderDetailViewControllerDelegate
- (void)refreshParentVC {
    MyOrderCollectionViewCell *cell = (MyOrderCollectionViewCell *)[[self.collectionView visibleCells] firstObject];
    [cell.refreshControl beginRefreshing];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"确认收货"]) {
        MyOrderCollectionViewCell *cCell = [[self.collectionView visibleCells] firstObject];
        NSArray *orders = [self.orders objectAtIndex:cCell.orderTableView.tag];
        OrderModel *order = [orders objectAtIndex:alertView.tag];
        
        [self showHUDWithMessage:nil];
        NSDictionary *param = @{@"device_id": [FrankTools getDeviceUUID], @"token": [FrankTools getUserToken], @"order_id": [NSString stringWithFormat:@"%@",order.order_id], @"deal_type":@2};
        [MainRequest RequestHTTPData:PATHShop(@"api/Order/dealOrder") parameters:param success:^(id response) {
            [self showHUDWithResult:YES message:@"已确认收货" completion:^{
                DealSuccessViewController *dealSuccess = [[DealSuccessViewController alloc] init];
                dealSuccess.order = order;
                [self.navigationController pushViewController:dealSuccess animated:YES];
            }];
        } failed:^(NSDictionary *errorDic) {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }];
    }
}

@end
