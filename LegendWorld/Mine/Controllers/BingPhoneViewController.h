//
//  BingPhoneViewController.h
//  LegendWorld
//
//  Created by wenrong on 16/10/11.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseTextField.h"
@interface BingPhoneViewController : BaseViewController
@property (nonatomic) BOOL ifFromPayWordWay;
@property (nonatomic, retain) NSString *oldPhoneNum;
@property (nonatomic, retain) NSString *smsToken;
@end
