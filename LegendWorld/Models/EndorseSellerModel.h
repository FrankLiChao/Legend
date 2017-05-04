//
//  EndorseSellerModel.h
//  LegendWorld
//
//  Created by Frank on 2016/11/18.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EndorseSellerModel : NSObject

@property (nonatomic, strong)NSString *seller_id;//
@property (nonatomic, strong)NSString *user_id;
@property (nonatomic, strong)NSString *relate_income_num;//--我当前的关联收益人数
@property (nonatomic, strong)NSString *endorse_end_time;//--代言截止时间 单位秒
@property (nonatomic, strong)NSString *next_share_income;//--下次分红收益
@property (nonatomic, strong)NSString *endorse_time;//--代言周期时间 单位秒
@property (nonatomic, strong)NSString *seller_name;//--商家名称
@property (nonatomic, strong)NSString *thumb_img;//--商家图片
@property (nonatomic, strong)NSString *recommend_buy_num;//--直推VIP成员购买人数
@property (nonatomic, strong)NSString *share_reward_layer;//--我最多可享受的收益层
@property (nonatomic, strong)NSString *next_share_date;//--下次分红时间
@property (nonatomic, strong)NSString *pre_share_date;//上次分红时间

+ (NSArray <EndorseSellerModel *> *)parseResponse:(id)response;

@end
