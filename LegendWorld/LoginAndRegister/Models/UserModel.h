//
//  UserModel.h
//  LegendWorld
//
//  Created by ios-dev-01 on 16/9/20.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic, strong) NSString *user_id;//用户id
@property (nonatomic, strong) NSString *user_name;//用户名
@property (nonatomic, strong) NSString *sex;//性别 0:男 1:女 2未设置
@property (nonatomic, strong) NSString *birthday;//生日
@property (nonatomic, strong) NSString *address;//地址
@property (nonatomic, strong) NSString *email;//电邮
@property (nonatomic, strong) NSString *wx_account;//微信号
@property (nonatomic, strong) NSString *work;//职业
@property (nonatomic, strong) NSString *company;//公司
@property (nonatomic, strong) NSString *department;//部门
@property (nonatomic, strong) NSString *hobby;//爱好
@property (nonatomic, strong) NSString *education;//学历
@property (nonatomic, strong) NSString *school;//学校
@property (nonatomic, strong) NSString *has_car;//车牌号
@property (nonatomic, strong) NSString *year_income;//年收入
@property (nonatomic, strong) NSString *photo_url;//头像
@property (nonatomic, strong) NSString *intro;//个人介绍
@property (nonatomic, strong) NSString *honor;//等级名
@property (nonatomic, strong) NSString *honor_grade;//等级
@property (nonatomic, strong) NSString *payment_pwd;//支付密码
@property (nonatomic, strong) NSString *update_condition;//升级成为新秀需要完成6个小白
@property (nonatomic, strong) NSString *day_grow;//日增长
@property (nonatomic, strong) NSString *straight_number;//直推人数
@property (nonatomic, strong) NSString *mobile_no;//手机号
@property (nonatomic, strong) NSString *freeze_money;//冻结资金
@property (nonatomic, strong) NSString *money;//余额
@property (nonatomic, strong) NSString *total_income;//总收益
@property (nonatomic, strong) NSString *already_real_auth;//是否已经实名认证成功 0：没有  1：成功
@property (nonatomic, strong) NSString *real_auth_status;//实名认证状态   0:待审核 1:审核中 2:已通过 3:未通过 4:未申请
@property (nonatomic, strong) NSString *already_bind_credit;//是否绑定信用卡 1：是 0：否
@property (nonatomic, strong) NSString *qr_code;//邀请好友二维码
@property (nonatomic, strong) NSString *tocard_grade;//TO卡代理等级
@property (nonatomic, strong) NSString *tocard_code;//TO卡二维码


@end
