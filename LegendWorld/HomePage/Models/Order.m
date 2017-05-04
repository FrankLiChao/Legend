//
//  Order.m
//  LegendWorld
//
//  Created by ios-dev-01 on 16/9/23.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "Order.h"

@implementation SignaturedataModel

@end


@implementation Order

-(PayStatus)getPayStatus{
    if ([self.pay_status intValue] == 0) {
        return PayStatus_UnPay;
    }
    else if([self.pay_status intValue] == 2){
        return PayStatus_PaySuccess;
    }
    else if([self.pay_status intValue] == 1){
        return PayStatus_PayFaile;
    }
    return PayStatus_UnPay;
}

@end
