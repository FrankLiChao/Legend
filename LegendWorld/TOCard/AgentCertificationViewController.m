//
//  AgentCertificationViewController.m
//  LegendWorld
//
//  Created by Frank on 2016/12/12.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "AgentCertificationViewController.h"
#import "CertificationTableViewCell.h"
#import "UserRealAuthModel.h"
#import "AgentInforViewController.h"

@interface AgentCertificationViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mytableView;
@property (weak, nonatomic) UIButton *sureBtn;
@property (strong,nonatomic)NSArray *nameArray;
@property (strong,nonatomic)NSArray *placeArray;
@property (strong,nonatomic)UserRealAuthModel *userRealAuthModel;

@property (weak,nonatomic)UITextField *nameTextField;
@property (weak,nonatomic)UITextField *idCardTextField;
@property (weak,nonatomic)UITextField *qqTextField;
@property (weak,nonatomic)UITextField *mailTextField;
@property (weak,nonatomic)UITextField *cardTextField;
@property (weak,nonatomic)UITextField *openNameTextField;
@property (weak,nonatomic)UITextField *openTextField;
@property (weak,nonatomic)UITextField *childTextField;
@property (weak,nonatomic)UITextField *numberTextField;

@property (weak,nonatomic)UIButton *saveBtn;

@end

@implementation AgentCertificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"代理商认证";
    __weak typeof(self) weakSelf = self;
    self.backBarBtnEvent = ^{
        [weakSelf.view endEditing:YES];
        BOOL isChanged = [weakSelf textChangeCheck];
        if (isChanged) {
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前认证信息未保存，确认强制退出？" preferredStyle:UIAlertControllerStyleAlert];
            [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [alertView addAction:[UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }]];
            [weakSelf presentViewController:alertView animated:YES completion:nil];
        } else {
            if ([weakSelf.userRealAuthModel.status integerValue] == 2) { //开户失败点击返回
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
                return ;
            }
            if (weakSelf.buyPage) { //购买页面跳转而来
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }
    };
    if ([self.auth_status integerValue] == 2 || [self.auth_status integerValue] == 3) { //直接present过来的 无返回事件
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_image"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonClicked)];
    }
    self.nameArray = @[@[@"姓名",@"身份证"],
                       @[@"QQ",@"邮箱"],
                       @[@"卡号",@"开户名",@"开户行",@"支行名称",@"支行编号"]];
    
    self.placeArray = @[@[@"请输入本人姓名",@"请输入本人身份证号码"],
                        @[@"请输入QQ号",@"请输入邮箱号"],
                        @[@"请输入储蓄卡号",@"请输入开户名",@"请输入开户行",@"请输入支行名称",@"请输入支行编号"]];

    UIView *footer = [[UIView alloc] init];
    footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 80)];
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sureBtn = sureBtn;
    self.sureBtn.frame = CGRectMake(30, 20, DeviceMaxWidth - 60, 40);
    [self.sureBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self.sureBtn setBackgroundImage:[UIImage backgroundImageWithColor:[UIColor themeColor] cornerRadius:6] forState:UIControlStateNormal];
    [self.sureBtn addTarget:self action:@selector(clickSureButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    self.saveBtn = sureBtn;
    [footer addSubview:self.sureBtn];
    self.mytableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    self.mytableView.separatorColor = [UIColor seperateColor];
    [self.mytableView registerNib:[UINib nibWithNibName:@"CertificationTableViewCell" bundle:nil]
           forCellReuseIdentifier:@"CertificationTableViewCell"];
    self.mytableView.tableFooterView = footer;
    self.mytableView.backgroundColor = [UIColor clearColor];
    
    if ((self.agentTag || [self.auth_status integerValue] != 3) && !self.buyPage) { //1.未成为代理商用户不进行网络请求，2.从to卡购买页面跳转而来的不进行网络请求
        [self requestData];
    }
}

-(void)backBarButtonClicked{
    [self.view endEditing:YES];
    BOOL isChanged = [self textChangeCheck];
    if (isChanged) {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前认证信息未保存，确认强制退出？" preferredStyle:UIAlertControllerStyleAlert];
        [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertView addAction:[UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alertView animated:YES completion:nil];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (void)requestData{
    NSDictionary *dic = @{@"token":[FrankTools getUserToken],
                          @"device_id":[FrankTools getDeviceUUID]};
    [self showHUDWithMessage:nil];
    [MainRequest RequestHTTPData:PATHTOCard(@"User/getToAuthInfo") parameters:dic success:^(id responseData) {
        [self hideHUD];
        self.userRealAuthModel = [UserRealAuthModel parseUserRealAuthModel:responseData];
        if ([self.userRealAuthModel.status integerValue] == 2) {//开户失败
            UIAlertController *alterView = [UIAlertController alertControllerWithTitle:@"提示" message:self.userRealAuthModel.reason preferredStyle:UIAlertControllerStyleAlert];
            [alterView addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alterView animated:YES completion:nil];
            self.saveBtn.hidden = NO;
        }else {
            self.saveBtn.hidden = YES;
        }
        [self.mytableView reloadData];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

- (void)clickSureButtonEvent:(UIButton *)button_{
    if (self.nameTextField.text.length == 0) {
        [self showHUDWithResult:NO message:@"请输入您的姓名"];
        return;
    }
    if (self.idCardTextField.text.length == 0) {
        [self showHUDWithResult:NO message:@"请输入您的身份证号码"];
        return;
    }
    if (![FrankTools isValidateIDNum:self.idCardTextField.text]) {
        [self showHUDWithResult:NO message:@"您输入的身份证号码有误"];
        return;
    }
    if (self.qqTextField.text.length == 0) {
        [self showHUDWithResult:NO message:@"请输入您的QQ号码"];
        return;
    }
    if (self.mailTextField.text.length == 0) {
        [self showHUDWithResult:NO message:@"请输入您的邮箱号"];
        return;
    }
    if (self.cardTextField.text.length == 0) {
        [self showHUDWithResult:NO message:@"请输入您的卡号"];
        return;
    }
    if (self.openNameTextField.text.length == 0) {
        [self showHUDWithResult:NO message:@"请输入您的开户名"];
        return;
    }
    if (self.openTextField.text.length == 0) {
        [self showHUDWithResult:NO message:@"请输入您的开户行"];
        return;
    }
    if (self.childTextField.text.length == 0) {
        [self showHUDWithResult:NO message:@"请输入您银行卡的支行名称"];
        return;
    }
    if (self.numberTextField.text.length == 0) {
        [self showHUDWithResult:NO message:@"请输入您的支行编号"];
        return;
    }
    [self submitRealNameInfor];
}

- (BOOL)textChangeCheck {
    if (![self.userRealAuthModel.real_name isEqualToString:self.nameTextField.text]) {
        if (!(self.userRealAuthModel.real_name.length == 0 && self.nameTextField.text.length == 0)) {
            return YES;
        }
    }
    if (![self.userRealAuthModel.ID_card isEqualToString:self.idCardTextField.text]) {
        if (!(self.userRealAuthModel.ID_card.length == 0 && self.idCardTextField.text.length == 0)) {
            return YES;
        }
    }
    if (![self.userRealAuthModel.qq isEqualToString:self.qqTextField.text]) {
        if (!(self.userRealAuthModel.qq.length == 0 && self.qqTextField.text.length == 0)) {
            return YES;
        }
    }
    if (![self.userRealAuthModel.email isEqualToString:self.mailTextField.text]) {
        if (!(self.userRealAuthModel.email.length == 0 && self.mailTextField.text.length == 0)) {
            return YES;
        }
    }
    if (![self.userRealAuthModel.bank_card_no isEqualToString:self.cardTextField.text]) {
        if (!(self.userRealAuthModel.bank_card_no.length == 0 && self.cardTextField.text.length == 0)) {
            return YES;
        }
    }
    if (![self.userRealAuthModel.open_name isEqualToString:self.openNameTextField.text]) {
        if (!(self.userRealAuthModel.open_name.length == 0 && self.openNameTextField.text.length == 0)) {
            return YES;
        }
    }
    if (![self.userRealAuthModel.open_bank isEqualToString:self.openTextField.text]) {
        if (!(self.userRealAuthModel.open_bank.length == 0 && self.openTextField.text.length == 0)) {
            return YES;
        }
    }
    if (![self.userRealAuthModel.branch_bank_name isEqualToString:self.childTextField.text]) {
        if (!(self.userRealAuthModel.branch_bank_name.length == 0 && self.childTextField.text.length == 0)) {
            return YES;
        }
    }
    if (![self.userRealAuthModel.branch_bank_no isEqualToString:self.numberTextField.text]) {
        if (!(self.userRealAuthModel.branch_bank_no.length == 0 && self.numberTextField.text.length == 0)) {
            return YES;
        }
    }
    return NO;
}

- (void)submitRealNameInfor{
    NSDictionary *dic = @{@"token":[FrankTools getUserToken],
                          @"device_id":[FrankTools getDeviceUUID],
                          @"real_name":self.nameTextField.text,
                          @"ID_card":self.idCardTextField.text,
                          @"qq":self.qqTextField.text,
                          @"email":self.mailTextField.text,
                          @"open_name":self.openNameTextField.text,
                          @"open_bank":self.openTextField.text,
                          @"bank_card_no":self.cardTextField.text,
                          @"branch_bank_name":self.childTextField.text,
                          @"branch_bank_no":self.numberTextField.text};
    __weak typeof(self) weakSelf = self;
    [self showHUDWithMessage:@"提交中"];
    [MainRequest RequestHTTPData:PATHTOCard(@"User/toRealAuth") parameters:dic success:^(id responseData) {
        [self showHUDWithResult:YES message:[responseData objectForKey:@"msg"] completion:^{
            if (weakSelf.buyPage) {
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"] completion:nil];
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.nameArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sub = [self.nameArray objectAtIndex:section];
    return sub.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 10)];
    return footer;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CertificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CertificationTableViewCell"];
    cell.nameLab.text = self.nameArray[indexPath.section][indexPath.row];
    cell.inputTx.placeholder = self.placeArray[indexPath.section][indexPath.row];
    cell.inputTx.keyboardType = UIKeyboardTypeDefault;
    cell.inputTx.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor whiteColor];
    cell.tipBtn.hidden = YES;
    if (indexPath.section == 0 && indexPath.row == 0) {
        self.nameTextField = cell.inputTx;
        self.nameTextField.text = self.userRealAuthModel.real_name;
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        self.idCardTextField = cell.inputTx;
        self.idCardTextField.text = self.userRealAuthModel.ID_card;
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        self.qqTextField = cell.inputTx;
        self.qqTextField.text = self.userRealAuthModel.qq;
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        self.mailTextField = cell.inputTx;
        self.mailTextField.text = self.userRealAuthModel.email;
    } else if (indexPath.section == 2 && indexPath.row == 0) {
        self.cardTextField = cell.inputTx;
        self.cardTextField.text = self.userRealAuthModel.bank_card_no;
        self.cardTextField.keyboardType = UIKeyboardTypeNumberPad;
    } else if (indexPath.section == 2 && indexPath.row == 1) {
        self.openNameTextField = cell.inputTx;
        self.openNameTextField.text = self.userRealAuthModel.open_name;
    } else if (indexPath.section == 2 && indexPath.row == 2) {
        self.openTextField = cell.inputTx;
        self.openTextField.text = self.userRealAuthModel.open_bank;
    } else if (indexPath.section == 2 && indexPath.row == 3) {
        self.childTextField = cell.inputTx;
        self.childTextField.text = self.userRealAuthModel.branch_bank_name;
    } else if (indexPath.section == 2 && indexPath.row == 4) {
        cell.tipBtn.hidden = NO;
        self.numberTextField = cell.inputTx;
        self.numberTextField.text = self.userRealAuthModel.branch_bank_no;
        self.numberTextField.keyboardType = UIKeyboardTypeNumberPad;
        [cell.tipBtn addTarget:self action:@selector(clickTipButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    if (self.agentTag && [self.userRealAuthModel.status integerValue] != 2) {//开户失败可编辑
        cell.inputTx.userInteractionEnabled = NO;
        cell.tipBtn.hidden = YES;
    }else {
        cell.inputTx.userInteractionEnabled = YES;
    }
    return cell;
}

-(void)clickTipButtonEvent{
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"获取支行编号可拨打储蓄卡背面银行电话进行查询" message:@"" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alterView show];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSInteger length = textField.text.length - range.length + string.length;
    if (textField == self.nameTextField && length > 10) {
        return NO;
    }
    if (textField == self.idCardTextField && length > 18) {
        return NO;
    }
    if (textField == self.qqTextField && length > 15) {
        return NO;
    }
    if (textField == self.mailTextField && length > 30) {
        return NO;
    }
    if (textField == self.cardTextField && length > 19) {
        return NO;
    }
    if (textField == self.openNameTextField && length > 6) {
        return NO;
    }
    if (textField == self.openTextField && length > 20) {
        return NO;
    }
    if (textField == self.childTextField && length > 20) {
        return NO;
    }
    if (textField == self.numberTextField && length > 20) {
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
