//
//  AgentCertificationViewController.h
//  LegendWorld
//
//  Created by Frank on 2016/12/12.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgentCertificationViewController : BaseViewController

@property (nonatomic)BOOL agentTag; //表示是否已经认证(已认证需传YES)
@property (nonatomic)BOOL buyPage;//购买页面跳转而来
@property (nonatomic, strong)NSString *auth_status;//--To卡实名认证状态 0.未开户 1.已开户 2.开户失败 3.未申请实名认证'

@end
