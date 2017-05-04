//
//  ApplyRecordModel.m
//  LegendWorld
//
//  Created by Frank on 2016/12/29.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "ApplyRecordModel.h"

@implementation ApplyRecordModel

+ (NSArray <ApplyRecordModel *> *)parseResponse:(NSArray *)arrayData{
    NSArray *arr = [ApplyRecordModel mj_objectArrayWithKeyValuesArray:arrayData];
    return arr;
}

@end
