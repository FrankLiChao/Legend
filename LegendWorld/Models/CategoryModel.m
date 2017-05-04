//
//  ShoppingMallModel.m
//  LegendWorld
//
//  Created by wenrong on 16/10/31.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "CategoryModel.h"

@implementation CategoryModel
+(void)loadDataWithOrderDetail:(NSInteger)category_id success:(void (^)( NSMutableArray*))shoppingMallList failed:(void (^)(NSDictionary *))errorInfo
{
    NSDictionary *parameters = [NSDictionary dictionary];
    if (category_id == 0) {
        parameters = @{@"device_id":[FrankTools getDeviceUUID]};
    }
    else{
        parameters = @{@"device_id":[FrankTools getDeviceUUID],
                       @"category_id":[NSNumber numberWithInteger:category_id]};
    }
    [MainRequest RequestHTTPData:PATHShop(@"api/Goods/getShopHomeInfo") parameters:parameters success:^(id response) {
        NSArray *titleList = [CategoryModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"goods_one_list"]];
        NSArray *contentList = [CategoryModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"goods_two_list"]];
        NSMutableArray *arrs = [NSMutableArray array];
        [arrs addObject:titleList];
        [arrs addObject:contentList];
        if (shoppingMallList) {
           shoppingMallList(arrs);
        }
    } failed:^(NSDictionary *errorDic) {
        errorInfo(errorDic);
    }];
}
@end

@implementation CategoryModel (NetworkParser)

+ (NSArray<CategoryModel *> *)parseResponse:(id)response {
    if ([response isKindOfClass:[NSDictionary class]]) {
        return [CategoryModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"category_list"]];
    }
    return nil;
}

@end
