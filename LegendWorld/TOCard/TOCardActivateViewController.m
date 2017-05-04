//
//  TOCardActivateViewController.m
//  LegendWorld
//
//  Created by Tsz on 2016/12/8.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "TOCardActivateViewController.h"
#import "TOCardGuideViewController.h"

@interface TOCardActivateViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *activateCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation TOCardActivateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"TO卡";
    __weak typeof (self) weakSelf = self;
    self.backBarBtnEvent = ^{
        [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
    };
    
    self.activateCodeTF.textColor = [UIColor bodyTextColor];
    self.activateCodeTF.layer.borderColor = [UIColor themeColor].CGColor;
    self.activateCodeTF.layer.borderWidth = 1;
    self.activateCodeTF.layer.cornerRadius = 18;
    self.activateCodeTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入邀请码" attributes:@{NSForegroundColorAttributeName: [[UIColor themeColor] colorWithAlphaComponent:0.5]}];
    
    [self.nextBtn setBackgroundImage:[UIImage backgroundImageWithColor:[UIColor themeColor] cornerRadius:18] forState:UIControlStateNormal];
    [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [self.nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom
- (IBAction)nextBtnEvent:(id)sender {
    [self.activateCodeTF resignFirstResponder];
    if (self.activateCodeTF.text.trim.length <= 0) {
        [self showHUDWithResult:NO message:@"请输入邀请码"];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = @{@"device_id": [FrankTools getDeviceUUID], @"token": [FrankTools getUserToken], @"recommend_code": self.activateCodeTF.text.trim};
    [MainRequest RequestHTTPData:PATH(@"Api/User/activeTocardApp") parameters:param success:^(id response) {
        BOOL flag = [[response objectForKey:@"flag"] boolValue];
        if (flag) {
            [weakSelf showHUDWithResult:YES message:@"激活成功" completion:^{
                TOCardGuideViewController *guide = [[TOCardGuideViewController alloc] init];
                [weakSelf.navigationController pushViewController:guide animated:YES];
            }];
        } else {
            [weakSelf showHUDWithResult:NO message:@"激活失败"];
        }
    } failed:^(NSDictionary *errorDic) {
        [weakSelf showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSInteger length = textField.text.length - range.length + string.length;
    return length <= 5;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
