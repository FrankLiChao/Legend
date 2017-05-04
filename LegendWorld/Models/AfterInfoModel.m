//
//  AfterInfoModel.m
//  LegendWorld
//
//  Created by Frank on 2016/11/15.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "AfterInfoModel.h"


@implementation AfterInfoModel

+ (AfterInfoModel *)parseAfterInforResponse:(id)response {
    if ([response isKindOfClass:[NSDictionary class]]) {
        return [AfterInfoModel mj_objectWithKeyValues:[response objectForKey:@"after_info"]];
    }
    return [[AfterInfoModel alloc] init];
}

+(NSString *)getAfterStatus:(NSInteger)after_status :(NSInteger)after_type{
    NSString *afterTypeStr = @"";
    NSString *afterStatus = @"等待商家处理";
    switch (after_type) {
        case 1:
            afterTypeStr = @"退货退款";
            break;
        case 2:
            afterTypeStr = @"换货";
            break;
        case 3:
            afterTypeStr = @"退款";
            break;
        default:
            break;
    }
    switch (after_status) {
        case 1:
            afterStatus = [NSString stringWithFormat:@"等待商家处理%@申请",afterTypeStr];
            break;
        case 2:
            afterStatus = [NSString stringWithFormat:@"商家同意了你的%@申请",afterTypeStr];
            break;
        case 3:
            afterStatus = @"买家发货";
            break;
        case 4:
            afterStatus = @"卖家收货";
            break;
        case 5:
            afterStatus = [NSString stringWithFormat:@"商家不同意你的%@申请",afterTypeStr];
            break;
        case 6:
            afterStatus = @"取消";
            break;
        default:
            break;
    }
    return afterStatus;
}

+(NSString *)getCompleteReason:(NSString *)complete_type{
    NSInteger type = [complete_type integerValue];
    NSString *typeStr = @"";
    switch (type) {
        case 1:
            typeStr = @"您取消了售后申请";
            break;
        case 2:
            typeStr = @"卖家同意您超时未填写物流单号，售后申请已关闭";
        default:
            typeStr = @"售后申请已完成";
            break;
    }
    return typeStr;
}

@end
