//
//  UserIncomeModel.m
//  LegendWorld
//
//  Created by Frank on 2016/11/9.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "UserIncomeModel.h"

@implementation UserIncomeModel

+ (UserIncomeModel *)parseResponse:(id)response {
    if ([response isKindOfClass:[NSDictionary class]]) {
        return [UserIncomeModel mj_objectWithKeyValues:response];
    }
    return [[UserIncomeModel alloc] init];
}

@end
