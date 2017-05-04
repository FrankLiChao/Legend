//
//  InviteFriendsView.m
//  LegendWorld
//
//  Created by Frank on 2016/11/2.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "InviteFriendsView.h"
#import "lhSymbolCustumButton.h"

@interface InviteFriendsView ()

@end

@implementation InviteFriendsView

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
        .heightIs(500*widthRate);
        
        _headIm = [[UIImageView alloc] initWithFrame:CGRectMake(15*widthRate, 15*widthRate, 75*widthRate, 75*widthRate)];
        _headIm.layer.cornerRadius = 75/2*widthRate;
        [_headIm setImage:defaultUserHead];
        _headIm.layer.masksToBounds = YES;
        [alterView addSubview:_headIm];
        
        _imageTag = [UIImageView new];
        _imageTag.layer.cornerRadius = 13*widthRate;
        _imageTag.layer.masksToBounds = YES;
        _imageTag.userInteractionEnabled = YES;
        _imageTag.layer.borderWidth = 2.5*widthRate;
        _imageTag.layer.borderColor = [UIColor whiteColor].CGColor;
        [alterView addSubview:_imageTag];
        
        self.imageTag.sd_layout
        .rightEqualToView(_headIm)
        .bottomEqualToView(_headIm)
        .widthIs(26*widthRate)
        .heightEqualToWidth();
        
        _nameLab = [UILabel new];
        _nameLab.text = @"Frank";
        _nameLab.textColor = contentTitleColorStr1;
        _nameLab.font = [UIFont systemFontOfSize:15];
        [alterView addSubview:_nameLab];
        
        _nameLab.sd_layout
        .leftSpaceToView(_headIm,15*widthRate)
        .rightSpaceToView(alterView,15*widthRate)
        .topSpaceToView(alterView,30*widthRate)
        .heightIs(20*widthRate);
        
        _invateCode = [UILabel new];
        _invateCode.text = @"我的邀请码：AQP8B";
        _invateCode.font = [UIFont systemFontOfSize:15];
        _invateCode.textColor = contentTitleColorStr1;
        [alterView addSubview:_invateCode];
        
        _invateCode.sd_layout
        .leftEqualToView(_nameLab)
        .topSpaceToView(_nameLab,10*widthRate)
        .rightSpaceToView(alterView,15*widthRate)
        .heightIs(20*widthRate);
        
        _qrcodeIm = [UIImageView new];
        [_qrcodeIm setImage:imageWithName(placeSquareBigImg)];
        [alterView addSubview:_qrcodeIm];
        
        _qrcodeIm.sd_layout
        .centerXEqualToView(alterView)
        .topSpaceToView(_invateCode,40*widthRate)
        .widthIs(180*widthRate)
        .heightEqualToWidth();
        
        UILabel *lab = [UILabel new];
        lab.text = @"发送邀请码邀请好友";
        lab.textColor = contentTitleColorStr2;
        lab.font = [UIFont systemFontOfSize:13];
        lab.textAlignment = NSTextAlignmentCenter;
        [alterView addSubview:lab];
        
        lab.sd_layout
        .centerXEqualToView(alterView)
        .topSpaceToView(_qrcodeIm,30*widthRate)
        .widthIs(200)
        .heightIs(20*widthRate);
        
        NSArray * a = @[@"微信",@"QQ",@"短信"];
        CGFloat fxWith = (300*widthRate-20*widthRate)/3;
        for (int i = 0; i < 3; i++) {
            lhSymbolCustumButton * fxBtn = [[lhSymbolCustumButton alloc]initWithFrame2:CGRectMake(10*widthRate+fxWith*i, 0, fxWith, 100*widthRate)];
            fxBtn.tag = i;
            NSString * str = [NSString stringWithFormat:@"fxImage%d",i];
            [fxBtn.imgBtn setImage:imageWithName(str) forState:UIControlStateNormal];
            fxBtn.tLabel.text = [a objectAtIndex:i];
            
            [fxBtn addTarget:self action:@selector(clickShareAction:) forControlEvents:UIControlEventTouchUpInside];
            [alterView addSubview:fxBtn];
            
            fxBtn.sd_layout
            .topSpaceToView(lab,20*widthRate);
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

-(void)clickShareAction:(UIButton *)button_{
    NSDictionary *share_info = [self.dataDic objectForKey:@"share_info"];
    id shareImage = [share_info objectForKey:@"code_thumb"];
    NSString *titleStr = [share_info objectForKey:@"recommend"];
    NSString *url = [share_info objectForKey:@"link"];
    NSString *content = [NSString stringWithFormat:@"%@我的推荐码是：%@",titleStr,[_dataDic objectForKey:@"recommended_encode"]];
    FLLog(@"%@",content);
    [[FrankTools sharedInstance] fxBtnEventOther:button_ image:shareImage conStr:content withUrlStr:url withTitleStr:titleStr];
}

-(void)disAppearInvateView
{
    __block UIView * bgView = [self viewWithTag:1008611];
    __block UIView * alertView = [self viewWithTag:1008612];
    __weak typeof(self) ws = self;
    [UIView animateWithDuration:0.2 animations:^{
        bgView.alpha = 0;
//        alertView.transform = CGAffineTransformMakeScale(1.2, 1.2);
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
    [self disAppearInvateView];
}

@end
