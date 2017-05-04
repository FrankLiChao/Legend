//
//  TOCardHomeViewController.h
//  LegendWorld
//
//  Created by Tsz on 2016/11/27.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "BaseViewController.h"

@interface TOCardHomeViewController : BaseViewController

@property (nonatomic) BOOL isActivated;
@property (nonatomic, strong)NSString *auth_status;//--To卡实名认证状态 0.未开户 1.已开户 2.开户失败 3.未申请实名认证'

@end
