//
//  Order.h
//  LegendWorld
//
//  Created by ios-dev-01 on 16/9/23.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSInteger{
    PayStatus_UnPay,//未付款
    PayStatus_PayFaile,//付款失败
    PayStatus_PaySuccess,//已付款
    //    PayStatus_UnSend,//未发货
    //    PayStatus_UnRecieve,//未收货
    
}PayStatus;

typedef enum : NSInteger{
    ProductWay_None,//未知
    ProductWay_Recharge = 1,//充值
    ProductWay_Goods = 2,//商品
    
}ProductWay;//交易商品类型




@interface SignaturedataModel : NSObject

@property (nonatomic,strong)NSString *prepayid;
@property (nonatomic,strong)NSString *weixin_package;
@property (nonatomic,strong)NSString *noncestr;
@property (nonatomic,strong)NSString *timestamp;
@property (nonatomic,strong)NSString *sign;
@end
@interface Order : NSObject

@property (nonatomic,strong)NSNumber *pay_type;
@property (nonatomic,strong)NSString *trade_no;
@property (nonatomic,strong)NSString *signature_data;
@property (nonatomic,strong) NSString *goods_info;
@property (nonatomic,strong)NSNumber *goods_amount;
@property (nonatomic,strong)NSNumber *order_amount;
@property (nonatomic,strong)NSNumber *recharge_money;
@property (nonatomic,strong)NSString *create_time;
@property (nonatomic,strong)NSString *pay_time;
@property (nonatomic,strong)NSNumber *pay_status;//充值状态
@property (nonatomic,strong)NSString *mobile_no;
@property (nonatomic,strong)SignaturedataModel *sigatureData;
@property ProductWay product_type;//商品type


@property (nonatomic,strong)NSString *image_url;
@property (nonatomic,strong)NSString *info;
@property (nonatomic,strong)NSString *property;


-(PayStatus)getPayStatus;

@end
