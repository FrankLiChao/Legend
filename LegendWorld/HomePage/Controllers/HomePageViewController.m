//
//  HomePageViewController.m
//  LegendWorld
//
//  Created by ios-dev-01 on 16/9/9.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "HomePageViewController.h"
#import "SDCycleScrollView.h"
#import "MainRequest.h"
#import "MJRefresh.h"
#import "lhSymbolCustumButton.h"
#import "ShoppingMallCell.h"
#import "NewcomerViewController.h"
#import "BillboardViewController.h"
#import "ProductDetailViewController.h"
#import "NoticeViewController.h"
#import "CustomAlterView.h"
#import "AgentSuccessController.h"
#import "AdvertViewController.h"
#import "MyIncomeViewController.h"
#import "SearchGoodsViewController.h"
#import "WZLBadgeImport.h"
#import "HomeLoveBuyView.h"
#import "HomeCollectionReusableView.h"
#import "HomeModel.h"
#import "LoadControl.h"
#import "UserDelegateViewController.h"

@interface HomePageViewController ()<SDCycleScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UISearchBarDelegate>

@property (weak, nonatomic) UIScrollView *myScrollView;
@property (weak, nonatomic) UICollectionView *myCollectionView;
@property (weak, nonatomic) SDCycleScrollView *cycleScrollView;
@property (weak, nonatomic) UIView *functionView;
@property (weak, nonatomic) UIBarButtonItem *rightItem;
@property (strong,nonatomic) HomeModel *homeModel;
@property (nonatomic)NSInteger pageIndex;
@property (nonatomic)NSInteger maxPageIndex;

//首页各模块
@property (weak,nonatomic) HomeLoveBuyView *loveBuy;

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"首页";
    self.homeModel = [HomeModel new];
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.placeholder = @"请输入商品名称";
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"systemnotice"] style:UIBarButtonItemStylePlain target:self action:@selector(clicksystemButton)];
    self.rightItem = rightItem;
    self.navigationItem.rightBarButtonItem = rightItem;

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight-64)];
    self.myScrollView = scrollView;
    self.myScrollView.showsVerticalScrollIndicator = NO;
    [self.myScrollView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.myScrollView addFooterWithTarget:self action:@selector(footerRefresh)];
    [self.view addSubview:_myScrollView];
    self.pageIndex = 1;
    [self initFrameView];
    
    //请求主页数据
    [self requestData];
    //获取未读消息条数
    [self getNoticeNumber];
}

- (void)requestData{
    [self showHUDWithMessage:nil];
    NSDictionary *dic = @{@"device_id":[FrankTools getDeviceUUID],
                          @"recommend_page":[NSString stringWithFormat:@"%ld",(long)self.pageIndex]};
    [HomeModel loadDataWithHomePage:dic success:^(HomeModel *homeModel) {
        if (self.pageIndex == 1) {
            self.homeModel = homeModel;
            self.maxPageIndex = [self.homeModel.goods_recommend_total_page integerValue];
        } else {
            NSMutableArray *array = [[NSMutableArray alloc] initWithArray:self.homeModel.goods_recommend_list];
            [array addObjectsFromArray:homeModel.goods_recommend_list];
            self.homeModel.goods_recommend_list = array;
        }
        if (self.homeModel) {
            [self initUI];
        }
        [self hideHUD];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

- (void)getNoticeNumber{
    NSDictionary *dic = @{@"token":[FrankTools getUserToken],
                          @"device_id":[FrankTools getDeviceUUID]};
    [MainRequest RequestHTTPData:PATH(@"api/notice/unreadNotice") parameters:dic success:^(id responseData) {
        NSInteger unread_num = [[responseData objectForKey:@"unread_num"] integerValue];
        if (unread_num > 0) {
            self.rightItem.badgeCenterOffset = CGPointMake(-13, 6);
            self.rightItem.badgeBgColor = [UIColor whiteColor];
            self.rightItem.badgeTextColor = [UIColor redColor];
            [self.rightItem showBadgeWithStyle:WBadgeStyleNumber value:unread_num animationType:WBadgeAnimTypeNone];
        }else{
            [self.rightItem clearBadge];
        }
    } failed:^(NSDictionary *errorDic) {
        
    }];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    SearchGoodsViewController *search = [[SearchGoodsViewController alloc] init];
    search.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:search animated:YES];
    return NO;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

//下拉刷新
- (void)headerRefresh
{
    self.pageIndex = 1;
    [self getNoticeNumber];
    [self.myScrollView headerEndRefreshing];
    [self requestData];
}

//上拉加载
- (void)footerRefresh
{
    if (self.pageIndex >= self.maxPageIndex) {
        [self.myScrollView footerEndRefreshing];
        return;
    }
    self.pageIndex++;
    [self requestData];
    [self.myScrollView footerEndRefreshing];
}

- (void)initUI{
    NSMutableArray *lunboArray = [NSMutableArray new];
    for (int i=0; i<self.homeModel.banner_goods_list.count; i++) {
        BannerModel *model = self.homeModel.banner_goods_list[i];
        [lunboArray addObject:model.banner_img];
    }
    self.cycleScrollView.imageURLStringsGroup = lunboArray;
    CGFloat hightG = 0;
    if (self.homeModel.goods_recommend_list || self.homeModel.goods_recommend_list.count) {
        NSInteger county = 0;
        if (self.homeModel.goods_recommend_list.count % 2 == 0) {
            county = self.homeModel.goods_recommend_list.count/2;
        }else{
            county = (self.homeModel.goods_recommend_list.count+1)/2;
        }
        hightG = 40*widthRate + 266*widthRate*county;
    }
    self.myCollectionView.sd_layout
    .leftSpaceToView(self.myScrollView,0)
    .rightSpaceToView(self.myScrollView,0)
    .topSpaceToView(self.loveBuy,0*widthRate)
    .heightIs(hightG+5*widthRate);
    
    [self.myCollectionView reloadData];
    [self.myScrollView setupAutoContentSizeWithBottomView:self.myCollectionView bottomMargin:5*widthRate];
    [self.myScrollView updateLayout];
    [self.myCollectionView updateLayout];
    
    self.loveBuy.goodsData = self.homeModel.goods_category_list;
}

- (void) initFrameView
{
    CGFloat hight = 0;
    
    NSMutableArray *lunboArray = [NSMutableArray new];
    for (int i=0; i<self.homeModel.banner_goods_list.count; i++) {
        BannerModel *model = self.homeModel.banner_goods_list[i];
        [lunboArray addObject:model.banner_img];
    }
    if (!self.cycleScrollView) {
        SDCycleScrollView *cycleScrollView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 200*widthRate)];
        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;// 分页控件位置
        cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;// 分页控件风格
        cycleScrollView.delegate = self;
        cycleScrollView.backgroundColor = [UIColor clearColor];
        cycleScrollView.autoScrollTimeInterval = 8;
        cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
        cycleScrollView.placeholderImage = [UIImage imageNamed:@"placeHolderImg"];
        self.cycleScrollView = cycleScrollView;
        [self.myScrollView addSubview:self.cycleScrollView];
    }
    hight += 200*widthRate;
    
    self.cycleScrollView.imageURLStringsGroup = lunboArray;
    NSArray *funArray = @[@"新手教程",@"抢广告",@"排行榜",@"我的收益"];//一元成代理
    NSArray *funImage = @[@"home_xinshou",@"home_qiang",@"home_paihangbang",@"home_shouyi"];
    NSInteger count = 0;
    if (funArray.count % 4 == 0) {
        count = funArray.count/4;
    }else{
        count = funArray.count/4 + 1;
    }
    if (!self.functionView) {
        UIView *funView = [UIView new];
        self.functionView = funView;
        self.functionView.backgroundColor = [UIColor whiteColor];
        [self.myScrollView addSubview:self.functionView];
        
        self.functionView.sd_layout
        .leftSpaceToView(self.myScrollView,0)
        .rightSpaceToView(self.myScrollView,0)
        .topSpaceToView(self.cycleScrollView,0)
        .heightIs(85*widthRate*count);
        
        CGFloat fxWith = (DeviceMaxWidth-20*widthRate)/4;
        CGFloat hightY = 0;
        for (int i = 0; i < funArray.count; i++) {
            if (i !=0 && i%4 == 0) {
                hightY += 85*widthRate;
            }
            
            lhSymbolCustumButton * funBtn = [[lhSymbolCustumButton alloc]initWithFrame1:CGRectMake(10*widthRate+fxWith*(i%4), hightY, fxWith, 85*widthRate)];
            funBtn.tag = i;
            NSString * str = [NSString stringWithFormat:@"%@", funImage[i]];
            [funBtn.imgBtn setImage:imageWithName(str) forState:UIControlStateNormal];
            funBtn.tLabel.text = [funArray objectAtIndex:i];
            funBtn.tLabel.textColor = contentTitleColorStr1;
            [funBtn addTarget:self action:@selector(funButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
            [self.functionView addSubview:funBtn];
        }
    }
    hight += 85*widthRate*count;
    
    //初始化主页模块
    HomeLoveBuyView *loveView = [[HomeLoveBuyView alloc] initWithFrame:CGRectMake(0, hight, DeviceMaxWidth, 990*widthRate) :self];
    loveView.backgroundColor = [UIColor whiteColor];
    self.loveBuy = loveView;
    [self.myScrollView addSubview:loveView];
    
    hight += 990*widthRate;
    
    CGFloat hightG = 0;
    if (self.homeModel.goods_recommend_list || self.homeModel.goods_recommend_list.count) {
        NSInteger county = 0;
        if (self.homeModel.goods_recommend_list.count % 2 == 0) {
            county = self.homeModel.goods_recommend_list.count/2;
        }else{
            county = (self.homeModel.goods_recommend_list.count+1)/2;
        }
        hightG =  40*widthRate+266*widthRate*county;
    }
    
    //精品推荐
    if (!self.myCollectionView) {
        //先实例化一个层
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        UICollectionView *myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [myCollectionView registerClass:[ShoppingMallCell class] forCellWithReuseIdentifier:@"cell"];
        [myCollectionView registerClass:[HomeCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TitleHeaderView"];
        myCollectionView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
        myCollectionView.showsVerticalScrollIndicator = NO;
        myCollectionView.scrollEnabled = NO;
        myCollectionView. delegate = self ;
        myCollectionView. dataSource = self ;
        self.myCollectionView = myCollectionView;
        [self.myScrollView addSubview:self.myCollectionView];
    }
    
    self.myCollectionView.sd_layout
    .leftSpaceToView(self.myScrollView,0)
    .rightSpaceToView(self.myScrollView,0)
    .topSpaceToView(self.loveBuy,0*widthRate)
    .heightIs(hightG+5*widthRate);
    
    [self.myScrollView setupAutoContentSizeWithBottomView:self.myCollectionView bottomMargin:5];

}
#pragma mark - 点击轮播图片
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    BannerModel *model = self.homeModel.banner_goods_list[index];
    if (!model) {
        return;
    }
    ProductDetailViewController *detailsView =  [ProductDetailViewController new];
    detailsView.hidesBottomBarWhenPushed = YES;
    detailsView.goods_id = [NSString stringWithFormat:@"%@",model.goods_id];
    detailsView.is_endorse = [model.is_endorse boolValue];
    [self.navigationController pushViewController:detailsView animated:YES];
}

#pragma mark --UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-( NSInteger )collectionView:( UICollectionView *)collectionView numberOfItemsInSection:( NSInteger )section
{
    return self.homeModel.goods_recommend_list.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (CGSize){DeviceMaxWidth,40*widthRate};
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    HomeCollectionReusableView *headView;
    if (kind == UICollectionElementKindSectionHeader) {
        headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"TitleHeaderView" forIndexPath:indexPath];
        headView.backgroundColor = viewColor;
    }
    if (indexPath.section == 0) {
        [headView.titleIm setImage:imageWithName(@"home_tuijian")];
    }
    
    return headView;
}


//定义展示的Section的个数
-( NSInteger )numberOfSectionsInCollectionView:( UICollectionView *)collectionView
{
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5*widthRate;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5*widthRate;
}

//每个UICollectionView展示的内容
-( UICollectionViewCell *)collectionView:( UICollectionView *)collectionView cellForItemAtIndexPath:( NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"cell";
    ShoppingMallCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.shadowColor = [UIColor darkGrayColor].CGColor;//shadowColor阴影颜色
    cell.layer.shadowOffset = CGSizeMake(0,1);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    cell.layer.shadowOpacity = 0.3;//阴影透明度，默认0
    cell.layer.shadowRadius = 1;//阴影半径，默认3
    GoodsRecommendModel *model = self.homeModel.goods_recommend_list[indexPath.row];
    //数据
    NSString *imageUrl = [NSString stringWithFormat:@"%@",model.goods_thumb];
    //基于SDWebImage的图片缓存机制
    [FrankTools setImgWithImgView:cell.productImage withImageUrl:imageUrl withPlaceHolderImage:placeHolderImg];
    //注释掉代言图标
    if ([model.is_endorse boolValue]) {
        cell.markView.hidden = NO;
    }else{
        cell.markView.hidden = YES;
    }
    cell.saleNumber.text = [NSString stringWithFormat:@"销量：%@",model.sell_count];
    cell.name.text = [NSString stringWithFormat:@"%@",model.goods_name];
//
//    //售价
    NSString *moneyStr = [NSString stringWithFormat:@"%.2f",[model.shop_price floatValue]];
    if (moneyStr && moneyStr.length>0) {
        NSString *priceStr = [NSString stringWithFormat:@"￥%@",moneyStr];
        NSMutableAttributedString * as = [[NSMutableAttributedString alloc]   initWithString:priceStr];
        [as addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, 1)];
        [as addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(priceStr.length-2, 2)];
        cell.price.attributedText = as;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsRecommendModel *model = self.homeModel.goods_recommend_list[indexPath.row];
    if (!model) {
        return;
    }
    ProductDetailViewController *detailsView =  [ProductDetailViewController new];
    detailsView.hidesBottomBarWhenPushed = YES;
    detailsView.goods_id = [NSString stringWithFormat:@"%@",model.goods_id];
    detailsView.is_endorse = [model.is_endorse boolValue];
    [self.navigationController pushViewController:detailsView animated:YES];
}


#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- ( CGSize )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:( NSIndexPath *)indexPath
{
    return CGSizeMake ((DeviceMaxWidth-15.5*widthRate)/2, 261*widthRate);
    
}

////定义每个UICollectionView 的边距
-( UIEdgeInsets)collectionView:( UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake (5*widthRate, 5*widthRate, 5*widthRate, 5*widthRate);
}

#pragma mark - clickEvent
-(void)clicksystemButton
{
    if ([FrankTools loginIsOrNot:self]) {
        NoticeViewController *messageVC = [[NoticeViewController alloc] init];
        messageVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:messageVC animated:YES];
    }
}

//功能区事件
-(void)funButtonEvent:(UIButton *)button
{
    switch (button.tag) {
        case 0:{
//            NewcomerViewController *newcomer = [NewcomerViewController new];
//            newcomer.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:newcomer animated:YES];
            UserDelegateViewController *newcomer =  [UserDelegateViewController new];
            newcomer.sourceType = 2;
            newcomer.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:newcomer animated:YES];
            break;
        }
        case 1:
        {
            if ([FrankTools loginIsOrNot:self]) {
                AdvertViewController *advert = [[AdvertViewController alloc] init];
                advert.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:advert animated:YES];
                break;
            }
        }
            break;
        case 2:{
            BillboardViewController *billboard = [BillboardViewController new];
            billboard.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:billboard animated:YES];
            break;
        }
        case 3:{
            if ([FrankTools loginIsOrNot:self]) {
                MyIncomeViewController *incomeViewC = [MyIncomeViewController new];
                incomeViewC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:incomeViewC animated:YES];
                break;
            }
            break;
        }
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
