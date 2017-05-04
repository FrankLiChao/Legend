//
//  EnterPasswordView.m
//  legend
//
//  Created by heyk on 15/12/2.
//  Copyright © 2015年 e3mo. All rights reserved.
//

#import "EnterPasswordView.h"

static  int cashPassowrdCount = 6;

@implementation EnterPasswordView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


+(void)showWithContent:(NSString*)content comple:(EnterPasswordComoleBlock)block{
    EnterPasswordView *enterPasswordView  = [[EnterPasswordView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    enterPasswordView.compleBlock = block;
    enterPasswordView.content = content;
    [enterPasswordView initUI];
    [enterPasswordView show];
}

-(void)initUI{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    float height = 185;
    float width = 300;
    
    float orgY = (self.frame.size.height - height)/2;
    if (self.frame.size.height - (orgY+height)<self.frame.size.height-220) {
        orgY = (self.frame.size.height-226 - height)/2;
    }
    contentView = [[UIView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - width)/2,orgY  , width, height)];
    [self addSubview:contentView];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 3;
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(0, 0, 60, 50);
    [closeButton setImage:[UIImage imageNamed:@"close_white.png"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(clickClose) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:closeButton];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(60, 10, contentView.frame.size.width - 120, 30);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithRed:101.0/255 green:101.0/255 blue:101.0/255 alpha:1];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.text = @"请输入支付密码";
    [contentView addSubview:titleLabel];
    
    if (self.content == nil) {
        titleLabel.frame = CGRectMake(60, 10, contentView.frame.size.width - 100, 30);
        titleLabel.text = @"请输入支付密码解绑银行卡";
    }
    
    UIView *speateLine = [[UIView alloc] initWithFrame:CGRectMake(0,  50, contentView.frame.size.width, 1)];
    speateLine.backgroundColor = [UIColor colorWithRed:229.0/255 green:218.0/255 blue:217.0/255 alpha:1];
    [contentView addSubview:speateLine];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,66, contentView.frame.size.width, 40)];
    contentLabel.font = [UIFont systemFontOfSize:50];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.textColor = [UIColor colorWithRed:101.0/255 green:101.0/255 blue:101.0/255 alpha:1];
    [contentView addSubview:contentLabel];
    
    if (self.content == nil) {
        contentLabel.hidden = YES;
    }else {
        contentLabel.hidden = NO;
        self.content = [NSString stringWithFormat:@"%0.02f",[self.content floatValue]];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@元", self.content]];
        
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:40] range:NSMakeRange(0, self.content.length)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(self.content.length,1 )];
        contentLabel.attributedText = str;
    }
    
    float spaceW = 5;
    float perW = (contentView.frame.size.width - 30 - spaceW*5) /6;
    CGFloat calculateHight = 0;
    if (self.content == nil) {
        calculateHight = 30;
    }
    
    for (int i = 0; i<6; i++)
    {
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(15 + i*(spaceW + perW), contentView.frame.size.height - perW - 20 - calculateHight, perW, perW)];
        imageV.tag = i+1;
        imageV.contentMode = UIViewContentModeCenter;
        [contentView addSubview:imageV];
        CALayer * downButtonLayer = [imageV layer];
        [downButtonLayer setMasksToBounds:YES];
        [downButtonLayer setCornerRadius:5];
        [downButtonLayer setBorderWidth:1];
        [downButtonLayer setBorderColor:[speateLine.backgroundColor CGColor]];
    }
    
    respond = [[UITextField alloc] init];
    [self addSubview:respond];
    respond.keyboardType = UIKeyboardTypeNumberPad;
    [respond becomeFirstResponder];
       respond.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    
}


-(void)show{
    
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    contentView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    
    
    [UIView animateWithDuration:0.25 animations:^{
        
        contentView.transform = CGAffineTransformMakeScale(1.2,1.2);
        
        
    } completion:^(BOOL finished) {
        contentView.transform = CGAffineTransformIdentity;
    }];
    
}

-(void)dismiss{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [respond resignFirstResponder];
    [self removeFromSuperview];
  //  enterPasswordView = nil;
//    [UIView animateWithDuration:0.25 animations:^{
//        
//        contentView.transform = CGAffineTransformMakeScale(0.01, 0.01);
//        
//        
//    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
//        enterPasswordView = nil;
//    }];
}

-(void)clickClose{
    
    [self dismiss];
}

#pragma mark  UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSMutableString *str = [NSMutableString stringWithString:textField.text];
    if ([string isEqualToString:@""]) {
        [str replaceCharactersInRange:NSMakeRange(str.length - 1, 1) withString:@""];
    }
    else   [str appendString:string];
    
    if (str.length == cashPassowrdCount) {
        
        
          return YES;
   
    }
    if (str.length>cashPassowrdCount) {
        return NO;
    }
    
    return YES;
    
}


-(void)textChanged:(NSNotification*)nofity{
    
    if ([nofity object] == respond) {
        
  
    for (int i=0; i<cashPassowrdCount; i++) {
        
        int tag = i+1;
        UIImageView *imageV = [contentView viewWithTag:tag];
        if (imageV) {
            
            if (respond.text.length >=tag) imageV.image = [UIImage imageNamed:@"yuan"];
            else
            {
                imageV.image = nil;
                
                FLLog(@"---");
            }
            
        }
    }
    
    if (respond.text.length == cashPassowrdCount) {
        //[respond resignFirstResponder];
        self.compleBlock(respond.text);
        [self dismiss];
    }
          }
}

@end
