//
//  OrderModel.h
//  legend
//
//  Created by heyk on 16/1/19.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductModel.h"


@interface GoodsAttr : NSObject
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *value;
@end

@interface OrderListGoodsModel : NSObject
@property(nonatomic, copy) NSString *goods_id; //商品id
@property(nonatomic, copy) NSString *goods_price; //商品价格
@property(nonatomic, copy) NSString *img; //商品展示图
@property(nonatomic, copy) NSString *market_price; //商品市场价
@property(nonatomic, copy) NSString *num; //商品数量
@property(nonatomic, copy) NSString *title; //商品名
@property(nonatomic, strong) NSArray<GoodsAttr*> *goods_attr;

@end
@interface ListOrderModel : NSObject
@property (nonatomic,strong)NSString *order_id;//订单id
@property (nonatomic,strong)NSString *order_number;//订单编号
@property (nonatomic,strong)NSString *order_money;//订单价格
@property (nonatomic,strong)NSString *order_status;//订单状态 //1:未付款;2:未收货；3未发货；4订单完成
@property (nonatomic,strong)NSString *shipping_fee;//订单运费
@property (nonatomic,strong)NSString *create_time;//订单创建时间
@property (nonatomic,strong)NSString *shipping_time;//发货时间
@property (nonatomic,strong)NSString *share_money;//返现
@property (nonatomic,strong)NSArray<OrderListGoodsModel*>  *goods_list;//商品列表
@property (nonatomic, copy) NSString *order_type;
@property (nonatomic, copy) NSString *complete_status;
@property (nonatomic, retain) NSDictionary *seller_info;
+(void)loadDataWithCurrentPage: (NSInteger) currentPage
                     orderTpye: (NSInteger) type
                       success:(void (^)(NSArray<ListOrderModel*> *list)) orderList
                        failed:(void (^) (NSDictionary *errorDic)) erorrInfo;

@end

