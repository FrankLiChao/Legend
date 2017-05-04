//
//  EndorseProtrolController.m
//  legend
//
//  Created by ios-dev on 16/5/10.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import "EndorseProtrolController.h"
#import "MainRequest.h"

@interface EndorseProtrolController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UIButton *wantEndorseBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wantBtnHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewBottom;

@end

@implementation EndorseProtrolController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"代言协议";
    [self setUI];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)setUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    NSString *url = [NSString stringWithFormat:@"%@/utility/endorse/endorseAgreement?brand_id=%@",RELSEASE_SYS_WEB_BASED_SHOP_URL,self.brand_id];
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    
    [self.wantEndorseBtn.titleLabel setFont:[UIFont systemFontOfSize:17*widthRate]];
//    self.wantBtnHeight.constant = KJL_X_FROM6(64.0);
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.webView.hidden = NO;
}
static UIViewController *vc;

- (IBAction)clickWantEndorse:(UIButton *)sender {
    [self showHUDWithMessage:@"正在验证你的资料完善度"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSDictionary *dic = @{@"brand_id":_brand_id?_brand_id:@"",
                              @"device_id":[FrankTools getDeviceUUID],
                              @"token":[FrankTools getUserToken]};
        [MainRequest RequestHTTPData:PATH(@"api/user/checkUserDataFinish") parameters:dic success:^(id responseData) {
            [self hideHUD];
            FLLog(@"%@",responseData);
            NSInteger data = 90;
            if (data >= 70) {
                if ([_buyMark integerValue] > 0) {
                    [self agreeProtocol];
                }else{
                    EndorseProtrolController *epvc = [[EndorseProtrolController alloc] init];
                    epvc.brand_id = self.brand_id;
                    epvc.ad_id = self.ad_id;
                    [self.navigationController pushViewController:epvc animated:YES];
                }
            } else {
                [self showHUDWithResult:NO message:[NSString stringWithFormat:@"你的资料完善度当前为%ld,需80才能代言",(long)data]];
            }
        } failed:^(NSDictionary *errorDic) {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }];
    });
}

-(void)agreeProtocol
{
    NSDictionary *dic = @{@"device_id":[FrankTools getDeviceUUID],
                          @"token":[FrankTools getUserToken],
                          @"brand_id":[NSString stringWithFormat:@"%@",_brand_id?_brand_id:@""]
                          };
    [MainRequest RequestHTTPData:PATHShop(@"api/Endorse/agreeProtocolAndEndorse") parameters:dic success:^(id responseData) {
        [self performSelector:@selector(popLastView) withObject:nil afterDelay:0.5];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

-(void)popLastView
{
    if ([_buyMark integerValue] == 1) {
        [self.navigationController popViewControllerAnimated:NO];
//        _myDelegate.is_checkEndorse = YES;
//        [_myDelegate attriButionSelect];
    }else if ([_buyMark integerValue] == 2){
        [self.navigationController popViewControllerAnimated:NO];
//        _myDelegate.is_checkEndorse = YES;
        [_myDelegate continueDealBuy];
    }
    
}

@end
