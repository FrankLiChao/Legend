//
//  MyCollectionViewController.m
//  LegendWorld
//
//  Created by wenrong on 16/11/3.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "MyCollectionGoodsCell.h"
#import "MyCollectionSellerCell.h"
#import "GoodsModel.h"
#import "SellerModel.h"
#import "SwitchView.h"
#import "MJRefresh.h"
#import "MyCollectionNoGoods.h"
#import "AppDelegate.h"
#import "ProductDetailViewController.h"
#import "SellerShopViewController.h"

@interface MyCollectionViewController ()<UITableViewDelegate,UITableViewDataSource,SwitchViewDelegate,MyCollectionGoodsCellDelegate,MyCollectionNoGoodsDelegate>
@property (weak, nonatomic) IBOutlet UITableView *goodsTableView;
@property (weak, nonatomic) IBOutlet UITableView *sellerTableView;
@property (nonatomic, strong) NSMutableArray *goodsArrs;
@property (nonatomic, strong) NSMutableArray *sellerArrs;
@property (nonatomic, strong) MyCollectionNoGoods *myCollectionNoGoodsView;
@end

@implementation MyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    self.goodsArrs = [NSMutableArray array];
    self.sellerArrs = [NSMutableArray array];
    SwitchView *switchView = [[SwitchView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 40) andTitles:@[@"商品",@"商家"] andScrollLineColor:mainColor andUnselecteColor:[UIColor bodyTextColor]];
    switchView.delegate = self;
    [self.goodsTableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [self.sellerTableView addHeaderWithTarget:self action:@selector(sellerTableViewHeaderRefreshing)];
    [self.goodsTableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    [self.sellerTableView addFooterWithTarget:self action:@selector(sellerTableViewFooterRefreshing)];
    [self.goodsTableView headerBeginRefreshing];
    [self.view addSubview:switchView];
    // Do any additional setup after loading the view from its nib.
}

- (void)headerRefreshing{
    [self.goodsArrs removeAllObjects];
    NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],@"token":[FrankTools getUserToken],@"type":[NSNumber numberWithInteger:1],@"last_collect_id":[NSNumber numberWithInteger:0]};
    [MainRequest RequestHTTPData:PATHShop(@"Api/GoodsCollect/getCollectList") parameters:parameters success:^(id response) {
        [self.goodsTableView headerEndRefreshing];
        NSArray *dataArr = [GoodsModel parseCollectResponse:response];
        for (GoodsModel *model in [GoodsModel parseCollectResponse:response]) {
            [self.goodsArrs addObject:model];
        }
        if (dataArr.count == 0) {
            if (!self.myCollectionNoGoodsView) {
                self.myCollectionNoGoodsView = [[[NSBundle mainBundle] loadNibNamed:@"MyCollectionNoGoods" owner:self options:nil] firstObject];
                self.myCollectionNoGoodsView.frame = CGRectMake(0, 45, DeviceMaxWidth, DeviceMaxHeight-45-64);
                self.myCollectionNoGoodsView.delegate = self;
                [self.view addSubview:self.myCollectionNoGoodsView];
            }
            [self.myCollectionNoGoodsView.defaultIm setImage:imageWithName(@"mine_defaultgoods")];
            [self.myCollectionNoGoodsView.buyBtn setTitle:@"买买买~" forState:UIControlStateNormal];
            self.myCollectionNoGoodsView.titleLab.text = @"居然一个收藏都没有，快去";
        }
        else{
            if (self.myCollectionNoGoodsView){
                [self.myCollectionNoGoodsView removeFromSuperview];
                self.myCollectionNoGoodsView = nil;
            }
        }
        [self.goodsTableView reloadData];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:@"获取信息失败"];
        [self.goodsTableView headerEndRefreshing];
    }];
    
}
- (void)sellerTableViewHeaderRefreshing{
    [self.sellerArrs removeAllObjects];
    NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],@"token":[FrankTools getUserToken],@"last_collect_id":@"0"};
    [MainRequest RequestHTTPData:PATHShop(@"Api/Shop/getShopCollectList") parameters:parameters success:^(id response) {
        NSArray *dataArr = [SellerModel parseSellerList:response];
        for (SellerModel *model in dataArr) {
            [self.sellerArrs addObject:model];
        }
        if (dataArr.count == 0) {
            if (!self.myCollectionNoGoodsView) {
                self.myCollectionNoGoodsView = [[[NSBundle mainBundle] loadNibNamed:@"MyCollectionNoGoods" owner:self options:nil] firstObject];
                self.myCollectionNoGoodsView.frame = CGRectMake(0, 45, DeviceMaxWidth, DeviceMaxHeight-45-64);
                self.myCollectionNoGoodsView.delegate = self;
                [self.view addSubview:self.myCollectionNoGoodsView];
            }
            [self.myCollectionNoGoodsView.defaultIm setImage:imageWithName(@"mine_defaultshop")];
            [self.myCollectionNoGoodsView.buyBtn setTitle:@"逛逛~" forState:UIControlStateNormal];
            self.myCollectionNoGoodsView.titleLab.text = @"当前没有收藏商家，马上去";
        }
        else{
            if (self.myCollectionNoGoodsView){
                [self.myCollectionNoGoodsView removeFromSuperview];
                self.myCollectionNoGoodsView = nil;
            }
        }
        [self.sellerTableView headerEndRefreshing];
        [self.sellerTableView reloadData];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:@"获取信息失败"];
        [self.sellerTableView headerEndRefreshing];
    }];
    
}
- (void)footerRefreshing{
    GoodsModel *model = [self.goodsArrs lastObject];
    NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],@"token":[FrankTools getUserToken],@"type":[NSNumber numberWithInteger:1],@"last_collect_id":[NSNumber numberWithInteger:[model.collect_id integerValue]]};
    [MainRequest RequestHTTPData:PATHShop(@"Api/GoodsCollect/getCollectList") parameters:parameters success:^(id response) {
        for (GoodsModel *model in [GoodsModel parseCollectResponse:response]) {
            [self.goodsArrs addObject:model];
        }
        [self.goodsTableView footerEndRefreshing];
        [self.goodsTableView reloadData];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:@"获取信息失败"];
        [self.goodsTableView footerEndRefreshing];
        FLLog(@"errorDic ====== %@",errorDic);
    }];
}

- (void)sellerTableViewFooterRefreshing{
    SellerModel *model = [self.sellerArrs lastObject];
    NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],@"token":[FrankTools getUserToken],@"last_collect_id":model.collect_id};
    [MainRequest RequestHTTPData:PATHShop(@"Api/Shop/getShopCollectList") parameters:parameters success:^(id response) {
        for (SellerModel *model in [SellerModel parseSellerList:response]) {
            [self.sellerArrs addObject:model];
        }
        [self.sellerTableView footerEndRefreshing];
        [self.sellerTableView reloadData];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:@"获取信息失败"];
        [self.sellerTableView footerEndRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.goodsTableView) {
        return self.goodsArrs.count;
    }
    return self.sellerArrs.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.goodsTableView) {
        return 106;
    }
    return 86;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.goodsTableView) {
        MyCollectionGoodsCell *myCollectionGoodsCell = [tableView dequeueReusableCellWithIdentifier:@"MyCollectionGoodsCellKey"];
        if (!myCollectionGoodsCell) {
            myCollectionGoodsCell = [[[NSBundle mainBundle] loadNibNamed:@"MyCollectionGoodsCell" owner:self options:nil] firstObject];
        }
        if (self.goodsArrs.count != 0) {
            GoodsModel *model = self.goodsArrs[indexPath.row];
            [FrankTools setImgWithImgView:myCollectionGoodsCell.goodsImg withImageUrl:model.goods_thumb withPlaceHolderImage:placeHolderImg];
            myCollectionGoodsCell.goodsNameLab.text = model.goods_name;
            myCollectionGoodsCell.goodsPriceLab.text = [NSString stringWithFormat:@"¥%@",model.shop_price];
            myCollectionGoodsCell.tag = indexPath.row;
            if ([model.recommend_reward isEqualToString:@"0.00"]) {
                myCollectionGoodsCell.awardBtn.hidden = YES;
            }
            myCollectionGoodsCell.delegate = self;
        }
        return myCollectionGoodsCell;
    }
    MyCollectionSellerCell *myCollectionSellerCell = [tableView dequeueReusableCellWithIdentifier:@"MyCollectionSellerCellKey"];
    if (!myCollectionSellerCell) {
        myCollectionSellerCell = [[[NSBundle mainBundle] loadNibNamed:@"MyCollectionSellerCell" owner:self options:nil] firstObject];
    }
    if (self.sellerArrs.count != 0) {
        SellerModel *model = self.sellerArrs[indexPath.row];
        [FrankTools setImgWithImgView:myCollectionSellerCell.sellerImg withImageUrl:model.thumb_img withPlaceHolderImage:placeHolderImg];
        myCollectionSellerCell.sellerNameLab.text = model.seller_name;
        myCollectionSellerCell.sellerCollectionLab.text = [NSString stringWithFormat:@"%ld人收藏",(long)model.collect_count];
    }
    return myCollectionSellerCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.goodsTableView){
        ProductDetailViewController *productDetailVC = [[ProductDetailViewController alloc] init];
        productDetailVC.hidesBottomBarWhenPushed = YES;
        GoodsModel *model = self.goodsArrs[indexPath.row];
        productDetailVC.goods_id = model.goods_id;
        productDetailVC.is_endorse = [model.is_endorse integerValue];
        [self.navigationController pushViewController:productDetailVC animated:YES];
    }
    else{
        SellerShopViewController *sellerShopVC = [[SellerShopViewController alloc] init];
        sellerShopVC.hidesBottomBarWhenPushed = YES;
        SellerModel *model = self.sellerArrs[indexPath.row];
        sellerShopVC.sellerId = model.seller_id;
        [self.navigationController pushViewController:sellerShopVC animated:YES];
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof (self) weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"删除" message:@"确认删除？删除后信息将无法找回" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (tableView == weakSelf.goodsTableView) {
            GoodsModel *model = weakSelf.goodsArrs[indexPath.row];
            NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],@"token":[FrankTools getUserToken],@"goods_id":model.goods_id};
            [MainRequest RequestHTTPData:PATHShop(@"Api/GoodsCollect/cancelCollect") parameters:parameters success:^(id response) {
                [weakSelf showHUDWithResult:YES message:@"删除成功"];
                [weakSelf.goodsTableView headerBeginRefreshing];
            } failed:^(NSDictionary *errorDic) {
                [weakSelf showHUDWithResult:NO message:@"删除商品失败"];
            }];
        } else {
            SellerModel *model = weakSelf.sellerArrs[indexPath.row];
            NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],@"token":[FrankTools getUserToken],@"seller_id":[NSString stringWithFormat:@"%ld",(long)model.seller_id]};
            [MainRequest RequestHTTPData:PATHShop(@"Api/Shop/cancelShopCollect") parameters:parameters success:^(id response) {
                [weakSelf showHUDWithResult:YES message:@"删除成功"];
                [weakSelf.sellerTableView headerBeginRefreshing];
            } failed:^(NSDictionary *errorDic) {
                [weakSelf showHUDWithResult:NO message:@"删除店铺失败"];
            }];
        }
    }]];
     [self presentViewController:alertController animated:YES completion:nil];
    
}
- (void)swithView:(SwitchView *)switchView didSelectItemAtIndex:(NSInteger)index {
    if (index == 0) {
        self.goodsTableView.hidden = NO;
        self.sellerTableView.hidden = YES;
        [self.goodsTableView headerBeginRefreshing];
    }
    if (index == 1) {
        self.sellerTableView.hidden = NO;
        self.goodsTableView.hidden = YES;
        [self.sellerTableView headerBeginRefreshing];
    }
}
- (void)getAward:(NSInteger)num
{
    GoodsModel *model = self.goodsArrs[num];
    [FrankTools fxViewAppear:model.goods_thumb conStr:model.shop_price withUrlStr:model.goods_id withTitilStr:model.goods_name withVc:self isAdShare:nil];
}
- (void)turnToBuy
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    self.tabBarController.tabBar.hidden = NO;
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UITabBarController *root = (UITabBarController *)app.window.rootViewController;
    NSInteger goToIndex = ModelIndexHome;
    UINavigationController *nav = [root.viewControllers objectAtIndex:goToIndex];
    [nav popToRootViewControllerAnimated:NO];
    root.selectedIndex = goToIndex;
}
@end
