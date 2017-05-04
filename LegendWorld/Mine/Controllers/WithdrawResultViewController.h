//
//  WithdrawResultViewController.h
//  LegendWorld
//
//  Created by Frank on 2016/11/10.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "BaseViewController.h"

@interface WithdrawResultViewController : BaseViewController

@property (nonatomic, strong)NSString *bankDetail; //银行卡及描述
@property (nonatomic, strong)NSString *moneyStr;//提现金额
@property (nonatomic)BOOL isWx;

@end
