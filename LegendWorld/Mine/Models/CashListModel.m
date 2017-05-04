//
//  CashListModel.m
//  legend
//
//  Created by msb-ios-dev on 15/11/30.
//  Copyright © 2015年 e3mo. All rights reserved.
//

#import "CashListModel.h"

@implementation CashListModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"apply_time":@"apply_time",
             @"finish_time":@"finish_time",
             @"money":@"money",
             @"nick_name":@"nick_name",
             @"status":@"status",
             @"type":@"type",
             @"bank_no":@"bank_no",
             @"bank_name":@"bank_name",
   
             };
}


-(CashStatus)getSatus{

    if (self.status) {
        return [self.status intValue];
    }
    return CashStatus_Unknow;
}
-(CashType)getType{

    if (self.type) {
        return [self.type intValue];
    }
    return CashType_UnKnow;
}

-(NSString*)applyDateStr{

    NSArray *array = [self.apply_time  componentsSeparatedByString:@" "];
    if (array.count>0) {
        return [array objectAtIndex:0];
    }
    return @"";
}

@end
