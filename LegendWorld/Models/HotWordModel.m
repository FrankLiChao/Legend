//
//  HotWordModel.m
//  LegendWorld
//
//  Created by Tsz on 2016/11/2.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "HotWordModel.h"

@implementation HotWordModel

@end

@implementation HotWordModel (NetworkParser)

+ (NSArray<HotWordModel *> *)parseResponse:(id)response {
    if ([response isKindOfClass:[NSDictionary class]]) {
        return [HotWordModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"hot_list"]];
    }
    return nil;
}

@end

