//
//  SellerModel.h
//  LegendWorld
//
//  Created by Tsz on 2016/11/1.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SellerModel : NSObject

@property (nonatomic) NSInteger seller_id;
@property (nonatomic, strong) NSString *seller_name;//--店铺名字
@property (nonatomic, strong) NSString *thumb_img;//
@property (nonatomic, strong) NSString *backup_img;
@property (nonatomic) BOOL col_flag;
@property (nonatomic) NSInteger collect_count;
@property (nonatomic, strong) NSString *collect_id;
@property (nonatomic) CGFloat dividend_price;
@property (nonatomic) CGFloat com_money;
@property (nonatomic, strong) NSString *telephone;
@property (nonatomic, strong)NSString *address;//--店铺地址
@property (nonatomic, strong)NSString *after_address;//售后地址

//购物车添加
@property (nonatomic) CGFloat price_distance;

//订单
@property (nonatomic) CGFloat seller_fee;
@end

@interface SellerModel (NetworkParser)

+ (SellerModel *)parseResponse:(id)response;
+ (NSArray <SellerModel *> *)parseSellerList:(id)response;
+ (NSInteger)parseCollectCountResponse:(id)response;

@end
