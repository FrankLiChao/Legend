//
//  RecieveAddressModel.m
//  LegendWorld
//
//  Created by ios-dev-01 on 16/9/21.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "RecieveAddressModel.h"

@implementation RecieveAddressModel



@end


@implementation RecieveAddressModel (NetworkParser)

+ (RecieveAddressModel *)parseResponse:(id)response {
    if ([response isKindOfClass:[NSDictionary class]]) {
        NSDictionary *addressDic = [response objectForKey:@"address"];
        if (addressDic) {
            RecieveAddressModel *address = [[RecieveAddressModel alloc] init];
            address.consignee = [addressDic objectForKey:@"name"];
            address.address_id = [addressDic objectForKey:@"address_id"];
            address.mobile = [addressDic objectForKey:@"tel"];
            address.area_id = [addressDic objectForKey:@"area_id"];
            address.area = [addressDic objectForKey:@"area"];
            address.address = [addressDic objectForKey:@"address"];
            return address;
        }
    }
    return nil;
}

+ (NSArray <RecieveAddressModel *> *)parseArrayResponse:(id)response {
    NSArray *arr = [RecieveAddressModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"address_list"]];
    return arr;
}

@end
