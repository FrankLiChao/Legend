//
//  WaitShareIncomeModel.m
//  LegendWorld
//
//  Created by Frank on 2016/11/18.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "WaitShareIncomeModel.h"

@implementation WaitShareIncomeModel

+ (NSArray <WaitShareIncomeModel *> *)parseResponse:(id)response{
    NSArray *arr = [WaitShareIncomeModel mj_objectArrayWithKeyValuesArray:[[response objectForKey:@"endorse_list"] objectForKey:@"share_pre_income"]];
    return arr;
}

@end
