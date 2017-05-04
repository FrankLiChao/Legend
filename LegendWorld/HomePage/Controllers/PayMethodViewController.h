//
//  PayMethodViewController.h
//  LegendWorld
//
//  Created by 文荣 on 16/9/14.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, OrderPayType) {
    OrderPayTypeNone = 0,
    OrderPayTypeNormal = 1,
    OrderPayTypeCombined = 2
};

@interface PayMethodViewController : BaseViewController

@property (nonatomic, strong) NSString *orderNum;
@property (nonatomic, strong) NSString *orderMoney;

@property (nonatomic) OrderPayType orderPayType;
@property (nonatomic, strong)NSString *order_id;
@property (nonatomic) BOOL isFromOneYuanDelegate;//是否是一员成代理的支付

@end
