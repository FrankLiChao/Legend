//
//  OrderPaySuccessViewController.h
//  LegendWorld
//
//  Created by Tsz on 2016/11/9.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "BaseViewController.h"

@interface OrderPaySuccessViewController : BaseViewController

@property (nonatomic, strong)NSString *order_id;//订单Id

@property (weak, nonatomic) IBOutlet UIButton *backToHomeBtn;
@property (weak, nonatomic) IBOutlet UIButton *goToManageOrderBtn;

@end
