//
//  WaitShareIncomeModel.h
//  LegendWorld
//
//  Created by Frank on 2016/11/18.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WaitShareIncomeModel : NSObject

@property (nonatomic, strong)NSString *seller_id;//--商家id
@property (nonatomic, strong)NSString *endorse_time;//--代言周期 单位秒
@property (nonatomic, strong)NSString *seller_name;//--商家名称
@property (nonatomic, strong)NSString *thumb_img;//--商家封面图
@property (nonatomic, strong)NSString *recommend_buy_num;//--直推VIP成员购买人数
@property (nonatomic, strong)NSString *share_reward_layer;//--我最多可享受的收益层
@property (nonatomic, strong)NSString *next_share_date;//--下次分红时间
@property (nonatomic, strong)NSString *user_id;

+ (NSArray <WaitShareIncomeModel *> *)parseResponse:(id)response;

@end
