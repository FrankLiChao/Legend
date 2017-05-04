//
//  IncomeListModel.h
//  LegendWorld
//
//  Created by Frank on 2016/11/18.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IncomeListModel : NSObject

@property (nonatomic, strong)NSString *income_id;//--收益id
@property (nonatomic, strong)NSString *money;//金额
@property (nonatomic, strong)NSString *share_type;//--收益类型：2.关联收益  4.直推收益  5.每周分红收益 6.TO卡奖励收益 7.TO卡分润收益 8.TO卡直推收益 9.TO卡关联收益
@property (nonatomic, strong)NSString *finish_time;//--时间戳
@property (nonatomic, strong)NSString *finish_date;//--日期
@property (nonatomic, strong)NSString *create_time;//
@property (nonatomic, strong)NSString *create_date;//--创建日期
@property (nonatomic, strong)NSString *status;//--状态：0.未领取，进行中 1.已领取 4.已取消

+ (NSArray <IncomeListModel *> *)parseResponse:(id)response;

+ (NSArray <IncomeListModel *> *)parseProcessResponse:(id)response;
@end
