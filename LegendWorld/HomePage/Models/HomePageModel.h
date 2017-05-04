//
//  HomePageModel.h
//  LegendWorld
//
//  Created by ios-dev-01 on 16/9/18.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BannerGoodsModel : NSObject

@property (nonatomic,strong) NSString *banner_img; //轮播图片
@property (nonatomic,strong) NSString *goods_id;   //商品Id
@property (nonatomic,strong) NSString *goods_img;//商品图片
@property (nonatomic,strong) NSString *is_endorse;//是否代言
@property (nonatomic,strong) NSString *target_url;//分享链接

@end

@interface GoodsListModel : NSObject

@property (nonatomic,strong) NSString *goods_id;//商品Id
@property (nonatomic,strong) NSString *goods_name;//商品名称
@property (nonatomic,strong) NSString *goods_thumb;//商品列缩图
@property (nonatomic,strong) NSString *is_endorse;//是否代言
@property (nonatomic,strong) NSString *sell_count;//销量
@property (nonatomic,strong) NSString *shop_price;//售价

@end

@interface HomePageModel : NSObject

@property (nonatomic,strong) NSArray<BannerGoodsModel *> *banner_goods_list;
@property (nonatomic,strong) NSArray<GoodsListModel *> *guess_like_goods_list;


@end


