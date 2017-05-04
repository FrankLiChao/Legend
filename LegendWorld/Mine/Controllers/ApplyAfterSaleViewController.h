//
//  ApplyAfterSaleViewController.h
//  LegendWorld
//
//  Created by wenrong on 16/11/9.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "BaseViewController.h"

@protocol ApplyAfterSaleViewDelegate <NSObject>

- (void)popBackAct:(NSString *)after_id;

@end



@interface ApplyAfterSaleViewController : BaseViewController
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) NSString *goods_id;
@property (nonatomic, strong) NSString *seller_id;
@property (nonatomic, strong) NSString *goods_price;
@property (nonatomic, strong) NSString *attr_id;
@property (nonatomic, strong) NSString *refundMoneyStr;//退款价格
@property (nonatomic, strong) NSString *refundExplainStr;//退款说明
@property (nonatomic, strong) NSString *refundServiceStr;
@property (nonatomic, strong) NSString *refundReasonStr;
@property (nonatomic, strong) NSString *refundReasonAnotherStr;
@property (nonatomic, strong) NSString *goodsStatusStr;
@property (nonatomic, strong) NSMutableArray *picUploadImgArr;//退款图片
@property (nonatomic, strong) NSMutableArray *imageUrlArr;
@property (nonatomic, strong) NSString *after_id;
@property (nonatomic, weak) id <ApplyAfterSaleViewDelegate> delegate;
@property (nonatomic) BOOL ifFromFix;
@end
