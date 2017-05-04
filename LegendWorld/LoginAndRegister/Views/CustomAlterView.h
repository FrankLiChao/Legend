//
//  CustomAlterView.h
//  legend
//
//  Created by msb-ios-dev on 15/10/30.
//  Copyright © 2015年 e3mo. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^CustomAlterClickBlock)(NSInteger index,id customAlterView);//1 leftbutton 2 rightButton

@interface CustomAlterView : UIView

@property (nonatomic,weak)IBOutlet UIView *contentView;
@property (nonatomic,weak)IBOutlet UIButton *leftButton;
@property (nonatomic,weak)IBOutlet UIButton *rightButton;
@property (nonatomic,weak)IBOutlet UILabel *titleLabel;
@property (nonatomic,weak)IBOutlet UITextView *messageTextView;
@property (nonatomic,weak)IBOutlet UIView *spearteLine;

@property (nonatomic,weak)IBOutlet NSLayoutConstraint *contenHeight;
@property (nonatomic,weak)IBOutlet NSLayoutConstraint *lineCenterX;

@property (nonatomic,copy)CustomAlterClickBlock clickBlock;


+ (CustomAlterView*)getInstanceWithTitle:( NSString *)title
              message:( NSString *)message
           leftButton:( NSString *)cancelButtonTitle
    rightButtonTitles:( NSString *)rightButtonTitles
                click:(CustomAlterClickBlock)block;

-(void)show;

-(void)dismiss;

@end
