//
//  SetPayKeyViewController.h
//  LegendWorld
//
//  Created by wenrong on 16/9/27.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "BaseViewController.h"
#import "PayMethodViewController.h"
@interface SetPayKeyViewController : BaseViewController
@property (nonatomic, strong) NSString *mobile_no;
@property (nonatomic, strong) NSString *sms_token;
@property (nonatomic) BOOL ifFromForgetKeyView;
@property (nonatomic, strong) PayMethodViewController *payMethodVC;
@end
