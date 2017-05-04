//
//  CommodityListViewController.m
//  LegendWorld
//
//  Created by wenrong on 16/11/1.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "CommodityListViewController.h"
#import "SearchGoodsViewController.h"

#import "LoadControl.h"
#import "SwitchView.h"
#import "CommodityListTableViewCell.h"
#import "CommodityListCollectionCell.h"
#import "ProductDetailViewController.h"

@interface CommodityListViewController ()<UISearchBarDelegate,SwitchViewDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SearchGoodsResultDelegate>

@property (nonatomic, weak) UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UICollectionView *commodityCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *commodityTableView;
@property (weak, nonatomic) IBOutlet UIView *commodityNoGoodsView;

@property (nonatomic) BOOL searchViewDelegateBring;
@property (nonatomic, strong) GoodsModel *goodsModel;
@property (nonatomic, strong) NSMutableArray *goodsArr;
@property (nonatomic) NSInteger maxPageIndex;
@property (nonatomic) NSInteger pageIndex;
@property (nonatomic) NSInteger titleIndex;
@property (nonatomic) BOOL ifButtonSelected;

@end

@implementation CommodityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"商品列表";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"changeStyleTableView"] style:UIBarButtonItemStylePlain target:self action:@selector(clickSystemButton:)];
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    self.searchBar = searchBar;
    self.searchBar.placeholder = @"请输入商品名称";
    self.searchBar.text = self.goodsName;
    self.searchBar.backgroundImage = [UIImage new];
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
    
    self.commodityTableView.hidden = YES;
    self.commodityTableView.scrollsToTop = YES;
    self.commodityTableView.tableFooterView = [UIView new];
    self.commodityTableView.backgroundColor = [UIColor clearColor];
    self.commodityTableView.separatorColor = [UIColor seperateColor];
    [self.commodityTableView registerNib:[UINib nibWithNibName:@"CommodityListTableViewCell" bundle:nil]
                  forCellReuseIdentifier:@"CommodityListTableViewCell"];
    
    self.commodityCollectionView.hidden = NO;
    self.commodityCollectionView.scrollsToTop = YES;
    self.commodityCollectionView.backgroundColor = [UIColor clearColor];
    [self.commodityCollectionView registerNib:[UINib nibWithNibName:@"CommodityListCollectionCell" bundle:nil]
                   forCellWithReuseIdentifier:@"CommodityListCollectionCell"];
    

    if (self.ifFromShoppingMallView) {
        NSDictionary* parameter = @{@"device_id":[FrankTools getDeviceUUID],@"cat_id":self.categoryId};
        [self netRequest:parameter];
    } else if (self.ifFromSellerView) {
        NSDictionary *parameter = @{@"device_id":[FrankTools getDeviceUUID],@"keyword":self.goodsName,@"seller_id":self.sellerId};
        [self netRequest:parameter];
    } else if (self.ifFromSearchView) {
        NSDictionary* parameter = @{@"device_id":[FrankTools getDeviceUUID],@"keyword":self.goodsName};
        [self netRequest:parameter];
    }
    
    __weak typeof (self) weakSelf = self;
    LoadControl *loadControl = [[LoadControl alloc] initWithScrollView:self.commodityCollectionView];
    LoadControl *loadControlTableView = [[LoadControl alloc] initWithScrollView:self.commodityTableView];
    loadControl.color = [UIColor noteTextColor];
    loadControlTableView.color = [UIColor noteTextColor];
    loadControl.displayCondition = ^{
        if (!self.ifButtonSelected) {
            return NO;
        }
        BOOL isDisplay = weakSelf.goodsArr.count > 0;
        return isDisplay;
    };
    loadControlTableView.displayCondition = ^{
        if (self.ifButtonSelected) {
            return NO;
        }
        BOOL isDisplay = weakSelf.goodsArr.count > 0;
        return isDisplay;
    };
    loadControl.loadAllCondition = ^{
        BOOL isLoadAll = weakSelf.pageIndex >= weakSelf.maxPageIndex;
        return isLoadAll;
    };
    loadControlTableView.loadAllCondition = ^{
        BOOL isLoadAll = weakSelf.pageIndex >= weakSelf.maxPageIndex;
        return isLoadAll;
    };
    [loadControl addTarget:self action:@selector(loadMoreData:) forControlEvents:UIControlEventValueChanged];
    [loadControlTableView addTarget:self action:@selector(loadMoreData:) forControlEvents:UIControlEventValueChanged];
    
    self.pageIndex = 1;
    self.ifButtonSelected = YES;
    self.goodsModel = [[GoodsModel alloc] init];
    self.goodsArr = [NSMutableArray array];
    
    SwitchView *switchView = [[SwitchView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 40) andTitles:@[@"综合",@"好评",@"新品",@"价格"] andScrollLineColor:mainColor andUnselecteColor:contentTitleColorStr];
    switchView.delegate = self;
    [switchView needImageViewAtBackWithIndex:3];
    [self.view addSubview:switchView];
}

#pragma mark - Custom
- (void)loadMoreData:(LoadControl *)loadControl{
    if (self.ifFromShoppingMallView) {
        [self cat_setParameters:self.titleIndex andLoadControl:loadControl pageIndex:self.pageIndex + 1];
    } else if (self.ifFromSellerView) {
        [self seller_setParameters:self.titleIndex andLoadControl:loadControl pageIndex:self.pageIndex + 1];
    } else if (self.ifFromSearchView) {
        [self setParameters:self.titleIndex andLoadControl:loadControl pageIndex:self.pageIndex + 1];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    if (self.ifFromSearchView) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        SearchGoodsViewController *search = [[SearchGoodsViewController alloc] init];
        search.hidesBottomBarWhenPushed = YES;
        search.delegate = self;
        [self.navigationController pushViewController:search animated:YES];
    }
    return NO;
}

- (void)seller_setParameters:(NSInteger)titleIndex andLoadControl:(LoadControl *)loadControl pageIndex:(NSInteger)pageIndex {
    NSDictionary *parameter = [[NSDictionary alloc] init];
    switch (titleIndex) {
        case 0:
            if (self.pageIndex > 1) {
                parameter = @{@"device_id":[FrankTools getDeviceUUID],@"keyword":self.goodsName,@"seller_id":self.sellerId,@"page":[NSNumber numberWithInteger:pageIndex]};
                [self footerNetRequest:parameter andLoadControl:loadControl];
            }
            else{
                parameter = @{@"device_id":[FrankTools getDeviceUUID],@"keyword":self.goodsName,@"seller_id":self.sellerId,@"page":[NSNumber numberWithInteger:1]};
                [self netRequest:parameter];
            }
            break;
        case 1:
            if (self.pageIndex > 1) {
                parameter = @{@"device_id":[FrankTools getDeviceUUID],@"keyword":self.goodsName,@"comment_sort":@"desc",@"seller_id":self.sellerId,@"page":[NSNumber numberWithInteger:pageIndex]};
                [self footerNetRequest:parameter andLoadControl:loadControl];
            }
            else{
                parameter = @{@"device_id":[FrankTools getDeviceUUID],@"keyword":self.goodsName,@"comment_sort":@"desc",@"seller_id":self.sellerId,@"page":[NSNumber numberWithInteger:1]};
                [self netRequest:parameter];
            }
            break;
        case 2:
            if (self.pageIndex > 1) {
                parameter = @{@"device_id":[FrankTools getDeviceUUID],@"keyword":self.goodsName,@"is_newest":[NSNumber numberWithInteger:1],@"seller_id":self.sellerId,@"page":[NSNumber numberWithInteger:pageIndex]};
                [self footerNetRequest:parameter andLoadControl:loadControl];
            }
            else{
                parameter = @{@"device_id":[FrankTools getDeviceUUID],@"keyword":self.goodsName,@"is_newest":[NSNumber numberWithInteger:1],@"seller_id":self.sellerId,@"page":[NSNumber numberWithInteger:1]};
                [self netRequest:parameter];
            }
            break;
        case 3:
            if (self.pageIndex > 1) {
                parameter = @{@"device_id":[FrankTools getDeviceUUID],@"keyword":self.goodsName,@"price_sort":@"asc",@"seller_id":self.sellerId,@"page":[NSNumber numberWithInteger:pageIndex]};
                [self footerNetRequest:parameter andLoadControl:loadControl];
            }
            else{
                parameter = @{@"device_id":[FrankTools getDeviceUUID],@"keyword":self.goodsName,@"price_sort":@"asc",@"seller_id":self.sellerId,@"page":[NSNumber numberWithInteger:1]};
                [self netRequest:parameter];
            }
            break;
        case 4:
            if (self.pageIndex > 1) {
                parameter = @{@"device_id":[FrankTools getDeviceUUID],@"keyword":self.goodsName,@"price_sort":@"desc",@"seller_id":self.sellerId,@"page":[NSNumber numberWithInteger:pageIndex]};
                [self footerNetRequest:parameter andLoadControl:loadControl];
            }
            else{
                parameter = @{@"device_id":[FrankTools getDeviceUUID],@"keyword":self.goodsName,@"price_sort":@"desc",@"seller_id":self.sellerId,@"page":[NSNumber numberWithInteger:1]};
                [self netRequest:parameter];
            }
            break;
        default:
            break;
    }
}

- (void)cat_setParameters:(NSInteger)titleIndex andLoadControl:(LoadControl *)loadControl pageIndex:(NSInteger)pageIndex {
    NSDictionary *parameter = [[NSDictionary alloc] init];
    switch (titleIndex) {
        case 0:
            if (pageIndex > 1) {
                parameter = @{@"device_id":[FrankTools getDeviceUUID],@"cat_id":self.categoryId,@"page":[NSNumber numberWithInteger:pageIndex]};
                [self footerNetRequest:parameter andLoadControl:loadControl];
            }
            else{
                parameter = @{@"device_id":[FrankTools getDeviceUUID],@"cat_id":self.categoryId,@"page":[NSNumber numberWithInteger:1]};
                [self netRequest:parameter];
            }
            break;
        case 1:
            if (pageIndex > 1) {
                parameter = @{@"device_id":[FrankTools getDeviceUUID],@"comment_sort":@"desc",@"cat_id":self.categoryId,@"page":[NSNumber numberWithInteger:pageIndex]};
                [self footerNetRequest:parameter andLoadControl:loadControl];
            }
            else{
                parameter = @{@"device_id":[FrankTools getDeviceUUID],@"comment_sort":@"desc",@"cat_id":self.categoryId,@"page":[NSNumber numberWithInteger:1]};
                [self netRequest:parameter];
            }
            break;
        case 2:
            if (pageIndex > 1) {
                parameter = @{@"device_id":[FrankTools getDeviceUUID],@"is_newest":[NSNumber numberWithInteger:1],@"cat_id":self.categoryId,@"page":[NSNumber numberWithInteger:pageIndex]};
                [self footerNetRequest:parameter andLoadControl:loadControl];
            }
            else{
                parameter = @{@"device_id":[FrankTools getDeviceUUID],@"is_newest":[NSNumber numberWithInteger:1],@"cat_id":self.categoryId,@"page":[NSNumber numberWithInteger:1]};
                [self netRequest:parameter];
            }
            break;
        case 3:
            if (pageIndex > 1) {
                parameter = @{@"device_id":[FrankTools getDeviceUUID],@"price_sort":@"asc",@"cat_id":self.categoryId,@"page":[NSNumber numberWithInteger:pageIndex]};
                [self footerNetRequest:parameter andLoadControl:loadControl];
            }
            else{
                parameter = @{@"device_id":[FrankTools getDeviceUUID],@"price_sort":@"asc",@"cat_id":self.categoryId,@"page":[NSNumber numberWithInteger:1]};
                [self netRequest:parameter];
            }
            break;
        case 4:
            if (pageIndex > 1) {
                parameter = @{@"device_id":[FrankTools getDeviceUUID],@"price_sort":@"desc",@"cat_id":self.categoryId,@"page":[NSNumber numberWithInteger:pageIndex]};
                [self footerNetRequest:parameter andLoadControl:loadControl];
            }
            else{
                parameter = @{@"device_id":[FrankTools getDeviceUUID],@"price_sort":@"desc",@"cat_id":self.categoryId,@"page":[NSNumber numberWithInteger:1]};
                [self netRequest:parameter];
            }
            break;
        default:
            break;
    }
}

- (void)setParameters:(NSInteger)titleIndex andLoadControl:(LoadControl *)loadControl pageIndex:(NSInteger)pageIndex {
    NSDictionary *parameter = [NSDictionary dictionary];
    switch (titleIndex) {
        case 0:
            if (pageIndex > 1) {
                parameter = @{@"device_id":[FrankTools getDeviceUUID],@"keyword":self.goodsName,@"page":[NSNumber numberWithInteger:pageIndex]};
                [self footerNetRequest:parameter andLoadControl:loadControl];
            }
            else{
                parameter = @{@"device_id":[FrankTools getDeviceUUID],@"keyword":self.goodsName,@"page":[NSNumber numberWithInteger:1]};
                [self netRequest:parameter];
            }
            break;
        case 1:
            if (pageIndex > 1) {
                parameter = @{@"device_id":[FrankTools getDeviceUUID],@"keyword":self.goodsName,@"comment_sort":@"desc",@"page":[NSNumber numberWithInteger:pageIndex]};
                [self footerNetRequest:parameter andLoadControl:loadControl];
            }
            else{
                parameter = @{@"device_id":[FrankTools getDeviceUUID],@"keyword":self.goodsName,@"comment_sort":@"desc",@"page":[NSNumber numberWithInteger:1]};
                [self netRequest:parameter];
            }
            break;
        case 2:
            if (pageIndex > 1) {
                parameter = @{@"device_id":[FrankTools getDeviceUUID],@"keyword":self.goodsName,@"is_newest":[NSNumber numberWithInteger:1],@"page":[NSNumber numberWithInteger:pageIndex]};
                [self footerNetRequest:parameter andLoadControl:loadControl];
            }
            else{
                parameter = @{@"device_id":[FrankTools getDeviceUUID],@"keyword":self.goodsName,@"is_newest":[NSNumber numberWithInteger:1],@"page":[NSNumber numberWithInteger:1]};
                [self netRequest:parameter];
            }
            break;
        case 3:
            if (pageIndex > 1) {
                parameter = @{@"device_id":[FrankTools getDeviceUUID],@"keyword":self.goodsName,@"price_sort":@"asc",@"page":[NSNumber numberWithInteger:pageIndex]};
                [self footerNetRequest:parameter andLoadControl:loadControl];
            }
            else{
                parameter = @{@"device_id":[FrankTools getDeviceUUID],@"keyword":self.goodsName,@"price_sort":@"asc",@"page":[NSNumber numberWithInteger:1]};
                [self netRequest:parameter];
            }
            break;
        case 4:
            if (pageIndex > 1) {
                parameter = @{@"device_id":[FrankTools getDeviceUUID],@"keyword":self.goodsName,@"price_sort":@"desc",@"page":[NSNumber numberWithInteger:pageIndex]};
                [self footerNetRequest:parameter andLoadControl:loadControl];
            }
            else{
                parameter = @{@"device_id":[FrankTools getDeviceUUID],@"keyword":self.goodsName,@"price_sort":@"desc",@"page":[NSNumber numberWithInteger:1]};
                [self netRequest:parameter];
            }
            break;
        default:
            break;
    }
}

- (void)netRequest:(NSDictionary *)parameters {
    [self showHUDWithMessage:nil];
    [self.goodsArr removeAllObjects];
    [MainRequest RequestHTTPData:PATHShop(@"Api/Goods/searchGoods") parameters:parameters success:^(id response) {
        NSArray *arr = [GoodsModel parseResponse:response];
        self.pageIndex = 1;
        self.maxPageIndex = [[response objectForKey:@"total_page"] integerValue];
        for (GoodsModel *model in arr) {
            [self.goodsArr addObject:model];
        }
        self.commodityNoGoodsView.hidden = self.goodsArr.count > 0;
        [self.commodityTableView reloadData];
        [self.commodityCollectionView reloadData];
        [self hideHUD];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

- (void)footerNetRequest:(NSDictionary *)parameters andLoadControl:(LoadControl *)loadControl {
    [MainRequest RequestHTTPData:PATHShop(@"Api/Goods/searchGoods") parameters:parameters success:^(id response) {
        NSArray *arr = [GoodsModel parseResponse:response];
        self.pageIndex ++;
        self.maxPageIndex = [[response objectForKey:@"total_page"] integerValue];
        for (GoodsModel *model in arr) {
            [self.goodsArr addObject:model];
        }
        [self.commodityTableView reloadData];
        [self.commodityCollectionView reloadData];
        [loadControl endLoading:YES];
    } failed:^(NSDictionary *errorDic) {
        [self hideHUD];
        [loadControl endLoading:NO];
    }];
}

- (void)clickSystemButton:(UIBarButtonItem *)sender {
    if (self.ifButtonSelected) {
        [sender setImage:[UIImage imageNamed:@"changeStyle"]];
    } else {
        [sender setImage:[UIImage imageNamed:@"changeStyleTableView"]];
    }
    self.ifButtonSelected = !self.ifButtonSelected;
    self.commodityCollectionView.hidden = !self.commodityCollectionView.hidden;
    self.commodityTableView.hidden = !self.commodityTableView.hidden;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.goodsArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductDetailViewController *productDetailVC = [[ProductDetailViewController alloc] init];
    productDetailVC.hidesBottomBarWhenPushed = YES;
    GoodsModel *model = self.goodsArr[indexPath.row];
    productDetailVC.goods_id = model.goods_id;
    productDetailVC.is_endorse = [model.is_endorse integerValue];
    [self.navigationController pushViewController:productDetailVC animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommodityListTableViewCell *commodityListTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"CommodityListTableViewCell"];
    GoodsModel *model = self.goodsArr[indexPath.row];
    commodityListTableViewCell.goodsTitleLab.text = model.goods_name;
    NSString *moneyStr = [NSString stringWithFormat:@"%.2f",[model.shop_price floatValue]];
    NSString *priceStr = [NSString stringWithFormat:@"￥%@",moneyStr];
    NSMutableAttributedString * as = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [as addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, 1)];
    [as addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(priceStr.length-2, 2)];
    commodityListTableViewCell.goodsPriceLab.attributedText = as;
    commodityListTableViewCell.delegateLab.text = @"可代言商品";
    commodityListTableViewCell.delegateLab.hidden = [model.is_endorse boolValue] != YES;
    [FrankTools setImgWithImgView:commodityListTableViewCell.goodsImg withImageUrl:model.goods_thumb withPlaceHolderImage:placeHolderImg];
    return commodityListTableViewCell;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.goodsArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = {(DeviceMaxWidth-15)/2,261};
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ProductDetailViewController *productDetailVC = [[ProductDetailViewController alloc] init];
    productDetailVC.hidesBottomBarWhenPushed = YES;
    GoodsModel *model = self.goodsArr[indexPath.row];
    productDetailVC.goods_id = model.goods_id;
    productDetailVC.is_endorse = [model.is_endorse integerValue];
    [self.navigationController pushViewController:productDetailVC animated:YES];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CommodityListCollectionCell *commodityListCollectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CommodityListCollectionCell" forIndexPath:indexPath];
    GoodsModel *model = self.goodsArr[indexPath.row];
    commodityListCollectionCell.goodsTitleLab.text = model.goods_name;
    NSString *moneyStr = [NSString stringWithFormat:@"%.2f",[model.shop_price floatValue]];
    NSString *priceStr = [NSString stringWithFormat:@"￥%@",moneyStr];
    NSMutableAttributedString * as = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [as addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, 1)];
    [as addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(priceStr.length-2, 2)];
    commodityListCollectionCell.goodsPriceLab.attributedText = as;
    commodityListCollectionCell.delegateLab.text = @"可代言商品";
    commodityListCollectionCell.delegateLab.hidden = [model.is_endorse boolValue] != YES;
    commodityListCollectionCell.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    commodityListCollectionCell.layer.shadowOffset = CGSizeMake(0, 1);
    commodityListCollectionCell.layer.shadowOpacity = 0.3;
    commodityListCollectionCell.layer.shadowRadius = 1;
    commodityListCollectionCell.clipsToBounds = NO;
    [FrankTools setImgWithImgView:commodityListCollectionCell.goodsImg withImageUrl:model.goods_thumb withPlaceHolderImage:placeHolderImg];
    return commodityListCollectionCell;
}

#pragma mark - SearchGoodsViewControllerDelegate
- (void)searchGoodsViewController:(SearchGoodsViewController *)search didSearchText:(NSString *)text {
    self.searchViewDelegateBring = YES;
    self.goodsName = text;
    self.searchBar.text = self.goodsName;
    [self swithView:nil didSelectItemAtIndex:0];
}

#pragma mark - SwitchViewDelegate
- (void)swithView:(SwitchView *)switchView didSelectItemAtIndex:(NSInteger)index {
    self.titleIndex = index;
    if (self.ifFromShoppingMallView) {
        [self cat_setParameters:index andLoadControl:nil pageIndex:1];
    } else if (self.ifFromSellerView) {
        [self seller_setParameters:index andLoadControl:nil pageIndex:1];
    } else if (self.ifFromSearchView) {
        [self setParameters:index andLoadControl:nil pageIndex:1];
    }
}

@end
