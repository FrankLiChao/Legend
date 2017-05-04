//
//  SellerModel.m
//  LegendWorld
//
//  Created by Tsz on 2016/11/1.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "SellerModel.h"

@implementation SellerModel



@end

@implementation SellerModel (NetworkParser)

+ (SellerModel *)parseResponse:(id)response {
    if ([response isKindOfClass:[NSDictionary class]]) {
        return [SellerModel mj_objectWithKeyValues:[response objectForKey:@"seller_info"]];
    }
    return nil;
}
+ (NSArray <SellerModel *> *)parseSellerList:(id)response{
    NSArray *arr = [SellerModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"shop_collect_list"]];
    return arr;
}

+ (NSInteger)parseCollectCountResponse:(id)response {
    if ([response isKindOfClass:[NSDictionary class]]) {
        return [[response objectForKey:@"collect_count"] integerValue];
    }
    return 0;
}


@end
