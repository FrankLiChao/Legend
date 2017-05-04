//
//  OrderModel.h
//  LegendWorld
//
//  Created by ios-dev-01 on 16/9/21.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductModel.h"
@interface SellerInfoModel : NSObject

@property (nonatomic,strong)NSString *seller_id;//商家id
@property (nonatomic,strong)NSString *seller_name;
@property (nonatomic,strong)NSString *address;//购买数量
@property (nonatomic,strong)NSString *telephone;
@property (nonatomic,strong)NSString *backup_img;
@property (nonatomic,strong)NSString *thumb_img;

@end


@interface OrderModel : NSObject

@property (nonatomic,strong)NSString *order_id;//订单id
@property (nonatomic,strong)NSString *order_number;//订单编号
@property (nonatomic,strong)NSString *order_money;//订单价格
@property (nonatomic,strong)NSString *order_status;//订单状态 //1:未付款;2:未收货；3未发货；4订单完成
@property (nonatomic,strong)NSString *shipping_fee;//订单运费

@property (nonatomic,strong)NSString *create_time;//订单创建时间
@property (nonatomic,strong)NSString *range_time;//剩余自动确认收货时间:5-21
@property (nonatomic,strong)NSString *pay_time;//付款时间
@property (nonatomic,strong)NSString *shipping_time;//发货时间
@property (nonatomic,strong)NSString *shipping_number;//配送单号
@property (nonatomic,strong)NSString *confirm_receipt_time;//确认收货时间
@property (nonatomic,strong)NSString *complete_time;//完成（评价）时间

@property (nonatomic,strong)NSString *goods_amount;//商品价格
@property (nonatomic,strong)NSString *share_money;//返现

@property (nonatomic,strong)NSNumber *pay_type;//支付方式
@property (nonatomic,strong)SellerInfoModel *seller_info;//商家信息

@property (nonatomic,strong)NSArray<ProductModel *>  *goods_list;//商品列表
@property (nonatomic,strong)NSArray<GoodsModel *>  *order_goods;//订单商品

//-- add
@property (nonatomic, copy) NSString *order_type;
@property (nonatomic, copy) NSString *complete_status;
- (NSString*)dateStr;

@property (nonatomic,strong) NSString *ad_id;
@property (nonatomic,assign) BOOL is_endorse;
@property (nonatomic,assign) NSInteger is_after;

@property (nonatomic,strong) NSString *need_note;//需求定制

@property (nonatomic, strong) RecieveAddressModel *address;
@property (nonatomic, strong) LogisticsModel *logistic;//物流信息

@end

@interface OrderModel (NetworkParser)

+ (NSArray <OrderModel *> *)parseResponse:(id)response;

+ (NSArray<OrderModel *> *)parseOrderListResponse:(id)response;

+ (OrderModel *)parseOrderDetailResponse:(id)response;

@end
