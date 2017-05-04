//
//  OrderItemModel.m
//  LegendWorld
//
//  Created by Tsz on 2016/11/8.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "OrderItemModel.h"

@implementation OrderItemModel

@end


@implementation OrderItemModel (NetworkParser)

+ (NSArray<OrderItemModel *> *)parseResponse:(id)response {
    if ([response isKindOfClass:[NSDictionary class]]) {
        NSMutableArray *itemsArr = [NSMutableArray array];
        NSArray *items = (NSArray *)[response objectForKey:@"cart_list"];
        for (NSDictionary *dic in items) {
            OrderItemModel *item = [[OrderItemModel alloc] init];
            
            SellerModel *seller = [[SellerModel alloc] init];
            seller.seller_id = [[dic objectForKey:@"seller_id"] integerValue];
            seller.seller_name = [dic objectForKey:@"seller_name"];
            seller.telephone = [dic objectForKey:@"telephone"];
            seller.thumb_img = [dic objectForKey:@"thumb_img"];
            seller.seller_fee = [[dic objectForKey:@"seller_fee"] floatValue];
            
            item.seller = seller;
            
            item.sum_goods = [[dic objectForKey:@"sum_goods"] integerValue];
            item.sum_price = [[dic objectForKey:@"sum_price"] floatValue];
            
            NSMutableArray *goodsArr = [NSMutableArray array];
            for (NSDictionary *goodsDic in (NSArray *)[dic objectForKey:@"goods_list"]) {
                GoodsModel *goods = [[GoodsModel alloc] init];
                goods.goods_id = [goodsDic objectForKey:@"goods_id"];
                goods.goods_name = [goodsDic objectForKey:@"title"];
                goods.goods_number = [[goodsDic objectForKey:@"num"] integerValue];
                goods.goods_thumb = [goodsDic objectForKey:@"img"];
                goods.attr_id = [[goodsDic objectForKey:@"attr_id"] integerValue];
                goods.price = [goodsDic objectForKey:@"goods_price"];
                goods.is_endorse = [goodsDic objectForKey:@"is_endorse"];
                goods.is_customize = [[goodsDic objectForKey:@"is_customize"] boolValue];
                
                NSDictionary *attrDic = [[goodsDic objectForKey:@"goods_attr"] firstObject];
                goods.attr_name = [NSString stringWithFormat:@"%@:%@",[attrDic objectForKey:@"name"],[attrDic objectForKey:@"value"]];
                [goodsArr addObject:goods];
            }
            item.goods_list = [goodsArr copy];
            
            [itemsArr addObject:item];
        }
        return [itemsArr copy];
    }
    return nil;
}

@end
