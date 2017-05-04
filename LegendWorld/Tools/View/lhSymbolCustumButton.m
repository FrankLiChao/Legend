//
//  lhSymbolCustumButton.m
//  Drive
//
//  Created by Frank on 15/7/29.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import "lhSymbolCustumButton.h"

@implementation lhSymbolCustumButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.tLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.height-20, frame.size.width, 20)];
        self.tLabel.font = [UIFont systemFontOfSize:12];
        self.tLabel.textColor = contentTitleColorStr;
        self.tLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.tLabel];
    }
    return self;
}

- (instancetype)initWithFrame1:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.imgBtn.frame = CGRectMake((CGRectGetWidth(frame)-35*widthRate)/2, 18*widthRate, 35*widthRate, 35*widthRate);
        self.imgBtn.userInteractionEnabled = NO;
        [self addSubview:self.imgBtn];
        
        self.tLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 51*widthRate, CGRectGetWidth(frame), 30*widthRate)];
        self.tLabel.textAlignment = NSTextAlignmentCenter;
        self.tLabel.font = [UIFont systemFontOfSize:12];
        self.tLabel.textColor = contentTitleColorStr1;
        [self addSubview:self.tLabel];
    }
    return self;
}

- (instancetype)initWithFrame2:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.imgBtn.frame = CGRectMake((CGRectGetWidth(frame)-40*widthRate)/2, 15*widthRate, 40*widthRate, 40*widthRate);
        self.imgBtn.userInteractionEnabled = NO;
        [self addSubview:self.imgBtn];
        
        self.tLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 56*widthRate, CGRectGetWidth(frame), 30*widthRate)];
        self.tLabel.textAlignment = NSTextAlignmentCenter;
        self.tLabel.font = [UIFont systemFontOfSize:13];
        self.tLabel.textColor = contentTitleColorStr1;
        [self addSubview:self.tLabel];
    }
    return self;
}

- (instancetype)initWithFrame3:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.imgBtn.frame = CGRectMake((CGRectGetWidth(frame)-20)/2, 7, 20, 20);
        self.imgBtn.userInteractionEnabled = NO;
        [self addSubview:self.imgBtn];
        
        self.tLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, CGRectGetWidth(frame), 25)];
        self.tLabel.textAlignment = NSTextAlignmentCenter;
        self.tLabel.font = [UIFont systemFontOfSize:13];
        self.tLabel.textColor = contentTitleColorStr2;
        [self addSubview:self.tLabel];
    }
    return self;
}

@end
