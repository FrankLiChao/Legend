//
//  UserRealAuthModel.h
//  LegendWorld
//
//  Created by Frank on 2016/12/13.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserRealAuthModel : NSObject

@property (nonatomic, strong)NSString *user_id;
@property (nonatomic, strong)NSString *real_name;//--姓名
@property (nonatomic, strong)NSString *ID_card;//--身份证
@property (nonatomic, strong)NSString *qq;
@property (nonatomic, strong)NSString *email;
@property (nonatomic, strong)NSString *open_bank;//--开户行
@property (nonatomic, strong)NSString *open_name;//--开户名
@property (nonatomic, strong)NSString *bank_card_no;//--银行卡号
@property (nonatomic, strong)NSString *branch_bank_name;//--支行名称
@property (nonatomic, strong)NSString *branch_bank_no;//--支行编号
@property (nonatomic, strong)NSString *status;//--状态0:待审核   1.审核中 2:已审核通过  3:未审核通过
@property (nonatomic, strong)NSString *create_time;//--创建时间
@property (nonatomic, strong)NSString *bank_name;//--银行名(认证信息)
@property (nonatomic, strong)NSString *bank_logo;//
@property (nonatomic, strong)NSString *card_tail_num;//尾号
@property (nonatomic, strong)NSString *reason;//开户失败的原因

+ (UserRealAuthModel *)parseUserRealAuthModel:(id)response;

+ (UserRealAuthModel *)parseModel:(id)response;
@end
