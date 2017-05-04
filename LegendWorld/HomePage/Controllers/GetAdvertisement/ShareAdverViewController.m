//
//  ShareAdverViewController.m
//  legend
//
//  Created by heyk on 16/1/25.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import "ShareAdverViewController.h"
#import "AdverNetRequest.h"
#import "AdverNetRequest.h"

@interface ShareAdverViewController ()


@end

@implementation ShareAdverViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setActionButtonTitle:@"立即分享" imageName:@"share"];
    [self.actionButton addTarget:self action:@selector(clickShare:) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareSuccess) name:@"sharedSuccess" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark custom methods

-(void)clickShare:(UIButton*)button{
    if ([self.model.is_read boolValue] || [self.model.finish_percent intValue] == 100) {
        if ([self.model.is_seller boolValue] && self.model.goods_id) {
            [self checkGoodsDetail];
        }
        else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.model.shop_url]];
        }
    }
    else{
        NSString * imageStr = self.model.extra_img;
        NSString * urlStr = self.model.extra_url;
        NSString * conStr = @"传说，是互联网+时代给大众带来的创富机遇。带朋友看广告，就能赚大钱！";
        NSString * titilStr = self.model.extra_desc;
        [FrankTools fxViewAppear:imageStr conStr:conStr withUrlStr:urlStr withTitilStr:titilStr withVc:self isAdShare:nil];
    }
}

- (void)shareSuccess {
    NSLog(@"分享成功通知回调");
    __typeof(self) weakSelf = self;
    [AdverNetRequest advFinish:self.model answer:nil success:^(BOOL bSuccess, NSString *message) {
        [weakSelf showHUDWithResult:YES message:message];
        weakSelf.model.is_read = [NSNumber numberWithBool:YES];
        [weakSelf reloadUI];
    } failed:^(NSDictionary *errorDic) {
        [weakSelf showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

@end
