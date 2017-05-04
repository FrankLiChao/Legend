//
//  ShoppingCartItemModel.h
//  LegendWorld
//
//  Created by Tsz on 2016/11/2.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingCartItemModel : NSObject

@property (nonatomic, strong) SellerModel *seller;
@property (nonatomic, strong) NSArray<GoodsModel *> *goods_list;


@end


@interface ShoppingCartItemModel (NetworkParser)

+ (NSArray<ShoppingCartItemModel *> *)parseResponse:(id)response;

@end
