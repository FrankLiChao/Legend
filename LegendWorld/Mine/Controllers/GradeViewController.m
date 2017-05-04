//
//  GradeViewController.m
//  LegendWorld
//
//  Created by Frank on 2016/11/4.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "GradeViewController.h"
#import "GradeView.h"
#import "InviteFriendsView.h"

@interface GradeViewController ()

@property(weak,nonatomic)UIScrollView *myScrollView;
@property(strong,nonatomic)UserModel *userModel;
@property(strong,nonatomic)NSDictionary *qrCodeDic;
@property(weak,nonatomic)UIWebView  *myWebView;
@end

@implementation GradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"VIP等级";
    _userModel = [self getUserData];
    [self initFrameView];
}

-(void)initFrameView{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight-64)];
    _myScrollView = scrollView;
    _myScrollView.backgroundColor = [UIColor whiteColor];
    scrollView.showsVerticalScrollIndicator = NO;
    self.myScrollView = scrollView;
    [self.view addSubview:_myScrollView];
    
    UIImageView *headImage = [UIImageView new];
    [FrankTools setImgWithImgView:headImage withImageUrl:_userModel.photo_url withPlaceHolderImage:defaultUserHead];
    headImage.layer.cornerRadius = 75*widthRate/2;
    headImage.layer.masksToBounds = YES;
    [_myScrollView addSubview:headImage];
    
    headImage.sd_layout
    .leftSpaceToView(_myScrollView,15*widthRate)
    .topSpaceToView(_myScrollView,15*widthRate)
    .widthIs(75*widthRate)
    .heightEqualToWidth();
    
    NSString *gradeStr = [NSString stringWithFormat:@"mine_grade_v%ld",(long)[_userModel.honor_grade integerValue]];
    UIImageView *imageTag = [UIImageView new];
    [imageTag setImage:imageWithName(gradeStr)];
    imageTag.layer.cornerRadius = 13*widthRate;
    imageTag.layer.masksToBounds = YES;
    imageTag.layer.borderWidth = 2.5*widthRate;
    imageTag.layer.borderColor = [UIColor whiteColor].CGColor;
    [_myScrollView addSubview:imageTag];
    
    imageTag.sd_layout
    .rightEqualToView(headImage)
    .bottomEqualToView(headImage)
    .widthIs(26*widthRate)
    .heightEqualToWidth();
    
    UILabel *nameLab = [UILabel new];
    nameLab.text = self.vipModel.user_name;
    nameLab.font = [UIFont systemFontOfSize:15];
    nameLab.textColor = contentTitleColorStr1;
    [_myScrollView addSubview:nameLab];
    
    nameLab.sd_layout
    .leftSpaceToView(headImage,15*widthRate)
    .rightSpaceToView(_myScrollView,15*widthRate)
    .topSpaceToView(_myScrollView,25*widthRate)
    .heightIs(15);
    
    UILabel *nowGrade = [UILabel new];
    nowGrade.text = [NSString stringWithFormat:@"当前VIP等级：%@",self.vipModel.grade_name];
    nowGrade.font = [UIFont systemFontOfSize:14];
    nowGrade.textColor = contentTitleColorStr1;
    [_myScrollView addSubview:nowGrade];
    
    nowGrade.sd_layout
    .leftSpaceToView(headImage,15*widthRate)
    .rightSpaceToView(_myScrollView,15*widthRate)
    .heightIs(15)
    .topSpaceToView(nameLab,10);
    
    UILabel *needsLab = [UILabel new];
    needsLab.text = [NSString stringWithFormat:@"%@",self.vipModel.upgrade_desc];
    needsLab.textColor = contentTitleColorStr2;
    needsLab.font = [UIFont systemFontOfSize:13];
    needsLab.numberOfLines = 2;
    [_myScrollView addSubview:needsLab];
    
    needsLab.sd_layout
    .leftSpaceToView(headImage,15*widthRate)
    .topSpaceToView(nowGrade,10*widthRate)
    .rightSpaceToView(_myScrollView,10*widthRate)
    .heightIs(15);
    
    GradeView *gradeView = [[GradeView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 150)];
    gradeView.backgroundColor = [UIColor whiteColor];
    gradeView.tempVc = self;
    [_myScrollView addSubview:gradeView];
    gradeView.vipModel = self.vipModel;
    gradeView.sd_layout
    .topSpaceToView(headImage,25*widthRate);
    
//    UILabel *ruleTitle = [UILabel new];
//    ruleTitle.text = @"用户等级规则";
//    ruleTitle.font = [UIFont systemFontOfSize:16];
//    ruleTitle.textColor = contentTitleColorStr;
//    ruleTitle.textAlignment = NSTextAlignmentCenter;
//    [_myScrollView addSubview:ruleTitle];
//    
//    ruleTitle.sd_layout
//    .centerXEqualToView(_myScrollView)
//    .heightIs(20)
//    .topSpaceToView(gradeView,45*widthRate)
//    .widthIs(200);
    
    UIWebView *ruleView = [UIWebView new];
//    ruleView.scalesPageToFit = YES;
    ruleView.scrollView.showsVerticalScrollIndicator = NO;
    ruleView.backgroundColor = [UIColor whiteColor];
    self.myWebView = ruleView;
    [self.myScrollView addSubview:ruleView];
    
    ruleView.sd_layout
    .leftSpaceToView(_myScrollView,10)
    .rightSpaceToView(_myScrollView,10)
    .topSpaceToView(gradeView,45)
    .bottomEqualToView(_myScrollView);
    
    NSURL *url = [[NSURL alloc] initWithString:self.vipModel.vip_grade_rule];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.myWebView loadRequest:request];
    
//    UILabel *ruleLab = [UILabel new];
//    ruleLab.text = @"用户等级用户等级用户等级用户等级用户等级用户等级用户等级用户等级用户等级用户等级用户等级用户等级用户等级用户等级用户等级用户等级用户等级用户等级用户等级用户等级用户等级用户等级用户等级用户等级用户等级用户等级用户等级用户等级用户等级用户等级用户等级用户等级用户等级用户等级用户等级用户等级用户等级用户等级用户等级用户等级用户等级用户等级用户等级用户等级";
//    ruleLab.font = [UIFont systemFontOfSize:14];
//    ruleLab.textColor = contentTitleColorStr1;
//    [_myScrollView addSubview:ruleLab];
    
//    ruleLab.sd_layout
//    .leftSpaceToView(_myScrollView,15*widthRate)
//    .rightSpaceToView(_myScrollView,15*widthRate)
//    .topSpaceToView(ruleTitle,10*widthRate)
//    .autoHeightRatio(0);
    
    UIButton *invateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [invateBtn setTitle:@"邀请好友" forState:UIControlStateNormal];
    [invateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    invateBtn.backgroundColor = mainColor;
    invateBtn.layer.cornerRadius = 6;
    invateBtn.layer.masksToBounds = YES;
    [invateBtn addTarget:self action:@selector(clickInvateButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    invateBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_myScrollView addSubview:invateBtn];
    
    invateBtn.sd_layout
    .leftSpaceToView(_myScrollView,40*widthRate)
    .rightSpaceToView(_myScrollView,40*widthRate)
    .heightIs(40*widthRate)
    .yIs(DeviceMaxHeight-64-100);
}

-(void)clickInvateButtonEvent{
    NSDictionary *dic = @{@"device_id":[FrankTools getDeviceUUID],
                          @"token":[FrankTools getUserToken]};
    
    [self showHUD];
    [MainRequest RequestHTTPData:PATH(@"api/user/myShareInfo") parameters:dic success:^(id responseData) {
        [self hideHUD];
        self.qrCodeDic = responseData;
        InviteFriendsView *inviteView = [[InviteFriendsView alloc] initWithFrame:self.view.bounds];
        [[UIApplication sharedApplication].keyWindow addSubview:inviteView];
        [self refreshInvateView:inviteView];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

-(void)refreshInvateView:(InviteFriendsView *)invateView{
    invateView.dataDic = self.qrCodeDic;
    invateView.nameLab.text = _userModel.user_name;
    invateView.invateCode.text = [NSString stringWithFormat:@"我的邀请码：%@",[self.qrCodeDic objectForKey:@"recommended_encode"]];
    NSString *code_thumb = [NSString stringWithFormat:@"%@",[[self.qrCodeDic objectForKey:@"share_info"] objectForKey:@"code_thumb"]];
    [FrankTools setImgWithImgView:invateView.qrcodeIm withImageUrl:code_thumb];
    [FrankTools setImgWithImgView:invateView.headIm withImageUrl:_userModel.photo_url withPlaceHolderImage:defaultUserHead];
    NSString *imageStr = [NSString stringWithFormat:@"mine_grade_v%ld", (long)[[LoginUserManager sharedManager].loginUser.honor_grade integerValue]];
    [invateView.imageTag setImage:imageWithName(imageStr)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
