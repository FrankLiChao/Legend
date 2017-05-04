//
//  GoodsAppraiseModel.m
//  LegendWorld
//
//  Created by Frank on 2016/12/9.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "GoodsAppraiseModel.h"

@implementation GoodsAppraiseModel

+ (NSArray <GoodsAppraiseModel *> *)parseResponse:(id)response{
    NSArray *arr = [GoodsAppraiseModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"list"]];
    return arr;
}

@end
