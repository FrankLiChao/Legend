//
//  AboutUsViewController.m
//  LegendWorld
//
//  Created by wenrong on 16/9/19.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *versionLab;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    NSString *versionStr = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    self.versionLab.text = [NSString stringWithFormat:@"版本号:%@",versionStr?versionStr:@"3.0.0"];
}


@end
