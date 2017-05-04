//
//  AddressViewController.m
//  LegendWorld
//
//  Created by Frank on 2016/12/21.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "AddressViewController.h"
#import "AddressTableViewCell.h"
#import "DetailAddressTableViewCell.h"
#import "CustomPickView.h"

@interface AddressViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak,nonatomic) UITextField *nameTF;
@property (weak,nonatomic) UITextField *phoneTF;
@property (weak,nonatomic) UITextField *provinceTF;
@property (weak,nonatomic) UITextField *zipCodeTF;
@property (weak,nonatomic) UITextView *detailTx;
@property (weak,nonatomic) UILabel *hideLab;

@property (strong, nonatomic) NSArray *nameArray;
@property (strong, nonatomic) NSArray *placeArray;

@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地址";
    self.nameArray = @[@"收货人姓名",@"手机号码",@"省、市、区",@"邮政编码",@"详细地址"];
    self.placeArray = @[@"请输入姓名",@"请输入手机号码",@"请选择省市区",@"请输入邮政编码",@"请输入详细地址"];
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.backgroundColor = viewColor;
    self.myTableView.separatorColor = tableDefSepLineColor;
    self.myTableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    self.myTableView.rowHeight = UITableViewAutomaticDimension;
    self.myTableView.estimatedRowHeight = 200;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 100)];
    footerView.backgroundColor = viewColor;
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(40, 60, DeviceMaxWidth-80, 40);
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn setBackgroundImage:[UIImage backgroundImageWithColor:mainColor] forState:UIControlStateNormal];
    saveBtn.layer.cornerRadius = 6;
    saveBtn.layer.masksToBounds = YES;
    [saveBtn addTarget:self action:@selector(clickSaveEvent) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:saveBtn];
    
    self.myTableView.tableFooterView = footerView;
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"AddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddressTableViewCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"DetailAddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"DetailAddressTableViewCell"];
    
    __weak typeof(self) weakSelf = self;
    self.backBarBtnEvent = ^{
        if ([weakSelf checkTextChange]) {
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"你的地址信息还未保存，确定要退出吗？" preferredStyle:UIAlertControllerStyleAlert];
            [alertView addAction:[UIAlertAction actionWithTitle:@"直接退出" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }]];
            [alertView addAction:[UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf clickSaveEvent];
            }]];
            [weakSelf presentViewController:alertView animated:YES completion:nil];
        }else {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    };
}

- (BOOL)checkTextChange{
    if (![self.nameTF.text isEqualToString:self.addressModel.consignee]) {
        if (!(self.nameTF.text.length == 0 && self.addressModel.consignee.length == 0)) {
            return YES;
        }
    }
    if (![self.phoneTF.text isEqualToString:self.addressModel.mobile]) {
        if (!(self.phoneTF.text.length == 0 && self.addressModel.mobile.length == 0)) {
            return YES;
        }
    }
    if (![self.provinceTF.text isEqualToString:self.addressModel.area]) {
        if (!(self.provinceTF.text.length == 0 && self.addressModel.area.length == 0)) {
            return YES;
        }
    }
    if (![self.zipCodeTF.text isEqualToString:self.addressModel.area_id]) {
        if (!(self.zipCodeTF.text.length == 0 && self.addressModel.area_id.length == 0)) {
            return YES;
        }
    }
    if (![self.detailTx.text isEqualToString:self.addressModel.address]) {
        if (!(self.detailTx.text.length == 0 && self.addressModel.address.length == 0)) {
            return YES;
        }
    }
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData {
    [self showHUDWithMessage:nil];
    NSDictionary *dic = @{@"device_id":[FrankTools getDeviceUUID],
                          @"token":[FrankTools getUserToken],
                          @"mobile":self.phoneTF.text,
                          @"consignee":self.nameTF.text,
                          @"area_id":self.zipCodeTF.text ? self.zipCodeTF.text : @"",
                          @"address":self.detailTx.text,
                          @"is_default":@"1"};
    NSMutableDictionary *muDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    if (self.addressModel.address_id != 0) {
        [muDic setObject:self.addressModel.address_id forKey:@"address_id"];
    }
    [MainRequest RequestHTTPData:PATHShop(@"api/Address/addOrUpdateAddress") parameters:muDic success:^(id responseData) {
        RecieveAddressModel *model = [RecieveAddressModel new];
        model.mobile = self.phoneTF.text;
        model.consignee = self.nameTF.text;
        model.area_id = self.zipCodeTF.text ? self.zipCodeTF.text : @"";
        model.address = self.detailTx.text;
        model.area = self.provinceTF.text;
        model.address_id = [NSString stringWithFormat:@"%@",[responseData objectForKey:@"address_id"]];
        [self showHUDWithResult:YES message:@"提交成功" completion:^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishAddOrEditAddress:)]) {
                [self.delegate didFinishAddOrEditAddress:model];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}


#pragma mark - UITableViewDelegate - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 15)];
    bgView.backgroundColor = viewColor;
    return bgView;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.nameArray.count-1) {
        DetailAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailAddressTableViewCell"];
        self.detailTx = cell.textTx;
        self.hideLab = cell.hideLab;
        self.detailTx.delegate = self;
        if (self.isEdit) {
            self.nameTF.text = self.addressModel.consignee;
            self.phoneTF.text = self.addressModel.mobile;
            self.provinceTF.text = self.addressModel.area;
            self.zipCodeTF.text = self.addressModel.area_id;
            self.detailTx.text = self.addressModel.address;
        }
        if (self.detailTx.text.length > 0 ) {
            cell.hideLab.hidden = YES;
        }else {
            cell.hideLab.hidden = NO;
        }
        return cell;
    }else {
        AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressTableViewCell"];
        cell.nameLab.text = self.nameArray[indexPath.row];
        cell.textValueTF.placeholder = self.placeArray[indexPath.row];
        cell.textValueTF.delegate = self;
        if (indexPath.row == 2) {
            cell.selectBtn.hidden = NO;
            cell.textValueTF.userInteractionEnabled = NO;
            [cell.selectBtn addTarget:self action:@selector(clickSelectEvent) forControlEvents:UIControlEventTouchUpInside];
        }else {
            cell.selectBtn.hidden = YES;
            cell.textValueTF.userInteractionEnabled = YES;
        }
        
        if (indexPath.row == 0) {
            self.nameTF = cell.textValueTF;
        }else if (indexPath.row == 1) {
            self.phoneTF = cell.textValueTF;
            self.phoneTF.keyboardType = UIKeyboardTypeNumberPad;
        }else if (indexPath.row == 2) {
            self.provinceTF = cell.textValueTF;
        }else if (indexPath.row == 3) {
            self.zipCodeTF = cell.textValueTF;
            self.zipCodeTF.keyboardType = UIKeyboardTypeNumberPad;
        }
        return cell;
    }
    
}

#pragma mark - UITextViewDelegate,UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.hideLab.hidden = YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (text.length > 0) {
        self.hideLab.hidden = YES;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length == 0) {
        self.hideLab.hidden = NO;
    }
}

#pragma mark - 点击事件
- (void)clickSelectEvent {
    __weak AddressViewController *weakSelf = self;
    [[CustomPickView getInstance] showProvicePick:self.addressModel.area_id valueChange:^(NSString *str, NSInteger component) {
        
    } select:^(id content) {
        RecieveAddressModel *model = content;
        weakSelf.addressModel.distrct = model.distrct;
        weakSelf.addressModel.provice = model.provice;
        weakSelf.addressModel.city = model.city;
        weakSelf.addressModel.area_id = model.area_id;
        weakSelf.addressModel.area = [NSString stringWithFormat:@"%@ %@ %@",model.provice,model.city,model.distrct];
        weakSelf.provinceTF.text = [NSString stringWithFormat:@"%@ %@ %@",model.provice,model.city,model.distrct];
        weakSelf.zipCodeTF.text = [NSString stringWithFormat:@"%@",model.area_id];
    } disSelect:^(id content) {
        
    }];
}

- (void)clickSaveEvent{
    if (self.nameTF.text.length <= 0) {
        [self showHUDWithResult:NO message:@"请输入姓名"];
        return;
    }
    if (self.phoneTF.text.length <= 0) {
        [self showHUDWithResult:NO message:@"请输入手机号码"];
        return;
    }
    if (![FrankTools isValidateMobile:self.phoneTF.text]) {
        [self showHUDWithResult:NO message:@"手机号码有误"];
        return;
    }
    if (self.provinceTF.text.length <= 0) {
        [self showHUDWithResult:NO message:@"请选择省市区"];
        return;
    }
    if (self.zipCodeTF.text.length <= 0) {
        [self showHUDWithResult:NO message:@"请输入邮政编码"];
        return;
    }
    if (self.detailTx.text.length <= 0) {
        [self showHUDWithResult:NO message:@"请输入详细地址"];
        return;
    }
    [self requestData];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
