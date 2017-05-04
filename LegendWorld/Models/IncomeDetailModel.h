//
//  IncomeDetailModel.h
//  LegendWorld
//
//  Created by Frank on 2016/11/18.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IncomeDetailModel : NSObject

@property (nonatomic, strong)NSString *income_id;//--收益id
@property (nonatomic, strong)NSString *seller_id;//--商家id
@property (nonatomic, strong)NSString *goods_id;//--商品id
@property (nonatomic, strong)NSString *goods_name;//
@property (nonatomic, strong)NSString *trade_no;//交易订单号
@property (nonatomic, strong)NSString *share_type;//--收益类型：2.关联收益  4.直推收益  5.每周分红收益 16.TO卡奖励收益 17.TO卡分润收益 18.TO卡直推收益 19.TO卡关联收益
@property (nonatomic, strong)NSString *money;//
@property (nonatomic, strong)NSString *create_time;//--创建日期
@property (nonatomic, strong)NSString *create_date;//创建日期
@property (nonatomic, strong)NSString *finish_time;//
@property (nonatomic, strong)NSString *finish_date;
@property (nonatomic, strong)NSString *buy_time;//购买时间
@property (nonatomic, strong)NSString *status;//--状态：0.未到账 1.已到账 4.已退货
@property (nonatomic, strong)NSString *buyer_user_id;//购买人id
@property (nonatomic, strong)NSString *telephone;
@property (nonatomic, strong)NSString *user_name;
@property (nonatomic, strong)NSString *photo_url;
@property (nonatomic, strong)NSString *goods_number;//--件数
@property (nonatomic, strong)NSString *recommend_buy_num;//--直推VIP成员购买人数
@property (nonatomic, strong)NSString *share_reward_layer;//--我享受的关联收益层
@property (nonatomic, strong)NSString *share_relate_num;//--我享受的关联收益人数
@property (nonatomic, strong)NSString *pre_info_date;//--预计收益时间
@property (nonatomic, strong)NSString *status_msg;//--状态消息
@property (nonatomic, strong)NSString *task_info;//任务内容
@property (nonatomic, strong)NSString *expense_user_id;//刷卡人Id
@property (nonatomic, strong)NSString *expense_user_name;//刷卡人名字
@property (nonatomic, strong)NSString *expense_user_photo;//刷卡人头像

+ (IncomeDetailModel *)parseIncomeDetailDic:(id)response;

@end
