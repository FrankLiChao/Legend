//
//  OrderModel.m
//  LegendWorld
//
//  Created by ios-dev-01 on 16/9/21.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "OrderModel.h"

@implementation SellerInfoModel

@end

@implementation OrderModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"goods_list":[ProductModel class]};
}
- (NSString*)dateStr{
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self.create_time doubleValue]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
    
}
+(NSArray <OrderModel *> *)parseResponse:(id)response
{
    NSArray *arr = [OrderModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"order_list"]];
    return arr;
}

+ (NSArray<OrderModel *> *)parseOrderListResponse:(id)response {
    if ([response isKindOfClass:[NSDictionary class]]) {
        NSMutableArray *orders = [NSMutableArray array];
        for (NSDictionary *orderDic in [response objectForKey:@"order_list"]) {
            OrderModel *order = [[OrderModel alloc] init];
            order.order_id = [orderDic objectForKey:@"order_id"];
            order.order_money = [orderDic objectForKey:@"order_money"];
            order.order_number = [orderDic objectForKey:@"order_number"];
            order.order_status = [orderDic objectForKey:@"order_status"];
            order.order_type = [orderDic objectForKey:@"order_type"];
            order.share_money = [orderDic objectForKey:@"share_money"];
            order.shipping_fee = [orderDic objectForKey:@"shipping_fee"];
            order.complete_status = [orderDic objectForKey:@"complete_status"];
            order.create_time = [orderDic objectForKey:@"create_time"];
            order.is_after = [[orderDic objectForKey:@"is_after"] integerValue];
            
            SellerInfoModel *sellerInfo = [[SellerInfoModel alloc] init];
            sellerInfo.seller_id = [orderDic objectForKey:@"seller_id"];
            order.seller_info = sellerInfo;
            
            NSMutableArray *goodsArray = [NSMutableArray array];
            for (NSDictionary *goodsDic in [orderDic objectForKey:@"goods_list"]) {
                GoodsModel *goods = [[GoodsModel alloc] init];
                goods.goods_id = [goodsDic objectForKey:@"goods_id"];
                goods.goods_name = [goodsDic objectForKey:@"title"];
                goods.goods_thumb = [goodsDic objectForKey:@"img"];
                goods.price = [goodsDic objectForKey:@"goods_price"];
                goods.goods_number = [[goodsDic objectForKey:@"num"] integerValue];
                goods.size_id = [goodsDic objectForKey:@"size_id"];
                
                NSMutableArray *attrs = [NSMutableArray array];
                for (NSDictionary *attDic in [goodsDic objectForKey:@"goods_attr"]) {
                    GoodsAttrModel *attr = [[GoodsAttrModel alloc] init];
                    attr.attr_name = [NSString stringWithFormat:@"%@：%@",[attDic objectForKey:@"name"],[attDic objectForKey:@"value"]];
                    [attrs addObject:attr];
                }
                goods.attributes = [attrs copy];
                [goodsArray addObject:goods];
            }
            order.order_goods = [goodsArray copy];
            [orders addObject:order];
        }
        return [orders copy];
    }
    return nil;
}



+ (OrderModel *)parseOrderDetailResponse:(id)response {
    if ([response isKindOfClass:[NSDictionary class]]) {
        NSDictionary *orderDic = [response objectForKey:@"info"];
        OrderModel *order = [[OrderModel alloc] init];
        order.order_id = [orderDic objectForKey:@"order_id"];
        order.order_money = [orderDic objectForKey:@"order_money"];
        order.order_number = [orderDic objectForKey:@"order_number"];
        order.order_status = [orderDic objectForKey:@"order_status"];
        order.order_type = [orderDic objectForKey:@"order_type"];
        order.share_money = [orderDic objectForKey:@"share_money"];
        order.shipping_fee = [orderDic objectForKey:@"shipping_fee"];
        order.complete_status = [orderDic objectForKey:@"complete_status"];
        order.create_time = [orderDic objectForKey:@"create_time"];
        order.is_after = [[orderDic objectForKey:@"is_after"] integerValue];
        order.goods_amount = [orderDic objectForKey:@"goods_amount"];
        order.pay_type = [orderDic objectForKey:@"pay_type"];
        order.pay_time = [orderDic objectForKey:@"pay_time"];
        order.shipping_time = [orderDic objectForKey:@"shipping_time"];
        order.confirm_receipt_time = [orderDic objectForKey:@"confirm_receipt_time"];
        order.is_endorse = [[orderDic objectForKey:@"is_endorse"] boolValue];
        order.need_note = [orderDic objectForKey:@"need_note"];
        order.complete_time = [NSString stringWithFormat:@"%@",[orderDic objectForKey:@"comment_time"]];
        order.range_time = [orderDic objectForKey:@"range_time"];
        order.shipping_number = [orderDic objectForKey:@"shipping_number"];
        
        RecieveAddressModel *address = [[RecieveAddressModel alloc] init];
        address.consignee = [orderDic objectForKey:@"consignee"];
        address.mobile = [orderDic objectForKey:@"mobile"];
        address.address = [orderDic objectForKey:@"address"];
        address.area = [orderDic objectForKey:@"area"];
        order.address = address;
        
        NSMutableArray *goodsArray = [NSMutableArray array];
        for (NSDictionary *goodsDic in [orderDic objectForKey:@"goods_list"]) {
            GoodsModel *goods = [[GoodsModel alloc] init];
            goods.goods_id = [goodsDic objectForKey:@"goods_id"];
            goods.goods_name = [goodsDic objectForKey:@"title"];
            goods.goods_thumb = [goodsDic objectForKey:@"img"];
            goods.goods_number = [[goodsDic objectForKey:@"num"] integerValue];
            goods.shop_price = [goodsDic objectForKey:@"market_price"];
            goods.price = [goodsDic objectForKey:@"goods_price"];
            goods.attr_id = [[goodsDic objectForKey:@"attr_id"] integerValue];
            goods.attr_name = [goodsDic objectForKey:@"attr_name"];
            goods.after_id = [goodsDic objectForKey:@"after_id"];
            goods.apply_time = [goodsDic objectForKey:@"apply_time"];
            goods.after_status = [[goodsDic objectForKey:@"after_status"] integerValue];
            goods.is_complete = [[goodsDic objectForKey:@"is_complete"] integerValue];
            goods.complete_type = [[goodsDic objectForKey:@"complete_type"] integerValue];
            goods.complete_time = [goodsDic objectForKey:@"complete_time"];
            goods.is_endorse = [goodsDic objectForKey:@"is_endorse"];
            goods.is_tocard = [[goodsDic objectForKey:@"is_tocard"] boolValue];
            goods.size_id = [goodsDic objectForKey:@"size_id"];
            [goodsArray addObject:goods];
        }
        order.order_goods = [goodsArray copy];
        
        NSDictionary *sellerDic = [orderDic objectForKey:@"seller_info"];
        SellerInfoModel *sellerInfo = [[SellerInfoModel alloc] init];
        sellerInfo.seller_id = [sellerDic objectForKey:@"seller_id"];
        sellerInfo.seller_name = [sellerDic objectForKey:@"seller_name"];
        sellerInfo.address = [sellerDic objectForKey:@"address"];
        sellerInfo.telephone = [sellerDic objectForKey:@"telephone"];
        sellerInfo.thumb_img = [sellerDic objectForKey:@"thumb_img"];
        sellerInfo.backup_img = [sellerDic objectForKey:@"backup_img"];
        
        order.seller_info = sellerInfo;
        return order;
    }
    return nil;
}

@end
