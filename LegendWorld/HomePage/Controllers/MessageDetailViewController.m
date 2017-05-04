//
//  MessageDetailViewController.m
//  LegendWorld
//
//  Created by wenrong on 16/9/22.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "MessageDetailViewController.h"
#import "Base64Util.h"

@interface MessageDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *messageDetailTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *messageDetailTitleTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *messageDetailContentLab;
@end

@implementation MessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息详情";
    self.view.backgroundColor = [UIColor whiteColor];
    self.messageDetailTitleLab.text = _model.title;
    self.messageDetailContentLab.text = _model.content;
    self.messageDetailTitleTimeLab.text = _model.effect_time;
    self.myWebView.backgroundColor = [UIColor whiteColor];
    self.myWebView.scrollView.backgroundColor = [UIColor whiteColor];
    __weak typeof (self)weakSelf = self;
    self.backBarBtnEvent = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [weakSelf.delegate headerRefreshing];
    };
    [self requestData];
}

-(void)requestData{
    NSDictionary *dic = @{@"token":[FrankTools getUserToken],
                          @"device_id":[FrankTools getDeviceUUID],
                          @"notice_id":_model.notice_id};
    [self showHUDWithMessage:nil];
    [MainRequest RequestHTTPData:PATH(@"api/notice/getNotice") parameters:dic success:^(id responseData) {
        FLLog(@"%@",responseData);
        NSString *htmlStr = [Base64Util decodeBase64:[NSString stringWithFormat:@"%@",[[responseData objectForKey:@"notice"] objectForKey:@"content"]]];
        NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
        [self.myWebView loadHTMLString:htmlStr baseURL:baseURL];
        [self hideHUD];
    } failed:^(NSDictionary *errorDic) {
        [self hideHUD];
    }];
}

@end
