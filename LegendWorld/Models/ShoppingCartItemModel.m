//
//  ShoppingCartItemModel.m
//  LegendWorld
//
//  Created by Tsz on 2016/11/2.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "ShoppingCartItemModel.h"

@implementation ShoppingCartItemModel


@end

@implementation ShoppingCartItemModel (NetworkParser)

+ (NSArray<ShoppingCartItemModel *> *)parseResponse:(id)response {
    if ([response isKindOfClass:[NSDictionary class]]) {
        NSMutableArray *itemsArr = [NSMutableArray array];
        NSArray *items = (NSArray *)[response objectForKey:@"cart_list"];
        for (NSDictionary *dic in items) {
            ShoppingCartItemModel *item = [[ShoppingCartItemModel alloc] init];
            
            SellerModel *seller = [[SellerModel alloc] init];
            seller.seller_id = [[dic objectForKey:@"seller_id"] integerValue];
            seller.seller_name = [dic objectForKey:@"seller_name"];
            seller.price_distance = [[dic objectForKey:@"price_distance"] floatValue];
            
            item.seller = seller;
            
            NSMutableArray *goodsArr = [NSMutableArray array];
            for (NSDictionary *goodsDic in (NSArray *)[dic objectForKey:@"goods_list"]) {
                GoodsModel *goods = [[GoodsModel alloc] init];
                goods.goods_id = [goodsDic objectForKey:@"goods_id"];
                goods.goods_name = [goodsDic objectForKey:@"goods_name"];
                goods.goods_number = [[goodsDic objectForKey:@"goods_number"] integerValue];
                goods.goods_thumb = [goodsDic objectForKey:@"goods_thumb"];
                goods.cart_id = [[goodsDic objectForKey:@"cart_id"] integerValue];
                goods.attr_id = [[goodsDic objectForKey:@"attr_id"] integerValue];
                goods.attr_name = [goodsDic objectForKey:@"attr_name"];
                goods.price = [goodsDic objectForKey:@"price"];
                goods.is_endorse = [goodsDic objectForKey:@"is_endorse"];
                goods.stock = [[goodsDic objectForKey:@"stock"] integerValue];
                goods.is_display = [[goodsDic objectForKey:@"is_display"] boolValue];
                
                NSMutableArray *attrArr = [NSMutableArray array];
                for (NSDictionary *attrDic in [goodsDic objectForKey:@"attr_info"]) {
                    GoodsAttrModel *attr = [[GoodsAttrModel alloc] init];
                    attr.attr_id = [[attrDic objectForKey:@"size_id"] integerValue];
                    attr.attr_name = [attrDic objectForKey:@"size_name"];
                    attr.price = [attrDic objectForKey:@"price"];
                    attr.goods_number = [[attrDic objectForKey:@"goods_number"] integerValue];
                    [attrArr addObject:attr];
                }
                goods.attributes = [attrArr copy];
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
