//
//  IncomeDetailModel.m
//  LegendWorld
//
//  Created by Frank on 2016/11/18.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "IncomeDetailModel.h"

@implementation IncomeDetailModel

+ (IncomeDetailModel *)parseIncomeDetailDic:(id)response{
    if ([response isKindOfClass:[NSDictionary class]]) {
        return [IncomeDetailModel mj_objectWithKeyValues:[response objectForKey:@"income_detail"]];
    }
    return [[IncomeDetailModel alloc] init];
}

@end
