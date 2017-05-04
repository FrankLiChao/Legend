//
//  UserRealAuthModel.m
//  LegendWorld
//
//  Created by Frank on 2016/12/13.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "UserRealAuthModel.h"

@implementation UserRealAuthModel

+ (UserRealAuthModel *)parseUserRealAuthModel:(id)response{
    if ([response isKindOfClass:[NSDictionary class]]) {
        return [UserRealAuthModel mj_objectWithKeyValues:[response objectForKey:@"real_auth_info"]];
    }
    return [[UserRealAuthModel alloc] init];
}

+ (UserRealAuthModel *)parseModel:(id)response{
    if ([response isKindOfClass:[NSDictionary class]]) {
        return [UserRealAuthModel mj_objectWithKeyValues:response];
    }
    return [[UserRealAuthModel alloc] init];
}

@end
