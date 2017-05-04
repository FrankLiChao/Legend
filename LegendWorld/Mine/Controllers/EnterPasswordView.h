//
//  EnterPasswordView.h
//  legend
//
//  Created by heyk on 15/12/2.
//  Copyright © 2015年 e3mo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^EnterPasswordComoleBlock)(NSString *password);

@interface EnterPasswordView : UIView<UITextFieldDelegate>
{

    UIView *contentView ;
    UITextField *respond;
}

@property (nonatomic,strong)NSString *content;
@property (nonatomic,copy)EnterPasswordComoleBlock compleBlock;

+(void)showWithContent:(NSString*)content comple:(EnterPasswordComoleBlock)block;

@end
