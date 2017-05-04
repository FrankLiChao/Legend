//
//  IncomeListModel.m
//  LegendWorld
//
//  Created by Frank on 2016/11/18.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "IncomeListModel.h"

@implementation IncomeListModel

+ (NSArray <IncomeListModel *> *)parseResponse:(id)response{
    NSArray *arr = [IncomeListModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"income_list"]];
    return arr;
}

+ (NSArray <IncomeListModel *> *)parseProcessResponse:(id)response{
    NSArray *arr = [IncomeListModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"process_list"]];
    return arr;
}

@end
