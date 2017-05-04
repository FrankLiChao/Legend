//
//  OrderItemModel.h
//  LegendWorld
//
//  Created by Tsz on 2016/11/8.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderItemModel : NSObject

@property (nonatomic, strong) SellerModel *seller;
@property (nonatomic, strong) NSArray<GoodsModel *> *goods_list;

@property (nonatomic) NSInteger sum_goods;
@property (nonatomic) CGFloat sum_price;

@property (nonatomic, strong) NSString *orderMessage;//需求备注
@property (nonatomic, strong) NSString *sepcialMessage;//定制化需求

@end


@interface OrderItemModel (NetworkParser)

+ (NSArray<OrderItemModel *> *)parseResponse:(id)response;

@end
