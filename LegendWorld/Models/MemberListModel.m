//
//  MemberListModel.m
//  LegendWorld
//
//  Created by Frank on 2016/11/18.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "MemberListModel.h"

@implementation MemberListModel

+ (NSArray <MemberListModel *> *)parseResponse:(id)response{
    NSArray *arr = [MemberListModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"buy_member_list"]];
    return arr;
}

+ (NSArray <MemberListModel *> *)parseNoBuyResponse:(id)response{
    NSArray *arr = [MemberListModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"no_buy_member_list"]];
    return arr;
}

@end
