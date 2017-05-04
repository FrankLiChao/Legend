//
//  WxAccountModel.h
//  LegendWorld
//
//  Created by ios-dev-01 on 16/9/24.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WxAccountModel : NSObject

@property(nonatomic,strong)NSString *city;//城市
@property(nonatomic,strong)NSString *country;//国家
@property(nonatomic,strong)NSString *headimgurl;//头像
@property(nonatomic,strong)NSString *language;//语言
@property(nonatomic,strong)NSString *nickname;//昵称
@property(nonatomic,strong)NSString *openid;//
@property(nonatomic,strong)NSString *privilege;
@property(nonatomic,strong)NSString *province;//省份
@property(nonatomic,strong)NSNumber *sex;//性别
@property(nonatomic,strong)NSString *unionid;

@end
