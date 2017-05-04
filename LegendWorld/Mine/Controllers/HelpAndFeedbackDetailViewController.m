//
//  HelpAndFeedbackDetailViewController.m
//  LegendWorld
//
//  Created by wenrong on 16/11/8.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "HelpAndFeedbackDetailViewController.h"
#import "Base64Util.h"

@interface HelpAndFeedbackDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIWebView *detailWebView;
@property (nonatomic, strong) NSString *htmlStr;
@end

@implementation HelpAndFeedbackDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"帮助详情";
    NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],@"token":[FrankTools getUserToken],@"help_id":@"1"};
    [self showHUDWithMessage:nil];
    [MainRequest RequestHTTPData:PATH(@"Api/Help/getHelpDetail") parameters:parameters success:^(id response) {
        self.htmlStr = [Base64Util decodeBase64:[[response objectForKey:@"help_info"] objectForKey:@"content"]];
        NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
        [self hideHUD];
        [self.detailWebView loadHTMLString:self.htmlStr baseURL:baseURL];
        self.titleLab.text = [[response objectForKey:@"help_info"] objectForKey:@"title"];
    } failed:^(NSDictionary *errorDic) {
        FLLog(@"errorDic ======= %@",errorDic);
        [self hideHUD];
    }];
}

@end
