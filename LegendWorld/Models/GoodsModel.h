//
//  GoodsListSortModel.h
//  LegendWorld
//
//  Created by wenrong on 16/11/2.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsModel : NSObject
@property (nonatomic, strong) NSString *goods_id;
@property (nonatomic, strong) NSString *goods_name;
@property (nonatomic, strong) NSString *shop_price;
@property (nonatomic, strong) NSString *goods_thumb;
@property (nonatomic, strong) NSString *sell_count;
@property (nonatomic, strong) NSString *is_endorse;
@property (nonatomic, strong) NSString *collect_id;
@property (nonatomic, strong) NSString *recommend_reward;
//购物车
@property (nonatomic) NSInteger cart_id;
@property (nonatomic) NSInteger goods_number;
@property (nonatomic) NSInteger attr_id;
@property (nonatomic, strong) NSString *attr_name;
@property (nonatomic, strong) NSString *price;
@property (nonatomic) NSInteger stock;//库存
@property (nonatomic) BOOL is_display;//1:未下架，0:已下架
@property (nonatomic) BOOL is_customize;//是否可定制化
@property (nonatomic, strong) NSArray<GoodsAttrModel *> *attributes;
//售后
@property (nonatomic) NSString *after_id;//售后id
@property (nonatomic) NSInteger after_status;//售后状态
@property (nonatomic, strong) NSString *apply_time;//售后申请时间
@property (nonatomic, strong) NSString *complete_time;//售后完成时间
@property (nonatomic) NSInteger is_complete;
@property (nonatomic) NSInteger complete_type;
@property (nonatomic) BOOL is_tocard;//是否是to卡
@property (nonatomic, strong) NSString *size_id;

@end

@interface GoodsModel (NetworkParser)

+ (NSArray<GoodsModel *> *)parseResponse:(id)response;
+ (NSArray<GoodsModel *> *)parseCollectResponse:(id)response;
+ (GoodsModel *)parsePOSResponse:(id)response;
@end
