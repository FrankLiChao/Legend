//
//  UserDelegateViewController.h
//  LegendWorld
//
//  Created by wenrong on 16/9/19.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "BaseViewController.h"

@interface UserDelegateViewController : BaseViewController

@property NSInteger sourceType; //0表示用户协议， 1表示银联在线支付用户服务协议， 2表示新手教程
@property (nonatomic, strong)NSString *urlStr;

@end
