//
//  LoginController.h
//  LegendWorld
//
//  Created by wenrong on 16/9/18.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "BaseViewController.h"
#import "UserModel.h"
#import "BaseTextField.h"

@protocol RefreshingViewDelegate <NSObject>

- (void)refreshingUI;

@end

@interface LoginViewController : BaseViewController

@property (nonatomic, weak) id<RefreshingViewDelegate> delegate;


@end
