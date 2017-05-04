//
//  SellerShopViewController.m
//  LegendWorld
//
//  Created by Tsz on 2016/11/1.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "SellerShopViewController.h"
#import "CommodityListViewController.h"
#import "ProductDetailViewController.h"

#import "CommodityListCollectionCell.h"
#import "SellerShopHeaderView.h"
#import "HotWordCollectionViewCell.h"
#import "RefreshControl.h"
#import "LoadControl.h"

typedef NS_ENUM(NSInteger, SellerShopType) {
    SellerShopTypeHome = 0,
    SellerShopTypeAll = 1,
    SellerShopTypeCategory = 2
};


typedef NS_ENUM(NSInteger, SellerShopSortType) {
    SellerShopSortTypeDefault = 0,
    SellerShopSortTypeComment = 1,
    SellerShopSortTypeNew = 2,
    SellerShopSortTypePriceAsc = 3,
    SellerShopSortTypePriceDsc = 4
};

@interface SellerShopViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, SwitchViewDelegate>

//UI
@property (nonatomic, weak) UISearchBar *searchBar;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) SwitchView *sortSwitchView;
@property (nonatomic, weak) UICollectionView *catCollectionView;

//Data
@property (nonatomic, strong) NSArray *goods;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic) NSInteger selectCatIndex;
@property (nonatomic, strong) SellerModel *seller;
@property (nonatomic) SellerShopType type;
@property (nonatomic) SellerShopSortType sortType;

@property (nonatomic) NSInteger maxPageIndex;
@property (nonatomic) NSInteger pageIndex;

@end

static CGSize const itemRatio = {350, 500};

@implementation SellerShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"商家店铺";
    self.pageIndex = 1;
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 30)];
    self.searchBar = searchBar;
    self.searchBar.delegate = self;
    self.searchBar.backgroundImage = [UIImage new];
    self.searchBar.tintColor = [UIColor themeColor];
    self.searchBar.textColor = [UIColor bodyTextColor];
    self.searchBar.placeholder = @"搜索店铺内商品";
    self.navigationItem.titleView = self.searchBar;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    layout.itemSize = CGSizeMake((DeviceMaxWidth - 3 * 5)/2, (DeviceMaxWidth - 3 * 5)/2 * (itemRatio.height/itemRatio.width));
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView = collectionView;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.bounces = YES;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CommodityListCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"CommodityListCollectionCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"SellerShopHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SellerShopHeaderView"];
    [self.view addSubview:self.collectionView];
        
    __weak typeof (self) weakSelf = self;
    LoadControl *loadControl = [[LoadControl alloc] initWithScrollView:self.collectionView];
    loadControl.color = [UIColor noteTextColor];
    loadControl.displayCondition = ^{
        BOOL isDisplay = weakSelf.goods.count > 0;
        return isDisplay;
    };
    loadControl.loadAllCondition= ^{
        BOOL isLoadAll = weakSelf.pageIndex >= weakSelf.maxPageIndex;
        return isLoadAll;
    };
    [loadControl addTarget:self action:@selector(loadMoreData:) forControlEvents:UIControlEventValueChanged];
    
    [self loadHomeData];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.collectionView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Event
- (void)updateUI {
    [self.collectionView reloadData];
    [self.catCollectionView reloadData];
    
    [self.catCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectCatIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
}

- (void)collectSellerShop:(id)sender {
    if ([FrankTools loginIsOrNot:self]) {
        [self showHUDWithMessage:nil];
        if (self.seller.col_flag) {
            NSDictionary *param = @{@"device_id":[FrankTools getDeviceUUID], @"seller_id":@(self.sellerId), @"token": [FrankTools getUserToken]};
            [MainRequest RequestHTTPData:PATHShop(@"Api/Shop/cancelShopCollect") parameters:param success:^(id respon) {
                self.seller.collect_count = [SellerModel parseCollectCountResponse:respon];
                self.seller.col_flag = NO;
                [self updateUI];
                [self showHUDWithResult:YES message:@"已取消收藏"];
            } failed:^(NSDictionary *errorDic) {
                [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
            }];
        } else {
            NSDictionary *param = @{@"device_id":[FrankTools getDeviceUUID], @"seller_id":@(self.sellerId), @"token": [FrankTools getUserToken]};
            [MainRequest RequestHTTPData:PATHShop(@"Api/Shop/addShopCollect") parameters:param success:^(id respon) {
                self.seller.collect_count = [SellerModel parseCollectCountResponse:respon];
                self.seller.col_flag = YES;
                [self updateUI];
                [self showHUDWithResult:YES message:@"收藏成功"];
            } failed:^(NSDictionary *errorDic) {
                [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
            }];
        }
    }
}

- (void)loadHomeData {
    [self showHUDWithMessage:nil];
    NSMutableDictionary *param1 = [@{@"device_id":[FrankTools getDeviceUUID], @"seller_id":@(self.sellerId)} mutableCopy];
    if ([FrankTools isLogin]) {
        [param1 setObject:[FrankTools getUserToken] forKey:@"token"];
    }
    [MainRequest RequestHTTPData:PATHShop(@"api/Shop/getShopInfoNew") parameters:param1 success:^(id response) {
        self.seller = [SellerModel parseResponse:response];
        NSDictionary *param2 = @{@"device_id":[FrankTools getDeviceUUID], @"seller_id":@(self.sellerId), @"is_hot":@1, @"page":@(self.pageIndex)};
        [self updateUI];
        [MainRequest RequestHTTPData:PATHShop(@"api/Shop/getShopGoodsList") parameters:param2 success:^(id respon) {
            self.goods = [GoodsModel parseResponse:respon];
            self.maxPageIndex = [[respon objectForKey:@"total_page"] integerValue];
            [self updateUI];
            [self hideHUD];
        } failed:^(NSDictionary *errorDic) {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

- (void)loadAllDataWithIndex:(NSInteger)index {
    [self showHUDWithMessage:nil];
    NSDictionary *param;
    switch (index) {
        case 0:
            param = @{@"device_id":[FrankTools getDeviceUUID], @"seller_id":@(self.sellerId), @"is_hot":@0, @"page":@(self.pageIndex), @"sales_sort":@"desc"};
            break;
        case 1:
            param = @{@"device_id":[FrankTools getDeviceUUID], @"seller_id":@(self.sellerId), @"is_hot":@0, @"page":@(self.pageIndex), @"comment_sort":@"desc"};
            break;
        case 2:
            param = @{@"device_id":[FrankTools getDeviceUUID], @"seller_id":@(self.sellerId), @"is_hot":@0, @"page":@(self.pageIndex), @"is_newest":@"1"};
            break;
        case 3:
            param = @{@"device_id":[FrankTools getDeviceUUID], @"seller_id":@(self.sellerId), @"is_hot":@0, @"page":@(self.pageIndex), @"price_sort":@"asc"};
            break;
        case 4:
            param = @{@"device_id":[FrankTools getDeviceUUID], @"seller_id":@(self.sellerId), @"is_hot":@0, @"page":@(self.pageIndex), @"price_sort":@"desc"};
            break;
        default:
            break;
    }
    
    [MainRequest RequestHTTPData:PATHShop(@"api/Shop/getShopGoodsList") parameters:param success:^(id respon) {
        self.goods = [GoodsModel parseResponse:respon];
        self.maxPageIndex = [[respon objectForKey:@"total_page"] integerValue];
        [self updateUI];
        [self hideHUD];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
   
}

- (void)loadCategoryDataWithIndex:(NSInteger)index {
    CategoryModel *model = [self.categories objectAtIndex:index];
    NSDictionary *params = @{@"device_id":[FrankTools getDeviceUUID], @"seller_id":@(self.sellerId), @"cat_id":model.cat_id, @"page":@(self.pageIndex)};
    [MainRequest RequestHTTPData:PATHShop(@"api/Shop/getShopGoodsList") parameters:params success:^(id response) {
        self.goods = [GoodsModel parseResponse:response];
        self.maxPageIndex = [[response objectForKey:@"total_page"] integerValue];
        [self updateUI];
        [self hideHUD];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

- (void)loadMoreData:(LoadControl *)loadControl {
    NSInteger nextPage = self.pageIndex + 1;
    NSMutableDictionary *param = [@{@"device_id":[FrankTools getDeviceUUID], @"seller_id":@(self.sellerId), @"page":@(nextPage)} mutableCopy];
    if (self.type == SellerShopTypeHome) {
        [param setObject:@1 forKey:@"is_hot"];
    } else if (self.type == SellerShopTypeAll) {
        NSInteger index = self.sortSwitchView.currentLabelIndex;
        switch (index) {
            case 0:
                [param setObject:@"asc" forKey:@"sales_sort"];
                break;
            case 1:
                [param setObject:@"asc" forKey:@"comment_sort"];
                break;
            case 2:
                [param setObject:@"asc" forKey:@"is_newest"];
                break;
            case 3:
                [param setObject:@"asc" forKey:@"price_sort"];
                break;
            case 4:
                [param setObject:@"desc" forKey:@"price_sort"];
                break;
            default:
                break;
        }
    } else if (self.type == SellerShopTypeCategory) {
        CategoryModel *model = [self.categories objectAtIndex:self.selectCatIndex];
        [param setObject:model.cat_id forKey:@"cat_id"];
    }
    
    [MainRequest RequestHTTPData:PATHShop(@"api/Shop/getShopGoodsList") parameters:param success:^(id respon) {
        NSArray *newGoods = [GoodsModel parseResponse:respon];
        NSMutableArray *myGoods = [self.goods mutableCopy];
        [myGoods addObjectsFromArray:newGoods];
        self.goods = [myGoods copy];
        self.pageIndex = nextPage;
        [self updateUI];
        [loadControl endLoading:YES];
    } failed:^(NSDictionary *errorDic) {
        [loadControl endLoading:NO];
    }];
}

#pragma mark - UICollectionViewDataSource &  UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.collectionView) {
        return self.goods.count;
    }
    return self.categories.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (collectionView == self.collectionView) {
        return CGSizeMake(DeviceMaxWidth, self.type == SellerShopTypeHome ? 127 + 40: 127 + 80);
    }
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.collectionView) {
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            SellerShopHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"SellerShopHeaderView" forIndexPath:indexPath];
            [header.sellerBgImageView sd_setImageWithURL:[NSURL URLWithString:self.seller.backup_img] placeholderImage:[UIImage imageNamed:@"seller_bg"]];
            [header.sellerImageView sd_setImageWithURL:[NSURL URLWithString:self.seller.thumb_img] placeholderImage:placeHolderImg];
            header.sellerNameLabel.text = self.seller.seller_name;
            header.collectionCountLabel.text = [NSString stringWithFormat:@"%li人收藏", (long)self.seller.collect_count];
            header.leftInfoLabel.text = [NSString stringWithFormat:@"分红起价：%.2f元", self.seller.dividend_price];
            header.rightInfoLabel.text = [NSString stringWithFormat:@"已完成：%.2f元", self.seller.dividend_price];
            [header.collectBtn setTitle:self.seller.col_flag ? @"已收藏" : @"收藏" forState:UIControlStateNormal];
            [header.collectBtn setImage:self.seller.col_flag ? [UIImage new] : [UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
            [header.collectBtn setImageEdgeInsets:self.seller.col_flag ? UIEdgeInsetsZero : UIEdgeInsetsMake(0, 0, 0, 2.5)];
            [header.collectBtn setTitleEdgeInsets:self.seller.col_flag ? UIEdgeInsetsZero : UIEdgeInsetsMake(0, 2.5, 0, 0)];
            [header.collectBtn addTarget:self action:@selector(collectSellerShop:) forControlEvents:UIControlEventTouchUpInside];
            header.switchView.titles = @[@"首页",@"全部",@"分类"];
            header.switchView.titleColor = [UIColor themeColor];
            header.switchView.unselecteTitleColor = [UIColor bodyTextColor];
            header.switchView.delegate = self;
            if (self.type == SellerShopTypeHome) {
                self.sortSwitchView.hidden = YES;
                self.catCollectionView.hidden = YES;
            } else if (self.type == SellerShopTypeAll) {
                if (self.sortSwitchView == nil) {
                    SwitchView *orderSwitch = [[SwitchView alloc] initWithTitles:@[@"综合",@"好评",@"新品",@"价格"] selectedColor:[UIColor themeColor] unselecteTitleColor:[UIColor bodyTextColor]];
                    self.sortSwitchView = orderSwitch;
                    self.sortSwitchView.frame = header.bottomView.bounds;
                    self.sortSwitchView.delegate = self;
                    [self.sortSwitchView needImageViewAtBackWithIndex:3];
                    [header.bottomView addSubview:self.sortSwitchView];
                }
                self.sortSwitchView.hidden = NO;
                self.catCollectionView.hidden = YES;
            } else if (self.type == SellerShopTypeCategory) {
                if (self.catCollectionView == nil) {
                    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
                    layout.minimumLineSpacing = 10;
                    layout.minimumInteritemSpacing = 10;
                    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
                    
                    UICollectionView *collection = [[UICollectionView alloc] initWithFrame:header.bottomView.bounds collectionViewLayout:layout];
                    self.catCollectionView = collection;
                    self.catCollectionView.backgroundColor = [UIColor clearColor];
                    self.catCollectionView.dataSource = self;
                    self.catCollectionView.delegate = self;
                    self.catCollectionView.bounces = YES;
                    self.catCollectionView.alwaysBounceHorizontal = YES;
                    self.catCollectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
                    [self.catCollectionView registerNib:[UINib nibWithNibName:@"HotWordCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HotWordCollectionViewCell"];
                    [header.bottomView addSubview:self.catCollectionView];
                }
                self.sortSwitchView.hidden = YES;
                self.catCollectionView.hidden = NO;
                [self.catCollectionView reloadData];
            }
            return header;
        }
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.collectionView) {
        return CGSizeMake((DeviceMaxWidth - 3 * 5)/2, (DeviceMaxWidth - 3 * 5)/2 * (itemRatio.height/itemRatio.width));
    }
    CategoryModel *category = [self.categories objectAtIndex:indexPath.row];
    CGRect bounds = [category.cat_name boundingRectWithSize:CGSizeMake(self.view.bounds.size.width - 2 * 5, 5)
                                             options:NSStringDrawingUsesFontLeading
                                          attributes:@{NSFontAttributeName: [UIFont bodyTextFont]}
                                             context:nil];
    return CGSizeMake(bounds.size.width + 2 * 5, 40);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.collectionView) {
        GoodsModel *goods = self.goods[indexPath.row];
        CommodityListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CommodityListCollectionCell" forIndexPath:indexPath];
        [cell.goodsImg sd_setImageWithURL:[NSURL URLWithString:goods.goods_thumb] placeholderImage:placeHolderImg];
        cell.goodsTitleLab.text = goods.goods_name;
        cell.goodsPriceLab.text = [NSString stringWithFormat:@"¥%@", goods.shop_price];
        cell.delegateLab.hidden = [goods.is_endorse integerValue] != 1;
        cell.delegateLab.text = @"可代言商品";
        
        cell.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        cell.layer.shadowOffset = CGSizeMake(0, 1);
        cell.layer.shadowOpacity = 0.3;
        cell.layer.shadowRadius = 1;
        cell.clipsToBounds = NO;
        return cell;
    }
    CategoryModel *category = [self.categories objectAtIndex:indexPath.row];
    HotWordCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HotWordCollectionViewCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = indexPath.row == self.selectCatIndex ? [UIColor themeColor] : [UIColor bodyTextColor];
    cell.textLabel.text = category.cat_name;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.collectionView == collectionView) {
        GoodsModel *goods = [self.goods objectAtIndex:indexPath.row];
        ProductDetailViewController *goodDetail = [[ProductDetailViewController alloc] init];
        goodDetail.goods_id = goods.goods_id;
        [self.navigationController pushViewController:goodDetail animated:YES];
    } else {
        self.pageIndex = 1;
        self.selectCatIndex = indexPath.row;
        [self loadCategoryDataWithIndex:indexPath.row];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES];
    [searchBar endEditing:YES];
    CommodityListViewController *goodsList = [[CommodityListViewController alloc] init];
    goodsList.sellerId = [NSString stringWithFormat:@"%ld",(long)self.sellerId];
    goodsList.goodsName = searchBar.text;
    goodsList.ifFromSellerView = YES;
    [self.navigationController pushViewController:goodsList animated:YES];
}

#pragma mark - SwitchViewDelegate
- (void)swithView:(SwitchView *)switchView didSelectItemAtIndex:(NSInteger)index {
    if (switchView.titles.count == 3) {
        self.type = index;
        [self updateUI];
        if (self.type == SellerShopTypeHome) {
            self.pageIndex = 1;
            [self loadHomeData];
        } else if (self.type == SellerShopTypeAll) {
            self.pageIndex = 1;
            [self loadAllDataWithIndex:SellerShopSortTypeDefault];
        } else if (self.type == SellerShopTypeCategory) {
            self.pageIndex = 1;
            [self showHUDWithMessage:nil];
            NSDictionary *param = @{@"device_id":[FrankTools getDeviceUUID], @"seller_id":@(self.sellerId)};
            [MainRequest RequestHTTPData:PATHShop(@"api/Shop/getShopCategoryList") parameters:param success:^(id respon) {
                self.categories = [CategoryModel parseResponse:respon];
                if (self.categories.count > 0) {
                    CategoryModel *first = [self.categories firstObject];
                    NSDictionary *params = @{@"device_id":[FrankTools getDeviceUUID], @"seller_id":@(self.sellerId), @"cat_id":first.cat_id, @"page":@(self.pageIndex)};
                    [MainRequest RequestHTTPData:PATHShop(@"api/Shop/getShopGoodsList") parameters:params success:^(id response) {
                        self.goods = [GoodsModel parseResponse:response];
                        self.maxPageIndex = [[response objectForKey:@"total_page"] integerValue];
                        [self updateUI];
                        [self hideHUD];
                    } failed:^(NSDictionary *errorDic) {
                        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
                    }];
                } else {
                    [self hideHUD];
                }
            } failed:^(NSDictionary *errorDic) {
                [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
            }];
        }
    } else {
        self.pageIndex = 1;
        [self loadAllDataWithIndex:switchView.currentLabelIndex];
    }
}

@end
