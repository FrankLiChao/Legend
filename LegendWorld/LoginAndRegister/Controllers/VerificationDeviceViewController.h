//
//  VerificationDeviceViewController.h
//  LegendWorld
//
//  Created by Frank on 2016/11/21.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@protocol CheckUserDeviceDelegate <NSObject>

- (void)checkUserDevice:(NSString *)sms_token;

@end

@interface VerificationDeviceViewController : BaseViewController

@property (nonatomic, strong) NSString *mobile_no;
@property (nonatomic, weak) id delegate;

@end
