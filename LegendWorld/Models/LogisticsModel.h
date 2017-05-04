//
//  LogisticsModel.h
//  LegendWorld
//
//  Created by Tsz on 2016/11/17.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LogisticsProcessModel;
@interface LogisticsModel : NSObject

@property (nonatomic, strong) NSString *number;//物流单号
@property (nonatomic, strong) NSString *companyName;//物流公司名称
@property (nonatomic, strong) NSString *type;//物流公司类型
@property (nonatomic, strong) NSString *telephone;//物流公司类型
@property (nonatomic) NSInteger deliveryStatusCode;//物流状态码
@property (nonatomic, strong) NSString *deliveryStatusDesc;//物流状态描述
@property (nonatomic) BOOL isSign;//是否已签收
@property (nonatomic, strong) NSArray<LogisticsProcessModel *> *processes;//配送状态

+ (LogisticsModel *)parseByLogisticsDic:(NSDictionary *)dic;


@end





@interface LogisticsProcessModel : NSObject

@property (nonatomic, strong) NSString *time;//时间
@property (nonatomic, strong) NSString *statusDesc;//配送状态描述

+ (LogisticsProcessModel *)parseByLogisticsProcessDic:(NSDictionary *)dic;

@end
