//
//  ChooseView.m
//  LegendWorld
//
//  Created by Frank on 2016/11/10.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "ChooseView.h"

@implementation ChooseView

-(instancetype)initWithFrame:(CGRect)frame{
    self =  [super initWithFrame:frame];
    if (self) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight)];
        bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        bgView.tag = 1008611;
        [self addSubview:bgView];
        
        UIView *alterView = [UIView new];
        alterView.backgroundColor = [UIColor whiteColor];
        alterView.layer.cornerRadius = 6;
        alterView.tag = 1008612;
        [bgView addSubview:alterView];
        
        alterView.sd_layout
        .centerXEqualToView(bgView)
        .centerYEqualToView(bgView)
        .widthIs(300*widthRate)
        .heightIs(150*widthRate);
        
        NSArray * nameArray = @[@"广告收益1",@"广告收益2",@"广告收益3",@"支付分润1",@"支付分润2"];
        CGFloat fxWith = 80*widthRate;
        CGFloat hight = 0;
        for (int i = 0; i < nameArray.count; i++) {
            UIButton * selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            selectBtn.tag = i;
            selectBtn.selected = NO;
            selectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            selectBtn.layer.borderWidth = 0.5;
            selectBtn.layer.borderColor = contentTitleColorStr2.CGColor;
            [selectBtn setTitle:nameArray[i] forState:UIControlStateNormal];
            [selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [selectBtn setTitleColor:contentTitleColorStr1 forState:UIControlStateNormal];
            [selectBtn addTarget:self action:@selector(clickSelectEvent:) forControlEvents:UIControlEventTouchUpInside];
            [alterView addSubview:selectBtn];
            
            selectBtn.sd_layout
            .leftSpaceToView(alterView,15*widthRate+(fxWith+15*widthRate)*(i%3))
            .widthIs(fxWith)
            .heightIs(30*widthRate)
            .topSpaceToView(alterView,30*widthRate + hight);
            
            if (i == 2) {
                hight = 50*widthRate;
            }
        }
        
        //动画效果
        bgView.alpha = 0;
        alterView.alpha = 0;
        alterView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        [UIView animateWithDuration:0.2 animations:^{
            bgView.alpha = 1;
            alterView.transform = CGAffineTransformMakeScale(1, 1);
            alterView.alpha = 1;
            
        }completion:^(BOOL finished) {
        }];
    }
    return self;
}

-(void)clickSelectEvent:(UIButton *)button_{
    button_.selected = !button_.selected;
    if (button_.selected) {
        button_.backgroundColor = mainColor;
    }else{
        button_.backgroundColor = [UIColor whiteColor];
    }
    [self.delegate ChooseTypeEvet:button_.tag];
    [self disAppearSelectView];
}

-(void)disAppearSelectView
{
    __block UIView * bgView = [self viewWithTag:1008611];
    __block UIView * alertView = [self viewWithTag:1008612];
    __weak typeof(self) ws = self;
    [UIView animateWithDuration:0.2 animations:^{
        bgView.alpha = 0;
        alertView.alpha = 0;
    }completion:^(BOOL finished) {
        [bgView removeFromSuperview];
        [alertView removeFromSuperview];
        [ws removeFromSuperview];
        bgView = nil;
        alertView = nil;
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self disAppearSelectView];
}

@end
