//
//  VerificationStateViewController.m
//  LegendWorld
//
//  Created by wenrong on 16/9/26.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "VerificationStateViewController.h"
#import "MainRequest.h"
#import "CertificationUploadViewController.h"
@interface VerificationStateViewController ()
@property (weak, nonatomic) IBOutlet UILabel *verificationStateLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *IDCardLab;
@property (weak, nonatomic) IBOutlet UIImageView *stateImage;
@property (weak, nonatomic) IBOutlet UIImageView *realNameStatusIma;
@end

@implementation VerificationStateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameLab.text = _realName;
    self.IDCardLab.text = [self.IDCardNum stringByReplacingCharactersInRange:NSMakeRange(3, 8) withString:@"********"];
    self.title = @"认证信息";
    switch ([self.state integerValue]) {
        case 0:
            self.realNameStatusIma.image = [UIImage imageNamed:@"realNameStatus"];
            self.verificationStateLab.text = @"待审核";
            break;
        case 1:
            self.realNameStatusIma.image = [UIImage imageNamed:@"realNameStatus"];
            self.verificationStateLab.text = @"审核中";
            break;
        case 2:
            self.realNameStatusIma.image = [UIImage imageNamed:@"realNameStatusDown"];
            self.verificationStateLab.text = @"已审核通过";
            break;
        case 3:
            self.realNameStatusIma.image = [UIImage imageNamed:@"realNameStatusUndown"];
            self.stateImage.hidden = NO;
            self.verificationStateLab.text = @"未审核通过";
            break;
        default:
            break;
    }
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)turnToVerificationVCAct:(UIButton *)sender {
    if ([self.state isEqualToString:@"3"]) {
        CertificationUploadViewController *certificationVC = [[CertificationUploadViewController alloc] init];
        certificationVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:certificationVC animated:YES];
    }

}
@end
