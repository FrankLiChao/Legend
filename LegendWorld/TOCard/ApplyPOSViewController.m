//
//  ApplyPOSViewController.m
//  LegendWorld
//
//  Created by Tsz on 2016/12/28.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "ApplyPOSViewController.h"
#import "AddressManagerViewController.h"
#import "AddressViewController.h"
#import "ApplyRecordViewController.h"
#import "POSAgreementViewController.h"

#import "OrderConfirmAddressHeaderView.h"
#import "ApplyPOSTableViewCell.h"
#import "ApplyRecordViewController.h"

@interface ApplyPOSViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, AddressManagerViewControllerDelegate, AddressViewControllerDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIButton *applyBtn;

@property (nonatomic) NSInteger currentCount;
@property (nonatomic, strong) RecieveAddressModel *address;
@property (nonatomic, strong) GoodsModel *posGoods;
@property (nonatomic) NSInteger maxApplyCount;

@end

@implementation ApplyPOSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"申请确认";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"申请记录" style:UIBarButtonItemStylePlain target:self action:@selector(applyRecords:)];
    __weak typeof (self) weakSelf = self;
    self.backBarBtnEvent = ^{
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    };
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView = tableView;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.allowsSelection = NO;
    self.tableView.rowHeight = 265;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 50, 0);
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderConfirmAddressHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"OrderConfirmAddressHeaderView"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ApplyPOSTableViewCell" bundle:nil] forCellReuseIdentifier:@"ApplyPOSTableViewCell"];
    [self.view addSubview:self.tableView];
    
    UIButton *applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.applyBtn = applyBtn;
    self.applyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.applyBtn setTitle:@"立即申请" forState:UIControlStateNormal];
    [self.applyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.applyBtn setBackgroundImage:[UIImage backgroundImageWithColor:[UIColor themeColor]] forState:UIControlStateNormal];
    [self.applyBtn setBackgroundImage:[UIImage backgroundImageWithColor:[UIColor noteTextColor]] forState:UIControlStateDisabled];
    [self.applyBtn addTarget:self action:@selector(applyEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.applyBtn];
    
    [self loadData];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
    self.applyBtn.frame = CGRectMake(0, CGRectGetMaxY(self.view.bounds) - 50, CGRectGetWidth(self.view.bounds), 50);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom
- (void)loadData {
    [self showHUD];
    NSDictionary *dic = @{@"device_id": [FrankTools getDeviceUUID], @"token": [FrankTools getUserToken]};
    [MainRequest RequestHTTPData:PATHTOCard(@"Pos/getPosApplyInfo") parameters:dic success:^(id response) {
        if ([[response objectForKey:@"address_id"] integerValue] != 0) {
            self.address = [RecieveAddressModel mj_objectWithKeyValues:[response objectForKey:@"address"]];
        }
        self.posGoods = [GoodsModel parsePOSResponse:[response objectForKey:@"goods_info"]];
        self.maxApplyCount = [[response objectForKey:@"allow_max_buy"] integerValue];
        self.currentCount = 1;
        [self.tableView reloadData];
        [self hideHUD];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

- (void)tapAddressView:(UITapGestureRecognizer *)sender {
    if (self.address) {
        AddressManagerViewController *manageAddress = [[AddressManagerViewController alloc] init];
        manageAddress.delegate = self;
        [self.navigationController pushViewController:manageAddress animated:YES];
    } else {
        AddressViewController *addAddress = [[AddressViewController alloc] init];
        addAddress.delegate = self;
        [self.navigationController pushViewController:addAddress animated:YES];
    }
}

- (void)applyEvent:(id)sender {
    if (self.currentCount <= 0) {
        [self showHUDWithResult:NO message:@"申请数量不能为0"];
        return;
    }
    if (self.address == nil) {
        [self showHUDWithResult:NO message:@"请选择收货地址"];
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定申请POS机使用？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)applyRecords:(id)sender {
    ApplyRecordViewController *applyRecordVc = [ApplyRecordViewController new];
    [self.navigationController pushViewController:applyRecordVc animated:YES];
}

- (void)plusBtnEvent:(UIButton *)sender {
    if (self.currentCount >= self.maxApplyCount) {
        [self showHUDWithResult:NO message:[NSString stringWithFormat:@"你本次最多可申请%ld台",self.maxApplyCount]];
        return;
    }
    self.currentCount++;
    [self.tableView reloadData];
}

- (void)minusBtnEvent:(UIButton *)sender {
    if (self.currentCount <= 1) {
        return;
    }
    self.currentCount--;
    [self.tableView reloadData];
}

- (void)agreeBtnEvent:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    self.applyBtn.enabled = sender.isSelected;
}

- (void)applyDelegateBtnEvent:(UIButton *)sender {
    POSAgreementViewController *agree = [[POSAgreementViewController alloc] init];
    agree.isApplyViewController = YES;
    [self.navigationController pushViewController:agree animated:YES];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.posGoods) {
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.address ? 80 : 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    OrderConfirmAddressHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"OrderConfirmAddressHeaderView"];
    header.contentView.backgroundColor = [UIColor whiteColor];
    //    header.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tapAddress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAddressView:)];
    [header addGestureRecognizer:tapAddress];
    if (self.address) {
        header.noAddressLabel.hidden = YES;
        header.consigneeLabel.hidden = NO;
        header.addressLabel.hidden = NO;
        
        header.consigneeLabel.text = [NSString stringWithFormat:@"收货人：%@", self.address.consignee];
        header.addressLabel.text = [NSString stringWithFormat:@"收货地址：%@ %@",self.address.area,self.address.address];
    } else {
        header.noAddressLabel.hidden = NO;
        header.consigneeLabel.hidden = YES;
        header.addressLabel.hidden = YES;
    }
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ApplyPOSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ApplyPOSTableViewCell"];
    [cell.posImageView sd_setImageWithURL:[NSURL URLWithString:self.posGoods.goods_thumb] placeholderImage:placeHolderImg];
    cell.posLabel.text = self.posGoods.goods_name;
    cell.posCount.text = [NSString stringWithFormat:@"%ld", (long)self.currentCount];
    cell.freight.text = @"到付";
    cell.posPrice.text = [NSString stringWithFormat:@"¥%@", self.posGoods.price];
    cell.posOldPrice.text = [NSString stringWithFormat:@"¥%@", self.posGoods.shop_price];
    [cell.plusBtn addTarget:self action:@selector(plusBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [cell.minusBtn addTarget:self action:@selector(minusBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [cell.agreeBtn addTarget:self action:@selector(agreeBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [cell.applyDelegateBtn addTarget:self action:@selector(applyDelegateBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)modifyAddress:(RecieveAddressModel *)address {
    self.address = address;
    [self.tableView reloadData];
}

- (void)didFinishAddOrEditAddress:(RecieveAddressModel *)address {
    self.address = address;
    [self.tableView reloadData];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"确定"]) {
        [self showHUD];
        NSDictionary *dic = @{@"device_id": [FrankTools getDeviceUUID], @"token": [FrankTools getUserToken], @"number": @(self.currentCount), @"address_id": self.address.address_id};
        [MainRequest RequestHTTPData:PATHTOCard(@"Pos/posApply") parameters:dic success:^(id response) {
            __weak typeof (self) weakSelf = self;
            [self showHUDWithResult:YES message:@"申请成功, 后台审核通过后为您发货" completion: ^{
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }];
        } failed:^(NSDictionary *errorDic) {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }];
    }
}

@end
