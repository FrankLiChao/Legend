//
//  CertificationViewController.m
//  LegendWorld
//
//  Created by wenrong on 16/9/14.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "CertificationUploadViewController.h"
#import "MainRequest.h"
#import "CertificationUploadImageViewController.h"
@interface CertificationUploadViewController ()<UITextFieldDelegate>

//真实姓名输入框
@property (weak, nonatomic) IBOutlet UITextField *realNameTF;
//身份证输入框
@property (weak, nonatomic) IBOutlet UITextField *IDCardTF;
//联系人姓名输入框
@property (weak, nonatomic) IBOutlet UITextField *conetctPersonNameTF;
//联系人电话输入框
@property (weak, nonatomic) IBOutlet UITextField *cellPhoneTF;
//身份证正面图片
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@end

@implementation CertificationUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化一些状态
    self.sendBtn.layer.cornerRadius = 6;
    self.sendBtn.layer.masksToBounds = YES;
    self.title = @"实名认证";
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.realNameTF.text.length > 0&&self.cellPhoneTF.text.length > 0&&self.conetctPersonNameTF.text.length > 0&&self.IDCardTF.text.length > 0) {
        self.sendBtn.enabled = YES;
        self.sendBtn.backgroundColor = mainColor;
    }
    else{
        self.sendBtn.enabled = NO;
        self.sendBtn.backgroundColor = [UIColor noteTextColor];
    }
}
- (IBAction)sendAct:(UIButton *)sender {
    if (self.realNameTF.text.length < 2||self.realNameTF.text.length > 6) {
        [self showHUDWithResult:NO message:@"请填写您的真实姓名,姓名长度2-6位"];
        return;
    }
    if (![FrankTools isValidateMobile:self.cellPhoneTF.text]) {
        [self showHUDWithResult:NO message:@"请填写联系人的电话号码"];
        return;
    }
    if (self.conetctPersonNameTF.text.length < 2||self.conetctPersonNameTF.text.length > 6) {
        [self showHUDWithResult:NO message:@"请填写联系人的姓名,姓名长度2-6位"];
        return;
    }
    if (![FrankTools isValidateIDNum:self.IDCardTF.text]) {
        [self showHUDWithResult:NO message:@"请填写正确的身份证号码"];
        return;
    }
    
    NSDictionary *dic = @{@"token":[FrankTools getUserToken],
                          @"device_id":[FrankTools getDeviceUUID],
                          @"real_name":[NSString stringWithFormat:@"%@",self.realNameTF.text],
                          @"ID_card":[NSString stringWithFormat:@"%@",self.IDCardTF.text],
                          @"emergency_contact_name":[NSString stringWithFormat:@"%@",self.conetctPersonNameTF.text],
                          @"emergency_contact_phone":[NSString stringWithFormat:@"%@",self.cellPhoneTF.text]};
    [self showHUDWithMessage:@"信息检查中"];
    [MainRequest RequestHTTPData:PATH(@"Api/user/checkRealNameAuth") parameters:dic success:^(id responseData) {
        [self hideHUD];
        CertificationUploadImageViewController *cretificationUploadImageVC = [[CertificationUploadImageViewController alloc] init];
        cretificationUploadImageVC.IDCardStr = self.IDCardTF.text;
        cretificationUploadImageVC.cellPhoneStr = self.cellPhoneTF.text;
        cretificationUploadImageVC.conetctPersonNameStr= self.conetctPersonNameTF.text;
        cretificationUploadImageVC.realNameStr = self.realNameTF.text;
        cretificationUploadImageVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:cretificationUploadImageVC animated:YES];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
    
}

@end
