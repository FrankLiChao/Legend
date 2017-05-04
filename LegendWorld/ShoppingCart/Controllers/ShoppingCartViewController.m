//
//  ShoppingCartViewController.m
//  LegendWorld
//
//  Created by Tsz on 2016/10/31.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "OrderConfirmViewController.h"
#import "SellerShopViewController.h"
#import "ProductDetailViewController.h"

#import "ShoppingCartTableViewCell.h"
#import "ShoppingCartHeaderView.h"
#import "ShoppingCartFooterView.h"
#import "ShoppingCartBottomView.h"
#import "SelectGoodsAttrView.h"
#import "RefreshControl.h"

@interface ShoppingCartViewController () <UITableViewDelegate, UITableViewDataSource, ShoppingCartTableViewCellDelegate, SelectGoodsAttrViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (weak, nonatomic) IBOutlet UIButton *goToHomeBtn;
@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) ShoppingCartBottomView *bottomView;

//Data
@property (nonatomic) BOOL isEditMode;
@property (nonatomic, strong) NSArray *shoppingCartItems;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, strong) NSMutableSet *selectedIndexPaths;
@property (nonatomic, strong) NSMutableSet *selectedSections;
@property (nonatomic, strong) NSMutableSet *changedIndexPaths;

@end

@implementation ShoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"购物车";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editBtnClicked:)];
    
    [self.goToHomeBtn setBackgroundImage:[UIImage backgroundImageWithColor:[UIColor themeColor] cornerRadius:4] forState:UIControlStateNormal];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView = tableView;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 105;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 49 + 50, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 49 + 50, 0);
    [self.tableView registerClass:[ShoppingCartHeaderView class] forHeaderFooterViewReuseIdentifier:@"ShoppingCartHeaderView"];
    [self.tableView registerClass:[ShoppingCartFooterView class] forHeaderFooterViewReuseIdentifier:@"ShoppingCartFooterView"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ShoppingCartTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShoppingCartTableViewCell"];
    [self.view addSubview:self.tableView];
    
    RefreshControl *refresh = [[RefreshControl alloc] initWithScrollView:self.tableView];
    refresh.color = [UIColor noteTextColor];
    [refresh addTarget:self action:@selector(refreshControlDidRefresh:) forControlEvents:UIControlEventValueChanged];
    
    ShoppingCartBottomView *bottomView = (ShoppingCartBottomView *)[[[NSBundle mainBundle] loadNibNamed:@"ShoppingCartBottomView" owner:self options:nil] firstObject];
    self.bottomView = bottomView;
    [self.bottomView.selectAllBtn addTarget:self action:@selector(selectAllBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView.calculateBtn addTarget:self action:@selector(calculateBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.bottomView];
    
    self.selectedSections = [NSMutableSet set];
    self.selectedIndexPaths = [NSMutableSet set];
    self.changedIndexPaths = [NSMutableSet set];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.isEditMode = NO;
    [self.selectedSections removeAllObjects];
    [self.selectedIndexPaths removeAllObjects];
    [self updateUI];
    [self refreshData];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
    self.bottomView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - 49 - 50, CGRectGetWidth(self.view.bounds), 50);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Event
- (void)updateUI {
    self.emptyView.hidden = self.shoppingCartItems.count > 0;
    self.tableView.hidden = self.shoppingCartItems.count <= 0;
    self.bottomView.hidden = self.shoppingCartItems.count <= 0;
    
    [self.navigationItem.rightBarButtonItem setTitle:self.isEditMode ? @"完成" : @"编辑"];
    
    [self.tableView reloadData];
    [self calculateTotalPrice];
    
    NSInteger sections = [self.tableView numberOfSections];
    [self.bottomView.selectAllBtn setSelected:self.selectedSections.count == sections];
    self.bottomView.calculateBtn.enabled = self.selectedIndexPaths.count > 0;
    self.bottomView.totalTitleLabel.hidden = self.isEditMode;
    self.bottomView.totalPriceLabel.hidden = self.isEditMode;
    
    //Price
    NSString *calcText = self.selectedIndexPaths.count == 0 ? @"结算" : [NSString stringWithFormat:@"结算(%ld)",(long)self.selectedIndexPaths.count];
    NSString *delText = self.selectedIndexPaths.count == 0 ? @"删除" : [NSString stringWithFormat:@"删除(%ld)",(long)self.selectedIndexPaths.count];
    [self.bottomView.calculateBtn setTitle:self.isEditMode ? delText : calcText forState:UIControlStateNormal];
}

- (void)refreshControlDidRefresh:(RefreshControl *)refreshControl {
    NSDictionary *param = @{@"device_id": [FrankTools getDeviceUUID], @"token": [FrankTools getUserToken]};
    [MainRequest RequestHTTPData:PATHShop(@"api/ShoppingCart/getCartList") parameters:param success:^(id response) {
        self.shoppingCartItems = [ShoppingCartItemModel parseResponse:response];
        [self updateUI];
        [refreshControl endRefreshing:YES];
    } failed:^(NSDictionary *errorDic) {
        [refreshControl endRefreshing:NO];
    }];
}

- (void)refreshData {
    [self showHUDWithMessage:nil];
    NSDictionary *param = @{@"device_id": [FrankTools getDeviceUUID], @"token": [FrankTools getUserToken]};
    [MainRequest RequestHTTPData:PATHShop(@"api/ShoppingCart/getCartList") parameters:param success:^(id response) {
        self.shoppingCartItems = [ShoppingCartItemModel parseResponse:response];
        [self updateUI];
        [self hideHUD];
    } failed:^(NSDictionary *errorDic) {
         [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

- (IBAction)goToHome:(id)sender {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UITabBarController *root = (UITabBarController *)app.window.rootViewController;
    NSInteger goToIndex = ModelIndexHome;
    UINavigationController *nav = [root.viewControllers objectAtIndex:goToIndex];
    [nav popToRootViewControllerAnimated:NO];
    root.selectedIndex = goToIndex;
}

- (void)editBtnClicked:(UIBarButtonItem *)sender {
    if (self.isEditMode && self.changedIndexPaths.count > 0) {
        //点击完成
        [self showHUDWithMessage:nil];
        NSMutableArray *tempArr = [NSMutableArray array];
        for (NSIndexPath *indexPath in self.changedIndexPaths) {
            ShoppingCartItemModel *item = [self.shoppingCartItems objectAtIndex:indexPath.section];
            GoodsModel *goods = [item.goods_list objectAtIndex:indexPath.row];
            NSDictionary *subParam = @{@"cart_id":@(goods.cart_id), @"goods_id": goods.goods_id, @"goods_number": @(goods.goods_number), @"attr_id": @(goods.attr_id)};
            [tempArr addObject:subParam];
        }
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:[tempArr copy] options:NSJSONWritingPrettyPrinted error:nil];
        NSString *resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *param = @{@"device_id": [FrankTools getDeviceUUID], @"token": [FrankTools getUserToken], @"cart_list":resultString};
        
        [MainRequest RequestHTTPData:PATHShop(@"api/ShoppingCart/editShoppingCart") parameters:param success:^(id response) {
            NSDictionary *paramm = @{@"device_id": [FrankTools getDeviceUUID], @"token": [FrankTools getUserToken]};
            [MainRequest RequestHTTPData:PATHShop(@"api/ShoppingCart/getCartList") parameters:paramm success:^(id respon) {
                [self.changedIndexPaths removeAllObjects];
                self.shoppingCartItems = [ShoppingCartItemModel parseResponse:respon];
                [self updateUI];
                [self showHUDWithResult:YES message:@"修改成功"];
            } failed:^(NSDictionary *errorDic) {
                [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
            }];
        } failed:^(NSDictionary *errorDic) {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }];
    }
    self.isEditMode = !self.isEditMode;
    [self.selectedSections removeAllObjects];
    [self.selectedIndexPaths removeAllObjects];
    [self updateUI];
}

- (void)calculateTotalPrice {
    NSDecimalNumber *total = [NSDecimalNumber zero];
    for (NSIndexPath *indexPath in self.selectedIndexPaths) {
        ShoppingCartItemModel *item = [self.shoppingCartItems objectAtIndex:indexPath.section];
        GoodsModel *goods = [item.goods_list objectAtIndex:indexPath.row];
        NSDecimalNumber *price = [NSDecimalNumber decimalNumberWithString:goods.price];
        NSDecimalNumber *count = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%li",(long)goods.goods_number]];
        NSDecimalNumber *subTotal = [price decimalNumberByMultiplyingBy:count];
        total = [total decimalNumberByAdding:subTotal];
    }
    self.bottomView.totalPriceLabel.text = [NSString stringWithFormat:@"¥%@",[total stringValue]];
}

- (void)sellerCheckBtnClicked:(UIButton *)sender {
    NSInteger section = sender.tag;

    NSInteger rows = [self.tableView numberOfRowsInSection:section];
    NSInteger numberOfGoodsCanBeSelected = 0;
    for (NSInteger i = 0; i < rows; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:section];
        ShoppingCartItemModel *item = [self.shoppingCartItems objectAtIndex:indexPath.section];
        GoodsModel *goods = [item.goods_list objectAtIndex:indexPath.row];
        if (sender.isSelected) {
            if ([self.selectedIndexPaths containsObject:indexPath]) {
                [self.selectedIndexPaths removeObject:indexPath];
            }
        } else {
            if ((!goods.is_display || goods.goods_number > goods.stock) && !self.isEditMode ) {
                continue;
            }
            
            if (![self.selectedIndexPaths containsObject:indexPath]) {
                numberOfGoodsCanBeSelected ++;
                [self.selectedIndexPaths addObject:indexPath];
            }
        }
    }
    if ([self.selectedSections containsObject:@(section)]) {
        [self.selectedSections removeObject:@(section)];
    } else {
        if (numberOfGoodsCanBeSelected > 0) {
            [self.selectedSections addObject:@(section)];
        }
    }
    
    [self updateUI];
}

- (void)tapHeader:(UITapGestureRecognizer *)sender {
    if (!self.isEditMode) {
        NSInteger section = sender.view.tag;
        ShoppingCartItemModel *item = [self.shoppingCartItems objectAtIndex:section];
        SellerShopViewController *sellerShop = [[SellerShopViewController alloc] init];
        sellerShop.sellerId = item.seller.seller_id;
        sellerShop.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:sellerShop animated:YES];
    }
}

- (void)makeUpOrder:(UIButton *)sender {
    NSInteger section = sender.tag;
    ShoppingCartItemModel *item = [self.shoppingCartItems objectAtIndex:section];
    SellerShopViewController *sellerShop = [[SellerShopViewController alloc] init];
    sellerShop.sellerId = item.seller.seller_id;
    sellerShop.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sellerShop animated:YES];
}

- (void)selectAllBtnClicked:(UIButton *)sender {
    if (sender.isSelected) {
        [self.selectedIndexPaths removeAllObjects];
        [self.selectedSections removeAllObjects];
    } else {
        NSInteger section = [self.tableView numberOfSections];
        for (NSInteger s = 0; s < section; s ++) {
            NSInteger row = [self.tableView numberOfRowsInSection:s];
            NSInteger numberOfGoodsCanBeSelecte = 0;
            for (NSInteger r = 0; r < row; r++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:r inSection:s];
                ShoppingCartItemModel *item = [self.shoppingCartItems objectAtIndex:indexPath.section];
                GoodsModel *goods = [item.goods_list objectAtIndex:indexPath.row];
                if ((!goods.is_display || goods.goods_number > goods.stock) && !self.isEditMode) {
                    continue;
                }
                numberOfGoodsCanBeSelecte ++;
                [self.selectedIndexPaths addObject:indexPath];
            }
            if (numberOfGoodsCanBeSelecte > 0) {
                [self.selectedSections addObject:@(s)];
            }
        }
    }
    [self updateUI];
}

- (void)calculateBtnClicked:(id)sender {
    if (self.isEditMode) {
        NSString *message = [NSString stringWithFormat:@"确定要删除这%ld件商品吗？",(long)self.selectedIndexPaths.count];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认删除", nil];
        alert.tag = (long)self.selectedIndexPaths.count;
        [alert show];
    } else {
        [self showHUDWithMessage:nil];
        NSMutableArray *tempArr = [NSMutableArray array];
        for (NSIndexPath *indexPath in self.selectedIndexPaths) {
            ShoppingCartItemModel *item = [self.shoppingCartItems objectAtIndex:indexPath.section];
            GoodsModel *goods = [item.goods_list objectAtIndex:indexPath.row];
            NSDictionary *pDic = @{@"goods_id": goods.goods_id, @"seller_id": @(item.seller.seller_id), @"goods_number": @(goods.goods_number), @"attr_id": @(goods.attr_id)};
            [tempArr addObject:pDic];
        }
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:[tempArr copy] options:NSJSONWritingPrettyPrinted | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:nil];
        NSString *resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *param = @{@"device_id": [FrankTools getDeviceUUID], @"token": [FrankTools getUserToken], @"goods_list":resultString};
        [MainRequest RequestHTTPData:PATHShop(@"api/ShoppingCart/sureOrderCart") parameters:param success:^(id response) {
            NSArray *orderItems = [OrderItemModel parseResponse:response];
            RecieveAddressModel *address = nil;
            if ([[response objectForKey:@"address_flag"] boolValue]) {
                address = [RecieveAddressModel parseResponse:response];
            }
            BOOL addressFlag = [[response objectForKey:@"address_flag"] boolValue];
            NSString *orderPrice = [NSString stringWithFormat:@"%@",[response objectForKey:@"order_money"]];
            [self hideHUD];
            OrderConfirmViewController *orderConfirm = [[OrderConfirmViewController alloc] init];
            orderConfirm.orderItems = [orderItems copy];
            orderConfirm.address = address;
            orderConfirm.orderPrice = orderPrice;
            orderConfirm.addressFlag = addressFlag;
            orderConfirm.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:orderConfirm animated:YES];
        } failed:^(NSDictionary *errorDic) {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }];
    }
}

- (void)updateGoodsCountWithIndexPath:(NSIndexPath *)indexPath isPlus:(BOOL)isPlus {
    ShoppingCartItemModel *item = [self.shoppingCartItems objectAtIndex:indexPath.section];
    GoodsModel *goods = [item.goods_list objectAtIndex:indexPath.row];
    NSInteger maxCount = MIN(99, goods.stock);
    if ((goods.goods_number <= 1 && !isPlus) || (goods.goods_number >= maxCount && isPlus)) {
        return;
    }
    NSInteger count = isPlus ? goods.goods_number + 1 : goods.goods_number - 1;
    goods.goods_number = count;
    [self.changedIndexPaths addObject:indexPath];
    [self updateUI];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.shoppingCartItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 37;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    ShoppingCartItemModel *item = [self.shoppingCartItems objectAtIndex:section];
    if (item.seller.price_distance <= 0) {
        return 10;
    }
    return 40 + 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ShoppingCartItemModel *item = [self.shoppingCartItems objectAtIndex:section];
    ShoppingCartHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ShoppingCartHeaderView"];
    headerView.contentView.backgroundColor = [UIColor sectionColor];
    headerView.sellerNameLabel.text = item.seller.seller_name;
    headerView.checkBtn.tag = section;
    [headerView.checkBtn setSelected:[self.selectedSections containsObject:@(section)]];
    [headerView.checkBtn addTarget:self action:@selector(sellerCheckBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tapHeader = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeader:)];
    headerView.tag = section;
    [headerView addGestureRecognizer:tapHeader];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    ShoppingCartItemModel *item = [self.shoppingCartItems objectAtIndex:section];
    if (item.seller.price_distance <= 0) {
        return [[UIView alloc] init];
    }
    ShoppingCartFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ShoppingCartFooterView"];
    footerView.contentView.backgroundColor = [UIColor whiteColor];
    footerView.endorseInfoLabel.text = [NSString stringWithFormat:@"再买%.2f元完成代言",item.seller.price_distance];
    footerView.makeUpBtn.tag = section;
    [footerView.makeUpBtn addTarget:self action:@selector(makeUpOrder:) forControlEvents:UIControlEventTouchUpInside];
    return footerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ShoppingCartItemModel *item = self.shoppingCartItems[section];
    return item.goods_list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShoppingCartItemModel *item = [self.shoppingCartItems objectAtIndex:indexPath.section];
    GoodsModel *goods = [item.goods_list objectAtIndex:indexPath.row];
    ShoppingCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShoppingCartTableViewCell"];
    cell.isEditMode = self.isEditMode;
    cell.delegate = self;
    [cell.checkBtn setSelected:[self.selectedIndexPaths containsObject:indexPath]];
    [cell.goodsImgView sd_setImageWithURL:[NSURL URLWithString:goods.goods_thumb] placeholderImage:placeHolderImg];
    cell.goodsNameLabel.text = goods.goods_name;
    cell.goodsAttrLabel.text = goods.attr_name;
    cell.goodsPriceLabel.text = [NSString stringWithFormat:@"¥%@",goods.price];
    cell.goodsCountLabel.text = [NSString stringWithFormat:@"X%li",(long)goods.goods_number];
    cell.goodsCountTextField.text = [NSString stringWithFormat:@"%li",(long)goods.goods_number];
    [cell.goodsAttrBtn setTitle:goods.attr_name forState:UIControlStateNormal];
    if (goods.is_display) {
        if (goods.goods_number > goods.stock) {
            cell.stockInfoLabel.hidden = NO;
            cell.stockInfoLabel.text = @"库存不足";
        } else {
            cell.stockInfoLabel.hidden = YES;
            //可以展示可代言商品
            cell.endorseLabel.hidden = ![goods.is_endorse boolValue];
        }
    } else {
        cell.stockInfoLabel.hidden = NO;
        cell.stockInfoLabel.text = @"已下架";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.isEditMode) {
        ShoppingCartItemModel *item = [self.shoppingCartItems objectAtIndex:indexPath.section];
        GoodsModel *goods = [item.goods_list objectAtIndex:indexPath.row];
        ProductDetailViewController *detail = [[ProductDetailViewController alloc] init];
        detail.goods_id = goods.goods_id;
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - ShoppingCartTableViewCellDelegate
- (void)shoppingCartCellDidClickedCheckBtn:(ShoppingCartTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ShoppingCartItemModel *item = [self.shoppingCartItems objectAtIndex:indexPath.section];
    GoodsModel *goods = [item.goods_list objectAtIndex:indexPath.row];
    if ((!goods.is_display || goods.goods_number > goods.stock) && !self.isEditMode) {
        return;
    }
    
    BOOL isSelected = [self.selectedIndexPaths containsObject:indexPath];
    if (isSelected) {
        [self.selectedIndexPaths removeObject:indexPath];
    } else {
        [self.selectedIndexPaths addObject:indexPath];
    }
    isSelected = !isSelected;
    NSInteger rows = [self.tableView numberOfRowsInSection:indexPath.section];
    BOOL otherSelected = isSelected;
    if (isSelected) {
        for (NSInteger i = 0; i < rows; i++) {
            if (indexPath.row != i) {
                NSIndexPath *thisIndex = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
                ShoppingCartItemModel *curitem = [self.shoppingCartItems objectAtIndex:thisIndex.section];
                GoodsModel *curgoods = [curitem.goods_list objectAtIndex:thisIndex.row];
                if (![self.selectedIndexPaths containsObject:thisIndex]) {
                    if ((!curgoods.is_display || curgoods.goods_number > curgoods.stock) && !self.isEditMode) {
                        continue;
                    }
                    otherSelected = NO;
                    break;
                }
            }
        }
        if (otherSelected) {
            [self.selectedSections addObject:@(indexPath.section)];
        }
    } else {
        [self.selectedSections removeObject:@(indexPath.section)];
    }
    [self updateUI];
}

- (void)shoppingCartCellDidClickedMinusBtn:(ShoppingCartTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self updateGoodsCountWithIndexPath:indexPath isPlus:NO];
}

- (void)shoppingCartCellDidClickedPlusBtn:(ShoppingCartTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self updateGoodsCountWithIndexPath:indexPath isPlus:YES];
}

- (void)shoppingCartCellDidClickedAttributesBtn:(ShoppingCartTableViewCell *)cell {
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    ShoppingCartItemModel *item = [self.shoppingCartItems objectAtIndex:index.section];
    GoodsModel *goods = [item.goods_list objectAtIndex:index.row];
    NSMutableArray *tempArr = [NSMutableArray array];
    NSInteger selectedIndex = 0;
    for (GoodsAttrModel *attr in goods.attributes) {
        NSString *text = [NSString stringWithFormat:@"%@",attr.attr_name];
        [tempArr addObject:text];
        if (attr.attr_id == goods.attr_id) {
            selectedIndex = [goods.attributes indexOfObject:attr];
        }
    }
    self.currentIndexPath = index;
    
    SelectGoodsAttrView *view = [[SelectGoodsAttrView alloc] init];
    [view.goodsImgView sd_setImageWithURL:[NSURL URLWithString:goods.goods_thumb] placeholderImage:placeHolderImg];
    view.goodsNameLabel.text = goods.goods_name;
    view.goodsPriceLabel.text = [NSString stringWithFormat:@"¥%@",goods.price];
    view.goodsCountTextField.text = [NSString stringWithFormat:@"%ld",(long)goods.goods_number];
    view.delegate = self;
    view.fetchDataBlock = ^ {
        return [tempArr copy];
    };
    view.selectedAttrIndex = selectedIndex;
    [view show];
}

#pragma mark - SelectGoodsAttrViewDelegate
- (void)selectGoodsAttrView:(SelectGoodsAttrView *)view didSelectAttrAtIndex:(NSInteger)index {
    ShoppingCartItemModel *item = [self.shoppingCartItems objectAtIndex:self.currentIndexPath.section];
    GoodsModel *goods = [item.goods_list objectAtIndex:self.currentIndexPath.row];
    GoodsAttrModel *attr = [goods.attributes objectAtIndex:index];
    view.goodsPriceLabel.text = [NSString stringWithFormat:@"¥%@",attr.price];
    [self.changedIndexPaths addObject:self.currentIndexPath];
}

- (void)selectGoodsAttrViewDidClickOKBtn:(SelectGoodsAttrView *)view {
    NSInteger count = [view.goodsCountTextField.text integerValue];
    NSIndexPath *selectedIndexPath = [view.goodsAttrCollectionView.indexPathsForSelectedItems firstObject];
    
    ShoppingCartItemModel *item = [self.shoppingCartItems objectAtIndex:self.currentIndexPath.section];
    GoodsModel *goods = [item.goods_list objectAtIndex:self.currentIndexPath.row];
    GoodsAttrModel *attr = [goods.attributes objectAtIndex:selectedIndexPath.row];
    
    goods.goods_number = count;
    goods.attr_id = attr.attr_id;
    goods.attr_name = attr.attr_name;
    goods.price = attr.price;
    
    [view dismiss];
    [self updateUI];
}

- (void)selectGoodsAttrViewDidClickMinusBtn:(SelectGoodsAttrView *)view {
    NSInteger count = [view.goodsCountTextField.text integerValue];
    if (count <= 1) {
        return;
    }
    count = count - 1;
    view.goodsCountTextField.text = [NSString stringWithFormat:@"%ld",(long)count];
    [self.changedIndexPaths addObject:self.currentIndexPath];
}

- (void)selectGoodsAttrViewDidClickPlusBtn:(SelectGoodsAttrView *)view {
    NSInteger count = [view.goodsCountTextField.text integerValue];
    ShoppingCartItemModel *item = [self.shoppingCartItems objectAtIndex:self.currentIndexPath.section];
    GoodsModel *goods = [item.goods_list objectAtIndex:self.currentIndexPath.row];
    NSInteger maxCount = MIN(99, goods.stock);
    if (count >= maxCount) {
        return;
    }
    count = count + 1;
    view.goodsCountTextField.text = [NSString stringWithFormat:@"%ld",(long)count];
    [self.changedIndexPaths addObject:self.currentIndexPath];
}

- (void)selectGoodsAttrViewDidClickCloseBtn:(SelectGoodsAttrView *)view {
    if ([self.changedIndexPaths containsObject:self.currentIndexPath]) {
        [self.changedIndexPaths removeObject:self.currentIndexPath];
    }
    self.currentIndexPath = nil;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"确认删除"]) {
        [self showHUDWithMessage:nil];
        NSMutableString *cartIds = [NSMutableString string];
        for (NSIndexPath *indexPath in self.selectedIndexPaths) {
            ShoppingCartItemModel *item = [self.shoppingCartItems objectAtIndex:indexPath.section];
            GoodsModel *goods = [item.goods_list objectAtIndex:indexPath.row];
            [cartIds appendString:[NSString stringWithFormat:@"%ld,",(long)goods.cart_id]];
        }
        [cartIds replaceCharactersInRange:NSMakeRange(cartIds.length - 1, 1) withString:@""];
        NSDictionary *param = @{@"device_id": [FrankTools getDeviceUUID], @"token": [FrankTools getUserToken], @"cart_id":[cartIds copy]};
        [MainRequest RequestHTTPData:PATHShop(@"api/ShoppingCart/deleteShoppingCart") parameters:param success:^(id response) {
            [self.selectedIndexPaths removeAllObjects];
            [self.selectedSections removeAllObjects];
            
            NSDictionary *paramm = @{@"device_id": [FrankTools getDeviceUUID], @"token": [FrankTools getUserToken]};
            [MainRequest RequestHTTPData:PATHShop(@"api/ShoppingCart/getCartList") parameters:paramm success:^(id respon) {
                self.shoppingCartItems = [ShoppingCartItemModel parseResponse:respon];
                [self updateUI];
                [self showHUDWithResult:YES message:@"删除成功"];
            } failed:^(NSDictionary *errorDic) {
                [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
            }];
        } failed:^(NSDictionary *errorDic) {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }];
    }
}

@end
