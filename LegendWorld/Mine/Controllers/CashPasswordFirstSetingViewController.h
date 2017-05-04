//
//  CashPasswordFirstSetingViewController.h
//  legend
//
//  Created by heyk on 15/12/1.
//  Copyright © 2015年 e3mo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface CashPasswordFirstSetingViewController : BaseViewController

@property (nonatomic,weak)IBOutlet UILabel      *phoneNumLabel;
@property (nonatomic,weak)IBOutlet UITextField  *verifyCodeField;
@property (nonatomic,weak)IBOutlet UIView       *verifyCodeBackView;
@property (nonatomic,weak)IBOutlet UIButton     *verifyButton;
@property (nonatomic,weak)IBOutlet UIButton     *verifyCodeSendButton;

@property (nonatomic,weak)IBOutlet NSLayoutConstraint *verifyBackHeight;
@property (nonatomic,weak)IBOutlet NSLayoutConstraint *getVerifyCodeButtonHeight;
@property (nonatomic,weak)IBOutlet NSLayoutConstraint *verifyButtonHeight;

@end
