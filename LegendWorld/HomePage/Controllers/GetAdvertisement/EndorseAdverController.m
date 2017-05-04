//
//  EndorseAdverController.m
//  legend
//
//  Created by ios-dev on 16/5/13.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import "EndorseAdverController.h"
#import "EndorseProtrolController.h"

@interface EndorseAdverController ()

@end

@implementation EndorseAdverController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setActionButtonTitle:@"我要代言" imageName:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.actionButton addTarget:self action:@selector(clickAnswer:) forControlEvents:UIControlEventTouchUpInside];
    self.actionButton.hidden = YES;
}

-(void)clickAnswer:(UIButton*)button{
    if ([self.actionButton.titleLabel.text isEqualToString: @"我要代言"]) {
        EndorseProtrolController *epc = [[EndorseProtrolController alloc] init];
        epc.brand_id = self.brand_id;
        epc.ad_id = self.advId;
        [self.navigationController pushViewController:epc animated:YES];
        } else {
    }
}

@end
