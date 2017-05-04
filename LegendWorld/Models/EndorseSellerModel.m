//
//  EndorseSellerModel.m
//  LegendWorld
//
//  Created by Frank on 2016/11/18.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "EndorseSellerModel.h"

@implementation EndorseSellerModel

+ (NSArray <EndorseSellerModel *> *)parseResponse:(id)response{
    NSArray *arr = [EndorseSellerModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"endorse_seller_list"]];
    return arr;
}

@end
