//
//  OrderConfirmViewController.h
//  LegendWorld
//
//  Created by Tsz on 2016/11/7.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "BaseViewController.h"

@interface OrderConfirmViewController : BaseViewController

@property (nonatomic, strong) NSArray *orderItems;
@property (nonatomic, strong) RecieveAddressModel *address;
@property (nonatomic, strong) NSString *orderPrice;//订单总价
@property (nonatomic) BOOL addressFlag;

@end
