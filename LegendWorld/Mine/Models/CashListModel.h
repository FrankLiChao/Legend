//
//  CashListModel.h
//  legend
//
//  Created by msb-ios-dev on 15/11/30.
//  Copyright © 2015年 e3mo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{

    CashType_UnKnow,
    CashType_Bank = 1,//银行卡提现
    CashType_WeChat_LuckMoney = 2,//微信红包
    CashType_WeChat = 3,//微信企业提现

}CashType;

typedef enum{
    
    CashStatus_Unknow=-1,
    CashStatus_ApplySuccess=0,//申请成功
    CashStatus_HavePay,//已付款
    CashStatus_Auditing,//审核中
    CashStatus_AuditFailed,//审核失败
    CashStatus_PayFailed,//付款失败
    CashStatus_BackToAccount,//退回到账户
}CashStatus;

@interface CashListModel :  NSObject

@property (nonatomic,strong)NSString *apply_time;
@property (nonatomic,strong)NSString *finish_time;
@property (nonatomic,strong)NSString *money;
@property (nonatomic,strong)NSString *nick_name;
@property (nonatomic,strong)NSString *status;
@property (nonatomic,strong)NSString *type;
@property (nonatomic,strong)NSString *bank_no;
@property (nonatomic,strong)NSString *bank_name;


@property (nonatomic)BOOL bSelected;

-(CashStatus)getSatus;
-(CashType)getType;

-(NSString*)applyDateStr;


@end
