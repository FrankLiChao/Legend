//
//  InviteViewController.m
//  LegendWorld
//
//  Created by ios-dev-01 on 16/9/20.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "InviteViewController.h"
#import "MainRequest.h"
#import "UIButton+WebCache.h"
#import "lhSymbolCustumButton.h"

@interface InviteViewController ()<RefreshingViewDelegate>

@property(nonatomic,weak)UIButton *erweima;
@property(nonatomic,weak)UILabel *recommended_label;
@property(nonatomic,strong)NSDictionary *share_info;
@property(nonatomic,strong)NSString *encode;

@end

@implementation InviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邀请好友";
    [self requestData];
    [self initFrameView];
}

- (void)requestData{
    NSDictionary *dic = @{@"device_id":[FrankTools getDeviceUUID],
                          @"token":[FrankTools getUserToken]};
    
    [self showHUD];
    [MainRequest RequestHTTPData:PATH(@"api/user/myShareInfo") parameters:dic success:^(id responseData) {
        [self hideHUD];
        self.share_info = [responseData objectForKey:@"share_info"];
        self.encode = [NSString stringWithFormat:@"%@",[responseData objectForKey:@"recommended_encode"]];
        [self.recommended_label setText:[NSString stringWithFormat:@"我的编号：%@",[responseData objectForKey:@"recommended_encode"]]];
        
        NSURL *url = [NSURL URLWithString:[self.share_info objectForKey:@"code_thumb"]];
        [self.erweima sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
        [self.erweima sd_setBackgroundImageWithURL:url forState:UIControlStateDisabled];
    } failed:^(NSDictionary *errorDic) {
        [self hideHUD];
        if ([self isReLogin:errorDic]) {
            [self popLoginView:self];
        } else {
            __weak typeof (self) weakSelf = self;
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"] completion:^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        }
    }];
}

#pragma mark - 登录刷新
-(void)refreshingUI{
    [self requestData];
}

-(void)initFrameView
{
    self.view.backgroundColor = viewColor;
    CGFloat hight = 64;
    if (iPhone6And7 || iPhone6And7plus) {
        hight += 43*widthRate;
    }else if (iPhone5) {
        hight += 20*widthRate;
    }else{
        hight += 10*widthRate;
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate,hight, DeviceMaxWidth-20*widthRate, 20*widthRate)];
    label.text = @"健康消费 快乐分享 轻松创富";
    label.textColor = contentTitleColorStr;
    [label setTextAlignment:NSTextAlignmentCenter];
    label.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:label];
    
    UILabel *titleLab = [UILabel new];
    titleLab.font = [UIFont systemFontOfSize:27];
    titleLab.text = @"年入100万很轻松";
    titleLab.textColor = contentTitleColorStr;
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLab];
    
    hight += 30*widthRate;
    
    titleLab.sd_layout
    .leftSpaceToView(self.view,10*widthRate)
    .widthIs(DeviceMaxWidth-20*widthRate)
    .topSpaceToView(label,10*widthRate)
    .heightIs(20);
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = contentTitleColorStr;
    [self.view addSubview:lineView];
    
    hight += 20+15*widthRate;
    
    lineView.sd_layout
    .leftSpaceToView(self.view,20*widthRate)
    .topSpaceToView(titleLab,15*widthRate)
    .rightSpaceToView(self.view,20*widthRate)
    .heightIs(1);
    
    NSString *titleStr = @"我在传说等你\n邀请好友扫描二维码立即获取收益";
    UILabel *lable = [UILabel new];
    lable.attributedText = [FrankTools setLineSpaceing:5 WithString:titleStr WithRange:NSMakeRange(0, titleStr.length)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.numberOfLines = 2;
    lable.font = [UIFont systemFontOfSize:15];
    lable.textColor = [UIColor colorFromHexRGB:@"656565"];
    [self.view addSubview:lable];
    
    if (iPhone6And7 || iPhone6And7plus) {
        lable.sd_layout
        .leftSpaceToView(self.view,15*widthRate)
        .topSpaceToView(lineView,28*widthRate)
        .rightSpaceToView(self.view,15*widthRate)
        .heightIs(50);
        
        hight += 28*widthRate+50;
    }else if (iPhone5){
        lable.sd_layout
        .leftSpaceToView(self.view,15*widthRate)
        .topSpaceToView(lineView,20*widthRate)
        .rightSpaceToView(self.view,15*widthRate)
        .heightIs(50);
        
        hight += 20*widthRate+50;
    }else{
        lable.sd_layout
        .leftSpaceToView(self.view,15*widthRate)
        .topSpaceToView(lineView,10*widthRate)
        .rightSpaceToView(self.view,15*widthRate)
        .heightIs(50);
        
        hight += 10*widthRate+50;
    }
    
    UIButton *erweima = [UIButton buttonWithType:UIButtonTypeCustom];
    [erweima setBackgroundColor:[UIColor clearColor]];
    [erweima addTarget:self action:@selector(saveImageToPhotos) forControlEvents:UIControlEventTouchUpInside];
    [erweima setEnabled:NO];
    self.erweima = erweima;
    [self.view addSubview:self.erweima];
    
    if (iPhone6And7 || iPhone6And7plus || iPhone5) {
        self.erweima.sd_layout
        .leftSpaceToView(self.view,(DeviceMaxWidth-180)/2)
        .topSpaceToView(lable,25*widthRate)
        .widthIs(180)
        .heightIs(180);
        
        hight += 25*widthRate+180;
    }else{
        self.erweima.sd_layout
        .leftSpaceToView(self.view,(DeviceMaxWidth-160)/2)
        .topSpaceToView(lable,10*widthRate)
        .widthIs(160)
        .heightIs(160);
        
        hight += 10*widthRate+160;
    }
    
    
    
    UILabel *recommended_label = [UILabel new];
    [recommended_label setText:@"我的邀请码："];
    [recommended_label setTextColor:mainColor];
    [recommended_label setTextAlignment:NSTextAlignmentCenter];
    [recommended_label setFont:[UIFont systemFontOfSize:16]];
    self.recommended_label = recommended_label;
    [self.view addSubview:self.recommended_label];
//    if (isAdShare) {
//        [recommended_label setHidden:YES];
//    }
    
    if (iPhone6And7 || iPhone6And7plus || iPhone5) {
        self.recommended_label.sd_layout
        .leftSpaceToView(self.view,15*widthRate)
        .topSpaceToView(erweima,25*widthRate)
        .rightSpaceToView(self.view,15*widthRate)
        .heightIs(20*widthRate);
    }else{
        self.recommended_label.sd_layout
        .leftSpaceToView(self.view,15*widthRate)
        .topSpaceToView(erweima,10*widthRate)
        .rightSpaceToView(self.view,15*widthRate)
        .heightIs(20*widthRate);
    }
    
    
    if (iPhone6And7 || iPhone6And7plus) {
        hight += 45*widthRate + 40*widthRate;
    }else if (iPhone5){
        hight += 45*widthRate +25*widthRate;
    }else {
        hight += 45*widthRate +0*widthRate;
    }
    
    NSArray * a = @[@"微信好友",@"QQ好友",@"短信"];
    CGFloat fxWith = (DeviceMaxWidth-20*widthRate)/3;
    for (int i = 0; i < 3; i++) {
        lhSymbolCustumButton * fxBtn = [[lhSymbolCustumButton alloc]initWithFrame2:CGRectMake(10*widthRate+fxWith*i, hight, fxWith, 100*widthRate)];
        fxBtn.tag = i;
        NSString * str = [NSString stringWithFormat:@"fxImage%d",i];
        [fxBtn.imgBtn setImage:imageWithName(str) forState:UIControlStateNormal];
        fxBtn.tLabel.text = [a objectAtIndex:i];
        
        [fxBtn addTarget:self action:@selector(clickShareAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:fxBtn];
    }
}

#pragma mark - 点击事件
- (void)clickShareAction:(UIButton *)button_{
    FLLog(@"点击分享");
    FLLog(@"%@",self.share_info);
    id shareImage = [self.share_info objectForKey:@"code_thumb"];
    NSString *titleStr = [self.share_info objectForKey:@"recommend"];
    NSString *url = [self.share_info objectForKey:@"link"];
    NSString *content = [NSString stringWithFormat:@"%@我的推荐码是：%@",titleStr,self.encode];
    FLLog(@"%@",content);
    [[FrankTools sharedInstance] fxBtnEventOther:button_ image:shareImage conStr:content withUrlStr:url withTitleStr:titleStr];
}

//存储图片到相册
- (void)saveImageToPhotos {
    FLLog(@"存储图片到相册");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
