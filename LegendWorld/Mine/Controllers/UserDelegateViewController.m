//
//  UserDelegateViewController.m
//  LegendWorld
//
//  Created by wenrong on 16/9/19.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "UserDelegateViewController.h"
#import "MainRequest.h"
@interface UserDelegateViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *userDelegateWebView;

@property (nonatomic) BOOL isAuth;
@property (nonatomic, strong) NSURL *url;

@end

@implementation UserDelegateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.sourceType == 1) {
        self.title = @"银联在线支付用户服务协议";
        self.url = [NSURL URLWithString:PATH(@"public/comm/unionPayAgreement.html")];
        NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
        [self.userDelegateWebView loadRequest:request];
        self.userDelegateWebView.delegate = self;
    } else if (self.sourceType == 2) {
        self.title = @"新手教程";
        self.url = [NSURL URLWithString:PATH(@"public/comm/novice.html")];
        NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
        [self.userDelegateWebView loadRequest:request];
        self.userDelegateWebView.delegate = self;
        [self showHUDWithMessage:nil];
    } else {
        self.title = @"用户协议";
        self.url = [NSURL URLWithString:PATH(@"public/comm/agreement.html")];
        NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
        [self.userDelegateWebView loadRequest:request];
        self.userDelegateWebView.delegate = self;
        [self showHUDWithMessage:nil];
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hideHUD];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString* scheme = [[request URL] scheme];
    NSLog(@"scheme = %@",scheme);
    //判断是不是https
    if ([scheme isEqualToString:@"https"]) {
        if (self.isAuth) {
            return YES;
        }
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:self.url] delegate:self];
        [conn start];
        [webView stopLoading];
        return NO;
    }
    return YES;
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge previousFailureCount]== 0) {
        self.isAuth = YES;
        //NSURLCredential 这个类是表示身份验证凭据不可变对象。凭证的实际类型声明的类的构造函数来确定。
        NSURLCredential* cre = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        [challenge.sender useCredential:cre forAuthenticationChallenge:challenge];
    }
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response {
    return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.isAuth = YES;
    [self.userDelegateWebView loadRequest:[NSURLRequest requestWithURL:self.url]];
    [connection cancel];
}

@end
