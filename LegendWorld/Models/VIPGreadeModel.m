//
//  VIPGreadeModel.m
//  LegendWorld
//
//  Created by Frank on 2016/11/16.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "VIPGreadeModel.h"

@implementation VIPGreadeModel

+ (VIPGreadeModel *)parseVIPGreadeResponse:(id)response{
    if ([response isKindOfClass:[NSDictionary class]]) {
        return [VIPGreadeModel mj_objectWithKeyValues:response];
    }
    return [[VIPGreadeModel alloc] init];
}

@end
