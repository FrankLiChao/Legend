//
//  AddressManagerViewController.m
//  LegendWorld
//
//  Created by Frank on 2016/12/21.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "AddressManagerViewController.h"
#import "AddressViewController.h"
#import "AddressManageCell.h"

@interface AddressManagerViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) NSArray   *dataArray;

@end

@implementation AddressManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地址管理";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(clickAddAddressEvent)];
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.backgroundColor = viewColor;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.rowHeight = UITableViewAutomaticDimension;
    self.myTableView.estimatedRowHeight = 200;
    [self.myTableView registerNib:[UINib nibWithNibName:@"AddressManageCell" bundle:nil] forCellReuseIdentifier:@"AddressManageCell"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestData];
}

- (void)requestData {
    [self showHUDWithMessage:nil];
    NSDictionary *dic = @{@"device_id":[FrankTools getDeviceUUID],
                          @"token":[FrankTools getUserToken]};
    [MainRequest RequestHTTPData:PATHShop(@"api/Address/getAddressList") parameters:dic success:^(id responseData) {//RecieveAddressModel
        [self hideHUD];
        FLLog(@"%@",responseData);
        self.dataArray = [RecieveAddressModel parseArrayResponse:responseData];
        if (self.dataArray.count == 0) {
            self.myTableView.hidden = YES;
        }else {
            self.myTableView.hidden = NO;
            [self.myTableView reloadData];
        }
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

#pragma mark - UITableViewDelegate - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }else {
        return 10;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }else {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 10)];
        bgView.backgroundColor = viewColor;
        return bgView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RecieveAddressModel *model = self.dataArray[indexPath.section];
    if (self.delegate && [self.delegate respondsToSelector:@selector(modifyAddress:)]) {
        [self.delegate modifyAddress:model];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressManageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressManageCell"];
    RecieveAddressModel *model = self.dataArray[indexPath.section];
    cell.nameLab.text = model.consignee;
    cell.phoneLab.text = model.mobile;
    cell.addressLab.text = model.area;
    cell.detailAddrLab.text = model.address;
    if ([model.is_default integerValue] == 1) {
        cell.defaulBtn.selected = YES;
    }else {
        cell.defaulBtn.selected = NO;
    }
    cell.defaulBtn.tag = indexPath.section;
    cell.editBtn.tag = indexPath.section;
    cell.deleteBtn.tag = indexPath.section;
    [cell.defaulBtn addTarget:self action:@selector(clickDefaultAddressEvent:) forControlEvents:UIControlEventTouchUpInside];
    [cell.editBtn addTarget:self action:@selector(clickEditAddressEvent:) forControlEvents:UIControlEventTouchUpInside];
    [cell.deleteBtn addTarget:self action:@selector(clickDeleteAddressEvent:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark - 点击事件
- (void) clickAddAddressEvent {
    AddressViewController *addressVc = [AddressViewController new];
    [self.navigationController pushViewController:addressVc animated:YES];
}

- (void)clickDefaultAddressEvent:(UIButton *)button_{
    if (button_.selected) {
        return;
    }
    RecieveAddressModel *model = (RecieveAddressModel *)self.dataArray[button_.tag];
    [self showHUDWithMessage:nil];
    NSDictionary *dic = @{@"device_id":[FrankTools getDeviceUUID],
                          @"token":[FrankTools getUserToken],
                          @"mobile":model.mobile?model.mobile:@"",
                          @"consignee":model.consignee?model.consignee:@"",
                          @"area_id":model.area_id?model.area_id:@"",
                          @"address":model.address?model.address:@"",
                          @"is_default":@"1",
                          @"address_id":model.address_id
                          };
    [MainRequest RequestHTTPData:PATHShop(@"api/Address/addOrUpdateAddress") parameters:dic success:^(id responseData) {
        [self showHUDWithResult:YES message:@"修改成功"];
        [self requestData];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

- (void)clickEditAddressEvent:(UIButton *)button_{
    AddressViewController *addressVc = [AddressViewController new];
    addressVc.isEdit = YES;
    addressVc.addressModel = self.dataArray[button_.tag];
    [self.navigationController pushViewController:addressVc animated:YES];
}

- (void)clickDeleteAddressEvent:(UIButton *)button_{
    UIAlertController *alterView = [UIAlertController alertControllerWithTitle:nil message:@"确定删除地址" preferredStyle:UIAlertControllerStyleAlert];
    [alterView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    __weak typeof(self) weakSelf = self;
    [alterView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf showHUDWithMessage:nil];
        RecieveAddressModel *model = (RecieveAddressModel *)weakSelf.dataArray[button_.tag];
        NSString *address_id = [NSString stringWithFormat:@"%@",model.address_id ? model.address_id : @""];
        NSDictionary *dic = @{@"device_id":[FrankTools getDeviceUUID],
                              @"token":[FrankTools getUserToken],
                              @"address_id":address_id};
        [MainRequest RequestHTTPData:PATHShop(@"api/Address/deleteAddress") parameters:dic success:^(id responseData) {
            [weakSelf showHUDWithResult:YES message:@"删除成功"];
            [weakSelf requestData];
        } failed:^(NSDictionary *errorDic) {
            [weakSelf showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }];
    }]];
    [self presentViewController:alterView animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
