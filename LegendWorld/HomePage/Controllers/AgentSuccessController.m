//
//  AgentSuccessController.m
//  LegendWorld
//
//  Created by ios-dev-01 on 16/10/11.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "AgentSuccessController.h"
#import "lhSymbolCustumButton.h"
#import "MainRequest.h"

@interface AgentSuccessController ()
{
    NSDictionary *dataDic;
}

@end

@implementation AgentSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付成功";
    [self requestData];
    [self initFrameView];
    
    __weak typeof (self)weakSelf = self;
    self.backBarBtnEvent = ^{
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    };
}

-(void)requestData{
    NSDictionary *dic = @{@"device_id":[FrankTools getDeviceUUID],
                          @"token":[FrankTools getUserToken]};
    [MainRequest RequestHTTPData:PATH(@"api/user/myShareInfo") parameters:dic success:^(id responseData) {
        FLLog(@"%@",responseData);
        dataDic = responseData;
    } failed:^(NSDictionary *errorDic) {
    }];
}

-(void)initFrameView{
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 168*widthRate)];
    imageView.backgroundColor = [UIColor lightGrayColor];
    [imageView setImage:imageWithName(@"agentSuccess.jpg")];
    [self.view addSubview:imageView];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = tableDefSepLineColor;
    [self.view addSubview:lineView];
    
    lineView.sd_layout
    .leftSpaceToView(self.view,15*widthRate)
    .topSpaceToView(imageView,22*widthRate)
    .rightSpaceToView(self.view,15*widthRate)
    .heightIs(1);
    
    UILabel *inviteLab = [UILabel new];
    inviteLab.text = @"马上邀请好友吧";
    inviteLab.textColor = contentTitleColorStr;
    inviteLab.font = [UIFont systemFontOfSize:13];
    inviteLab.textAlignment = NSTextAlignmentCenter;
    inviteLab.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:inviteLab];
    
    inviteLab.sd_layout
    .centerXEqualToView(lineView)
    .centerYEqualToView(lineView)
    .widthIs(130)
    .heightIs(20);
    
    NSArray * a = @[@"微信好友",@"QQ好友",@"短信"];
    CGFloat fxWith = (DeviceMaxWidth-20*widthRate)/3;
    for (int i = 0; i < 3; i++) {
        lhSymbolCustumButton * fxBtn = [[lhSymbolCustumButton alloc]initWithFrame2:CGRectMake(10*widthRate+fxWith*i, 400*widthRate, fxWith, 100*widthRate)];
        fxBtn.tag = i;
        NSString * str = [NSString stringWithFormat:@"fxImage%d",i];
        [fxBtn.imgBtn setImage:imageWithName(str) forState:UIControlStateNormal];
        fxBtn.tLabel.text = [a objectAtIndex:i];
        
        [fxBtn addTarget:self action:@selector(fxBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:fxBtn];
    }
}

-(void)fxBtnEvent:(UIButton *)button_{
    NSString *encode = [dataDic objectForKey:@"recommended_encode"];
    NSDictionary *dic = [dataDic objectForKey:@"share_info"];
    id shareImage = [dic objectForKey:@"code_thumb"];
    NSString *titleStr = [dic objectForKey:@"recommend"];
    NSString *url = [dic objectForKey:@"link"];
    NSString *content = [NSString stringWithFormat:@"%@我的推荐码是：%@",titleStr,encode];
    FLLog(@"%@",content);
    [[FrankTools sharedInstance] fxBtnEventOther:button_ image:shareImage conStr:content withUrlStr:url withTitleStr:titleStr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
