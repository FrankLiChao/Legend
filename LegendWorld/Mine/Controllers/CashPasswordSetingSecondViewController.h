//
//  CashPasswordSetingSecondViewController.h
//  legend
//
//  Created by heyk on 15/12/1.
//  Copyright © 2015年 e3mo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface CashPasswordSetingSecondViewController : BaseViewController

@property (nonatomic,weak)IBOutlet UIView *inputView;
@property (nonatomic,weak)IBOutlet UILabel *tipLabel;
@property (nonatomic,weak)IBOutlet UILabel *messageLabel;
@property (nonatomic,weak)IBOutlet NSLayoutConstraint *inPutHeight; 

@end
