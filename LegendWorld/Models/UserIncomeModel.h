//
//  UserIncomeModel.h
//  LegendWorld
//
//  Created by Frank on 2016/11/9.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserIncomeModel : NSObject
@property (nonatomic, strong)NSString *today_income;//当日收益
@property (nonatomic, strong)NSString *total_income;//总收益
@property (nonatomic, strong)NSString *process_income;//进行中的收益
@property (nonatomic, strong)NSString *user_money;//用户余额
@property (nonatomic, strong)NSString *weekshare_pre_income;//待分红收益
@property (nonatomic, strong)NSString *user_name;
@property (nonatomic, strong)NSString *photo_url;
@property (nonatomic, strong)NSString *grade;//代理等级
+ (UserIncomeModel *)parseResponse:(id)response;

@end
