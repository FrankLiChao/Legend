//
//  WithdrawResultViewController.m
//  LegendWorld
//
//  Created by Frank on 2016/11/10.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "WithdrawResultViewController.h"
#import "MyWalletViewController.h"

@interface WithdrawResultViewController ()

@end

@implementation WithdrawResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现结果";
    self.view.backgroundColor =  viewColor;
    [self initFrameView];
    
    __weak typeof(self) weakSelf = self;
    self.backBarBtnEvent = ^{
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    };
}

-(void)initFrameView{
    UIImageView *logoIm = [UIImageView new];
    [logoIm setImage:imageWithName(@"mine_tixianjieguo")];
    logoIm.layer.cornerRadius = 50*widthRate;
    logoIm.layer.masksToBounds = YES;
    [self.view addSubview:logoIm];
    
    logoIm.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.view,25*widthRate)
    .widthIs(100*widthRate)
    .heightEqualToWidth();
    
    UILabel *statusLab = [UILabel new];
    statusLab.text = @"提现申请已提交";
    statusLab.textColor = contentTitleColorStr1;
    statusLab.font = [UIFont systemFontOfSize:18];
    statusLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:statusLab];
    
    statusLab.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(logoIm,25*widthRate)
    .widthIs(DeviceMaxWidth-30*widthRate)
    .heightIs(20);
    
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    bgView.sd_layout
    .xIs(0)
    .topSpaceToView(statusLab,20*widthRate)
    .widthIs(DeviceMaxWidth)
    .heightIs(80);
    
    UILabel *nameL = [UILabel new];
    nameL.text = @"银行卡";
    nameL.textColor = contentTitleColorStr1;
    nameL.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:nameL];
    if (self.isWx) {
        nameL.text = @"微信";
    }
    
    nameL.sd_layout
    .leftSpaceToView(bgView,15*widthRate)
    .topEqualToView(bgView)
    .widthIs(100)
    .heightIs(40);
    
    UILabel *detailLab = [UILabel new];
    detailLab.text = [NSString stringWithFormat:@"%@",self.bankDetail];
    detailLab.textColor = contentTitleColorStr1;
    detailLab.font = [UIFont systemFontOfSize:16];
    detailLab.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:detailLab];
    
    detailLab.sd_layout
    .rightSpaceToView(bgView,15*widthRate)
    .topEqualToView(bgView)
    .widthIs(250)
    .heightIs(40);
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = tableDefSepLineColor;
    [bgView addSubview:lineView];
    
    lineView.sd_layout
    .leftSpaceToView(bgView,15*widthRate)
    .rightSpaceToView(bgView,15*widthRate)
    .topSpaceToView(bgView,40-0.5)
    .heightIs(0.5);
    
    UILabel *mLab = [UILabel new];
    mLab.text = @"提现金额";
    mLab.textColor = contentTitleColorStr1;
    mLab.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:mLab];
    
    mLab.sd_layout
    .leftEqualToView(nameL)
    .topSpaceToView(lineView,0)
    .widthIs(100)
    .heightIs(40);
    
    UILabel *moneyLab = [UILabel new];
    moneyLab.text = [NSString stringWithFormat:@"¥%@",self.moneyStr];
    moneyLab.textColor = contentTitleColorStr1;
    moneyLab.font = [UIFont systemFontOfSize:16];
    moneyLab.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:moneyLab];
    
    moneyLab.sd_layout
    .rightSpaceToView(bgView,15*widthRate)
    .topSpaceToView(lineView,0)
    .widthIs(250)
    .heightIs(40);
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [sureBtn setTitle:@"完成" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(clickSureButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.layer.cornerRadius = 6;
    sureBtn.layer.masksToBounds = YES;
    sureBtn.backgroundColor = mainColor;
    
    [self.view addSubview:sureBtn];
    
    sureBtn.sd_layout
    .leftSpaceToView(self.view,40*widthRate)
    .rightSpaceToView(self.view,40*widthRate)
    .topSpaceToView(bgView,60*widthRate)
    .heightIs(40);
}

-(void)clickSureButtonEvent{//MyWalletViewController
    NSArray *controllers = self.navigationController.viewControllers;
    for (UIViewController *vc in controllers) {
        if ([vc isKindOfClass:[MyWalletViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
        
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
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
