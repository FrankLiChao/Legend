//
//  ShoppingMallCell.h
//  legend
//
//  Created by ios-dev-01 on 16/8/19.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingMallCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *productImage; //代言产品图片
@property (nonatomic,strong) UILabel  *name;  //代言产品名称
@property (nonatomic,strong) UILabel  *price;   //代言产品价格
@property (nonatomic,strong) UILabel  *saleNumber;  //销量
//@property (nonatomic,strong) UIImageView *markImage; //代言标签
@property (nonatomic,strong) UILabel *markLable; //推荐代言的标签
@property (nonatomic, strong)UIView  *markView;
@end
