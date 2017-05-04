//
//  AfterSaleViewController.m
//  LegendWorld
//
//  Created by 文荣 on 16/9/29.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "AfterSaleViewController.h"

@interface AfterSaleViewController () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation AfterSaleViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"售后服务";
    __weak typeof(self) weakSelf = self;
    self.backBarBtnEvent = ^{
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    };
    self.timeLabel.text = [NSString stringWithFormat:@"申请时间: %@",self.timeString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
- (IBAction)callPhoneEvent:(UIButton *)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:sender.currentTitle
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"呼叫", nil];
    [alert show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"呼叫"]) {
        [FrankTools detailPhone:self.phoneBtn.currentTitle];
    }
}

@end
