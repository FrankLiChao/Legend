//
//  DownAdverViewController.m
//  legend
//
//  Created by heyk on 16/1/26.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import "DownAdverViewController.h"

@interface DownAdverViewController ()

@end

@implementation DownAdverViewController

- (void)viewDidLoad {

    
    [self setActionButtonTitle:@"仅支持安卓用户" imageName:nil];
    self.bUnAvailable = YES;
    
    [super viewDidLoad];

    [self.actionButton addTarget:self action:@selector(clickDown:) forControlEvents:UIControlEventTouchUpInside];
    self.actionButton.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)clickDown:(UIButton*)button{
    if ([self.model.is_read boolValue] || [self.model.finish_percent intValue] == 100) {
        
        if ([self.model.is_seller boolValue] && self.model.goods_id) {
                [self checkGoodsDetail];
        }
        else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.model.shop_url]];
        }
    }
}

@end
