//
//  EndorseProtrolController.h
//  legend
//
//  Created by ios-dev on 16/5/10.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductDetailViewController.h"

@interface EndorseProtrolController : BaseViewController

@property (nonatomic,strong) NSString *brand_id;
@property (nonatomic,strong) NSString *ad_id;

//Frank 商品详情跳支付需要检测资料完整度
@property (nonatomic,strong) NSString *buyMark; //等于1表示要跳支付界面
@property (nonatomic,strong) ProductDetailViewController *myDelegate;//商品详情的代理

@end
