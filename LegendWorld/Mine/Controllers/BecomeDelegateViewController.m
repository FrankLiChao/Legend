//
//  BecomeDelegateViewController.m
//  LegendWorld
//
//  Created by Frank on 2016/11/4.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "BecomeDelegateViewController.h"
#import "AgreementViewController.h"

@interface BecomeDelegateViewController ()

@end

@implementation BecomeDelegateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"VIP等级";
    [self initFrameView];
}

-(void)initFrameView{
    UIImageView *titilIm = [UIImageView new];
    [titilIm setImage:imageWithName(@"mine_defaultdelegate")];
    [self.view addSubview:titilIm];
    
    titilIm.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.view,90)
    .widthIs(175*widthRate)
    .heightIs(150*widthRate);
    
    UILabel *textLab = [UILabel new];
    textLab.font = [UIFont systemFontOfSize:13];
    textLab.text = @"您目前尚未成为VIP用户，请先申请哦~";
    textLab.textColor = mainColor;
    textLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:textLab];
    
    textLab.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(titilIm,40*widthRate)
    .widthIs(DeviceMaxWidth-30)
    .heightIs(20);
    
    UIButton *invateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [invateBtn setTitle:@"申请成为VIP" forState:UIControlStateNormal];
    [invateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    invateBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    invateBtn.backgroundColor = mainColor;
    invateBtn.layer.cornerRadius = 6;
    invateBtn.layer.masksToBounds = YES;
    [invateBtn addTarget:self action:@selector(clickBecomeDelegate) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:invateBtn];
    
    invateBtn.sd_layout
    .leftSpaceToView(self.view,40*widthRate)
    .rightSpaceToView(self.view,40*widthRate)
    .heightIs(40)
    .yIs(DeviceMaxHeight-64-100);
    
}

-(void)clickBecomeDelegate{
    AgreementViewController *agreeVc = [AgreementViewController new];
    [self.navigationController pushViewController:agreeVc animated:YES];
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
