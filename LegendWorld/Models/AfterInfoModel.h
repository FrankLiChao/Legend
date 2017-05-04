//
//  AfterInfoModel.h
//  LegendWorld
//
//  Created by Frank on 2016/11/15.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AfterInfoModel : NSObject

@property (nonatomic, strong)NSString *after_id;
@property (nonatomic, strong)NSString *goods_id;
@property (nonatomic, strong)NSString *after_num;
@property (nonatomic, strong)NSString *user_id;
@property (nonatomic, strong)NSString *order_id;
@property (nonatomic, strong)NSString *after_type;//售后类型（1：退货退款 2：换货 3：退款）
@property (nonatomic, strong)NSString *agent_id;
@property (nonatomic, strong)NSString *seller_id;
@property (nonatomic, strong)NSString *attr_id;//规格ID
@property (nonatomic, strong)NSString *refund_money;//--申请退款金额
@property (nonatomic, strong)NSString *money_refund;//--退款金额
@property (nonatomic, strong)NSString *order_amount;//订单金额
@property (nonatomic, strong)NSString *express_company;
@property (nonatomic, strong)NSString *express_num;
@property (nonatomic, strong)NSString *se_expr_company;
@property (nonatomic, strong)NSString *se_expr_num;
@property (nonatomic, strong)NSString *apply_time;//--申请时间
@property (nonatomic, strong)NSString *after_status;//--售后状态（1：申请售后；2：同意；3:买家发货; 4:卖家收货;5：拒绝；6：取消）
@property (nonatomic, strong)NSString *modifi_time;
@property (nonatomic, strong)NSString *is_complete;//--'是否完成（1完成，2未完成）'
@property (nonatomic, strong)NSString *complete_type;//--'完成类型（1买家取消 2 卖家同意买家超时未修改 3已完成）'
@property (nonatomic, strong)NSString *complete_reason;//-完成原因
@property (nonatomic, strong)NSString *complete_time;//--完成时间
@property (nonatomic, strong)NSString *after_again;//
@property (nonatomic, strong)NSString *after_reason;//--退款原因
@property (nonatomic, strong)NSString *refuse_reason;//--商家拒绝原因
@property (nonatomic, strong)NSString *after_img;//图片凭证
@property (nonatomic, strong)NSString *get_status;//--'货物收到状态 {1收到 ，2未收到}'
@property (nonatomic, strong)NSString *refund_explain;//退款说明
@property (nonatomic, strong)NSString *return_addr;//--商家地址
@property (nonatomic, strong)NSString *refuse_time;//--商家拒绝时间
@property (nonatomic, strong)NSString *create_time;//--重新提交时间
@property (nonatomic, strong)NSString *range_time;//--在申请售后 3天倒计时

+ (AfterInfoModel *)parseAfterInforResponse:(id)response;
+(NSString *)getAfterStatus:(NSInteger)after_status :(NSInteger)after_type;
+(NSString *)getCompleteReason:(NSString *)complete_type;
@end
