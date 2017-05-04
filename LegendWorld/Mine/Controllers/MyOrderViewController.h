//
//  MyOrderViewController.h
//  LegendWorld
//
//  Created by 文荣 on 16/9/19.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "BaseViewController.h"

//订单索引：全部订单 待支付 待收货 待评论 已取消
typedef NS_ENUM(NSInteger, GPOrderIndex) {
    LWOrderIndexAll = 0,            //全部订单 0
    LWOrderIndexWillPay,        //待付款   1
    LWOrderIndexWillReceive,    //待收货   2
    LWOrderIndexWillComment,    //待评论   3
    LWOrderIndexCancelled,      //售后   4
};
@interface MyOrderViewController : BaseViewController

@property (nonatomic) NSInteger pageIndex;

@end
