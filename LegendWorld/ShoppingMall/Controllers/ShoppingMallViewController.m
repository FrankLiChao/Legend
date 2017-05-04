//
//  ShoppingMallViewController.m
//  LegendWorld
//
//  Created by wenrong on 16/10/28.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "ShoppingMallViewController.h"
#import "ShoppingMallTitleCell.h"
#import "ShoppingMallContentCell.h"
#import "ShoppingMallHeaderView.h"
#import "SearchGoodsViewController.h"
#import "CommodityListViewController.h"
#import "WZLBadgeImport.h"
#import "NoticeViewController.h"
@interface ShoppingMallViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *shoppingMallTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *shoppingMallCollectionView;
@property (nonatomic, strong)NSMutableArray *titleArr;
@property (nonatomic, strong)NSMutableArray *idArr;
@property (nonatomic, strong)NSMutableArray *contentArr;
@property (nonatomic, strong)CategoryModel *shoppingMallModel;
@property (nonatomic) NSInteger indexTitle;
@end

@implementation ShoppingMallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"商城";
    self.automaticallyAdjustsScrollViewInsets = NO;
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.placeholder = @"请输入商品名称";
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"systemnotice"] style:UIBarButtonItemStylePlain target:self action:@selector(clickSystemButton)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self getNoticeNumber];
    
    self.titleArr = [NSMutableArray array];
    self.idArr = [NSMutableArray array];
    self.contentArr = [NSMutableArray array];
    
    [self.shoppingMallCollectionView registerNib:[UINib nibWithNibName:@"ShoppingMallContentCell" bundle:nil] forCellWithReuseIdentifier:@"ShoppingMallContentCellKey"];
    [self.shoppingMallCollectionView registerNib:[UINib nibWithNibName:@"ShoppingMallHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ShoppingMallHeaderViewKey"];
    self.shoppingMallCollectionView.backgroundColor = [UIColor whiteColor];
    self.shoppingMallModel = [[CategoryModel alloc] init];
    
    [self showHUDWithMessage:nil];
    [CategoryModel loadDataWithOrderDetail:0 success:^(NSMutableArray *shoppingMallArrs) {
        [self.titleArr addObject:@"推荐"];
        [self.idArr addObject:@"0"];
        for (CategoryModel *model in shoppingMallArrs[0]) {
            [self.titleArr addObject:model.cat_name];
            [self.idArr addObject:model.cat_id];
        }
        for (CategoryModel *model in shoppingMallArrs[1]) {
            [self.contentArr addObject:model];
        }
        [self.shoppingMallCollectionView reloadData];
        [self.shoppingMallTableView reloadData];
        [self.shoppingMallTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        [self hideHUD];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
    
    self.shoppingMallTableView.rowHeight = 42.5;
}
#pragma mark - searchBar的代理方法
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    SearchGoodsViewController *search = [[SearchGoodsViewController alloc] init];
    search.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:search animated:YES];
    return NO;
}

- (void)clickSearchBar{
    SearchGoodsViewController *search = [[SearchGoodsViewController alloc] init];
    search.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:search animated:YES];
}

- (void)clickSystemButton{
    if ([FrankTools loginIsOrNot:self]) {
        NoticeViewController *messageVC = [[NoticeViewController alloc] init];
        messageVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:messageVC animated:YES];
    }
}

- (void)getNoticeNumber{
    NSDictionary *dic = @{@"token":[FrankTools getUserToken],
                          @"device_id":[FrankTools getDeviceUUID]};
    [MainRequest RequestHTTPData:PATH(@"api/notice/unreadNotice") parameters:dic success:^(id responseData) {
        NSInteger unread_num = [[responseData objectForKey:@"unread_num"] integerValue];
        if (unread_num > 0) {
            self.navigationItem.rightBarButtonItem.badgeCenterOffset = CGPointMake(-13, 6);
            self.navigationItem.rightBarButtonItem.badgeBgColor = [UIColor whiteColor];
            self.navigationItem.rightBarButtonItem.badgeTextColor = [UIColor redColor];
            [self.navigationItem.rightBarButtonItem showBadgeWithStyle:WBadgeStyleNumber value:unread_num animationType:WBadgeAnimTypeNone];
        }else{
            [self.navigationItem.rightBarButtonItem clearBadge];
        }
    } failed:^(NSDictionary *errorDic) {
        
    }];
}
#pragma mark - 创建tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShoppingMallTitleCell *shoppingMallTitleCell = [tableView dequeueReusableCellWithIdentifier:@"ShoppingMallTitleCellKey"];
    if (!shoppingMallTitleCell) {
        shoppingMallTitleCell = [[[NSBundle mainBundle] loadNibNamed:@"ShoppingMallTitleCell" owner:self options:nil] firstObject];
    }
    shoppingMallTitleCell.selectionStyle = UITableViewCellSelectionStyleNone;
    shoppingMallTitleCell.shoppingMallTitle.text = self.titleArr[indexPath.row];
    return shoppingMallTitleCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self showHUDWithMessage:nil];
    [CategoryModel loadDataWithOrderDetail:[self.idArr[indexPath.row] integerValue]success:^(NSMutableArray *shoppingMallArrs) {
        [self.contentArr removeAllObjects];
        for (CategoryModel *model in shoppingMallArrs[1]) {
            [self.contentArr addObject:model];
        }
        self.indexTitle = indexPath.row;
        [self hideHUD];
        [self.shoppingMallCollectionView reloadData];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
    
}
#pragma mark - 创建collectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.contentArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShoppingMallContentCell *shoppingMallContentCell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShoppingMallContentCellKey" forIndexPath:indexPath];
    shoppingMallContentCell.backgroundColor = [UIColor whiteColor];
    CategoryModel *model = self.contentArr[indexPath.row];
    shoppingMallContentCell.contentTitle.text = model.cat_name;
    [FrankTools setImgWithImgView:shoppingMallContentCell.contentImg withImageUrl:model.category_img withPlaceHolderImage:placeSquareImg];
    return shoppingMallContentCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeMake((self.shoppingMallCollectionView.bounds.size.width-15)/3, (self.shoppingMallCollectionView.bounds.size.width-15)/3 + 32);
    return size;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        ShoppingMallHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ShoppingMallHeaderViewKey" forIndexPath:indexPath];
        view.frame = CGRectMake(0, 0, self.shoppingMallCollectionView.bounds.size.width, 35);
        if (self.titleArr.count != 0) {
           view.titleLab.text = self.titleArr[self.indexTitle];
        }
        return view;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGSize size = {self.shoppingMallCollectionView.bounds.size.width, 35};
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    CommodityListViewController *commodityListVC = [[CommodityListViewController alloc] init];
    CategoryModel *model = self.contentArr[indexPath.row];
    commodityListVC.goodsName = model.cat_name;
    commodityListVC.categoryId = model.cat_id;
    commodityListVC.ifFromShoppingMallView = YES;
    commodityListVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:commodityListVC animated:YES];
}

@end
