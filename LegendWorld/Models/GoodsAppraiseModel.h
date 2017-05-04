//
//  GoodsAppraiseModel.h
//  LegendWorld
//
//  Created by Frank on 2016/12/9.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsAppraiseModel : NSObject

@property (nonatomic, strong)NSString *agent_id;
@property (nonatomic, strong)NSString *comment_id;
@property (nonatomic, strong)NSArray *comment_img;
@property (nonatomic, strong)NSString *comment_rank;
@property (nonatomic, strong)NSString *content;
@property (nonatomic, strong)NSString *create_time;
@property (nonatomic, strong)NSString *goods_attr;
@property (nonatomic, strong)NSString *goods_brief;
@property (nonatomic, strong)NSString *goods_id;
@property (nonatomic, strong)NSString *goods_name;
@property (nonatomic, strong)NSString *ip_address;
@property (nonatomic, strong)NSString *order_id;
@property (nonatomic, strong)NSString *reply_content;
@property (nonatomic, strong)NSString *reply_time;
@property (nonatomic, strong)NSString *seller_id;
@property (nonatomic, strong)NSString *size_id;
@property (nonatomic, strong)NSString *status;
@property (nonatomic, strong)NSString *user_avatar;
@property (nonatomic, strong)NSString *user_id;
@property (nonatomic, strong)NSString *user_name;

+ (NSArray <GoodsAppraiseModel *> *)parseResponse:(id)response;

@end
