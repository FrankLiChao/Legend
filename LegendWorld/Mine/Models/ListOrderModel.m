//
//  OrderModel.m
//  legend
//
//  Created by heyk on 16/1/19.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import "ListOrderModel.h"
#import "MJExtension.h"
#import "MainRequest.h"

@implementation GoodsAttr



@end

@implementation OrderListGoodsModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"goods_attr": [GoodsAttr class]};
}
@end
@implementation ListOrderModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{ @"goods_list" : [OrderListGoodsModel class]};
}

+(void)loadDataWithCurrentPage: (NSInteger) currentPage
                     orderTpye: (NSInteger) type
                       success:(void (^)(NSArray<ListOrderModel*> *list)) orderList
                        failed:(void (^) (NSDictionary *errorDic)) erorrInfo {
    if (type > 0) {
        type+=1;
    }
    NSMutableDictionary *postDic = [NSMutableDictionary new];
    [postDic setObject:[FrankTools getDeviceUUID] forKey:@"device_id"];
    [postDic setObject:[FrankTools getUserToken] forKey:@"token"];
    [postDic setObject:[NSString stringWithFormat:@"%ld",(long)currentPage] forKey:@"page"];
    [postDic setObject:[NSString stringWithFormat:@"%ld",(long)type] forKey:@"status_type"];
    if (type > 0)
    {
        [postDic setObject:[NSNumber numberWithInteger:1] forKey:@"get_type"];
    }

    [MainRequest RequestHTTPData:PATHShop(@"/api/Order/getOrderList") parameters:postDic success:^(id response) {
        NSDictionary *dic = response;
        NSArray *orderArray = [ListOrderModel mj_objectArrayWithKeyValuesArray:dic[@"order_list"]];
        if (orderList) {
            orderList(orderArray);
        }
    } failed:^(NSDictionary *errorDic) {
        erorrInfo(errorDic);
    }];
}
@end

