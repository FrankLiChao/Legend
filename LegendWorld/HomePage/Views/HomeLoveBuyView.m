//
//  HomeLoveBuyView.m
//  LegendWorld
//
//  Created by Frank on 2016/11/1.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "HomeLoveBuyView.h"
#import "HomeCollectionViewCell.h"
#import "HomeCollectionReusableView.h"
#import "CommodityListViewController.h"

@interface HomeLoveBuyView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak,nonatomic) UICollectionView *myCollectView;
@property (weak,nonatomic) UIViewController *tempController;
@property (strong,nonatomic)NSDictionary *dataDic;

@end

@implementation HomeLoveBuyView

- (id)initWithFrame:(CGRect)frame :(UIViewController *)tempVc{
    self = [super initWithFrame:frame];
    if (self) {
        self.tempController = tempVc;
        //初始化UICollectionView
        //先实例化一个层
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.headerReferenceSize = CGSizeMake(DeviceMaxWidth, 40*widthRate);
        //创建一屏的视图大小
        UICollectionView *myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:layout];
        [myCollectionView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [myCollectionView registerClass:[HomeCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TitleHeaderView"];
        myCollectionView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
        myCollectionView.showsVerticalScrollIndicator = NO;
        myCollectionView. delegate = self ;
        myCollectionView. dataSource = self ;
        myCollectionView.showsHorizontalScrollIndicator = NO;
        self.myCollectView = myCollectionView;
        [self addSubview:myCollectionView];
        myCollectionView.scrollEnabled = NO;
    }
    return self;
}

-(void)setGoodsData:(NSDictionary *)goodsData{
    self.dataDic = goodsData;
    [self.myCollectView reloadData];
}

#pragma mark --UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-( NSInteger )collectionView:( UICollectionView *)collectionView numberOfItemsInSection:( NSInteger )section
{
    NSArray *array = nil;
    if (section == 0) {
        array = [self.dataDic objectForKey:@"first"];
        
    }else if (section == 1){
        array = [self.dataDic objectForKey:@"second"];
    }else if (section == 2) {
        array = [self.dataDic objectForKey:@"third"];
    }
    else{
        return 0;
    }
    return array.count;
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
        [headView.titleIm setImage:imageWithName(@"home_love_buy")];
    }else if (indexPath.section == 1) {
        [headView.titleIm setImage:imageWithName(@"home_xiangpinzhi")];
    }else if (indexPath.section == 2) {
        [headView.titleIm setImage:imageWithName(@"home_goutese")];
    }

    return headView;
}

//定义展示的Section的个数
-( NSInteger )numberOfSectionsInCollectionView:( UICollectionView *)collectionView
{
    return self.dataDic.count;
}

//每个UICollectionView展示的内容
-( UICollectionViewCell *)collectionView:( UICollectionView *)collectionView cellForItemAtIndexPath:( NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"cell";
    HomeCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    NSArray *array = nil;
    if (indexPath.section == 0) {
        array = [self.dataDic objectForKey:@"first"];
    }else if (indexPath.section == 1) {
        array = [self.dataDic objectForKey:@"second"];
    }else{
        array = [self.dataDic objectForKey:@"third"];
    }
    NSDictionary *dic = array[indexPath.row];
    NSString *imageUrl = nil;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
             imageUrl = [dic objectForKey:@"category_big_img"];
        }else{//category_img
            imageUrl = [dic objectForKey:@"category_img"];
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0 || indexPath.row == 3) {
            imageUrl = [dic objectForKey:@"category_img"];
        }else{//category_img
            imageUrl = [dic objectForKey:@"category_s_img"];
            [FrankTools setImgWithImgView:cell.backGroundIm withImageUrl:imageUrl withPlaceHolderImage:placeHolderImg];
            return cell;
        }
    }else{
        imageUrl = [dic objectForKey:@"category_img"];
    }
    [FrankTools setImgWithImgView:cell.backGroundIm withImageUrl:imageUrl withPlaceHolderImage:imageWithName(@"default_rectangle")];
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- ( CGSize )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:( NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return CGSizeMake (DeviceMaxWidth, 150*widthRate);
        }else{
            return CGSizeMake (DeviceMaxWidth/2, 90*widthRate);
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0 || indexPath.row == 3) {
            return CGSizeMake (DeviceMaxWidth/2, 90*widthRate);
        }else{
            return CGSizeMake (DeviceMaxWidth/4, 90*widthRate);
        }
    }else if (indexPath.section == 2) {
        return CGSizeMake (DeviceMaxWidth/2, 90*widthRate);
    }
    
    else {
        return (CGSize){0,0};
    }
    
}

//定义每个UICollectionView 的边距
-( UIEdgeInsets)collectionView:( UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake (0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = nil;
    if (indexPath.section == 0) {
        array = [self.dataDic objectForKey:@"first"];
    }else if (indexPath.section == 1) {
        array = [self.dataDic objectForKey:@"second"];
    }else{
        array = [self.dataDic objectForKey:@"third"];
    }
    NSDictionary *dic = array[indexPath.row];
    FLLog(@"%@",dic);
    if (!dic || dic.count <= 0) {
        return;
    }
    CommodityListViewController *commodity = [[CommodityListViewController alloc] init];
    commodity.goodsName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cat_name"]];
    commodity.categoryId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cat_id"]];
    commodity.ifFromShoppingMallView = YES;
    commodity.hidesBottomBarWhenPushed = YES;
//    self.tempController.hidesBottomBarWhenPushed = YES;
    [_tempController.navigationController pushViewController:commodity animated:YES];
}

@end
