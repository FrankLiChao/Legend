//
//  BillboardModel.h
//  LegendWorld
//
//  Created by ios-dev-01 on 16/9/18.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeekRankModel : NSObject

@property (nonatomic,strong) NSString *grade;//等级
@property (nonatomic,strong) NSString *grade_name;//等级名
@property (nonatomic,strong) NSString *member_num;//成员数
@property (nonatomic,strong) NSString *user_id;//用户Id
@property (nonatomic,strong) NSString *user_name;//用户昵称
@property (nonatomic,strong) NSString *week_income;//周收益
@property (nonatomic,strong) NSString *telephone;//电话
@property (nonatomic, strong)NSString *week_add_member;

@end

@interface MonthRankModel : NSObject

@property (nonatomic,strong) NSString *grade;//等级
@property (nonatomic,strong) NSString *grade_name;//等级名
@property (nonatomic,strong) NSString *member_num;//成员数
@property (nonatomic,strong) NSString *user_id;//用户Id
@property (nonatomic,strong) NSString *user_name;//用户昵称
@property (nonatomic,strong) NSString *month_income;//周收益
@property (nonatomic, strong)NSString *month_add_member;
@property (nonatomic,strong) NSString *telephone;//电话

@end

@interface BillboardModel : NSObject

@property (nonatomic,strong) NSArray<MonthRankModel *> *month_rank_list;//月榜
@property (nonatomic,strong) NSArray<WeekRankModel *> *week_rank_list;//周榜

@end
