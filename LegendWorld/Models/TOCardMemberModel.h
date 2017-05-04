//
//  TOCardMemberModel.h
//  LegendWorld
//
//  Created by Tsz on 2016/11/28.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TOCardMemberModel : NSObject


@property (nonatomic, strong) NSString *user_id;//用户id
@property (nonatomic, strong) NSString *user_name;//用户名称
@property (nonatomic, strong) NSString *photo_url;//用户头像
@property (nonatomic, strong) NSString *grade;//用户TO卡等级
@property (nonatomic, strong) NSString *low_members_count;//成员数量
@property (nonatomic, strong)NSString *today_add_members_count;//今日新增
@property (nonatomic, strong) NSString *telephone;//用户电话
@property (nonatomic, strong) NSString *low_one_members_count;//一级成员数
@property (nonatomic, strong) NSString  *is_remove;//1置换中，0位置换

@end
