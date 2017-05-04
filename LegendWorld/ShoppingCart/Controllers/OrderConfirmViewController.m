//
//  OrderConfirmViewController.m
//  LegendWorld
//
//  Created by Tsz on 2016/11/7.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "OrderConfirmViewController.h"
#import "PayMethodViewController.h"
#import "OrderConfirmAddressHeaderView.h"
#import "OrderConfirmBottomView.h"
#import "OrderConfirmTableViewCell.h"
#import "AddressViewController.h"
#import "AddressManagerViewController.h"

@interface OrderConfirmViewController () <UITableViewDelegate, UITableViewDataSource, OrderConfirmTableViewCellDelegate, AddressManagerViewControllerDelegate, AddressViewControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, weak) OrderConfirmBottomView *bottomView;
@end

@implementation OrderConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单确认";
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView = tableView;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.allowsSelection = NO;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 50, 0);
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderConfirmAddressHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"OrderConfirmAddressHeaderView"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderConfirmTableViewCell" bundle:nil] forCellReuseIdentifier:@"OrderConfirmTableViewCell"];
    [self.view addSubview:self.tableView];
    
    OrderConfirmBottomView *bottomView = [[[NSBundle mainBundle] loadNibNamed:@"OrderConfirmBottomView" owner:self options:nil] firstObject];
    self.bottomView = bottomView;
    self.bottomView.totalPriceLabel.text = [NSString stringWithFormat:@"¥%@",self.orderPrice];
    [self.bottomView.buyNowBtn setBackgroundImage:[UIImage backgroundImageWithColor:[UIColor themeColor]] forState:UIControlStateNormal];
    [self.bottomView.buyNowBtn setBackgroundImage:[UIImage backgroundImageWithColor:[UIColor noteTextColor]] forState:UIControlStateDisabled];
    [self.bottomView.buyNowBtn addTarget:self action:@selector(submitOrder:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.bottomView];
    
    [self updateUI];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;
    self.bottomView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - 50, CGRectGetWidth(self.view.bounds), 50);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Event
- (void)updateUI {
    self.bottomView.buyNowBtn.enabled = self.address != nil;
    [self.tableView reloadData];
}

- (void)tapAddressView:(UITapGestureRecognizer *)sender {
    if (self.addressFlag) {
        AddressManagerViewController *manageAddress = [[AddressManagerViewController alloc] init];
        manageAddress.delegate = self;
        [self.navigationController pushViewController:manageAddress animated:YES];
    } else {
        AddressViewController *addAddress = [[AddressViewController alloc] init];
        addAddress.delegate = self;
        [self.navigationController pushViewController:addAddress animated:YES];
    }
}

- (void)submitOrder:(id)sender {
    BOOL haveEndorseGoods = NO;
    for (OrderItemModel *item in self.orderItems) {
        if (haveEndorseGoods) {
            break;
        }
        for (GoodsModel *goods in item.goods_list) {
            if ([goods.is_endorse boolValue]) {
                haveEndorseGoods = YES;
                break;
            }
        }
    }
    if (haveEndorseGoods && [[self getUserData].honor_grade integerValue] > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"该订单中可包含代言商品，是否选择代言？" message:@"代言后，可代言商品不可申请退货！\n不代言，即不参与推广（广告）收益！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"代言购买",@"普通购买",nil];
        [alert show];
        return;
    }
    [self submitOrderWithEndorse:NO];
}

- (void)submitOrderWithEndorse:(BOOL)endorse {
    [self showHUDWithMessage:nil];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:
                                  @{
                                    @"device_id": [FrankTools getDeviceUUID],
                                    @"token": [FrankTools getUserToken],
                                    @"realname":self.address.consignee,
                                    @"area_id":self.address.area_id,
                                    @"address":self.address.address,
                                    @"mobile":self.address.mobile,
                                    @"is_endorse": @(endorse)}];
    NSMutableArray *seller_list = [NSMutableArray array];
    for (OrderItemModel *model in self.orderItems) {
        NSMutableDictionary *modelDic = [NSMutableDictionary dictionaryWithDictionary:
                                         @{
                                           @"seller_id":@(model.seller.seller_id),
                                           @"goods_amount": @(model.sum_price),
                                           @"postscript":model.sepcialMessage ? model.sepcialMessage : @"",
                                           @"need_note":model.orderMessage ? model.orderMessage : @""}];
        NSMutableArray *goodsArr = [NSMutableArray array];
        for (GoodsModel *goods in model.goods_list) {
            NSDictionary *goodsDic = @{
                                       @"goods_id":goods.goods_id,
                                       @"goods_number":@(goods.goods_number),
                                       @"attr_id":@(goods.attr_id)};
            [goodsArr addObject:goodsDic];
        }
        [modelDic setObject:goodsArr forKey:@"goods_list"];
        [seller_list addObject:modelDic];
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:[seller_list copy] options:NSJSONWritingPrettyPrinted | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:nil];
    NSString *resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [param setObject:resultString forKey:@"seller_list"];
    [MainRequest RequestHTTPData:PATHShop(@"api/ShoppingCart/addOrderAll") parameters:param success:^(id response) {
        NSString *order_number = [response objectForKey:@"order_number"];
        NSString *order_Money = [response objectForKey:@"order_amount"];
        OrderPayType flag = [[response objectForKey:@"flag"] integerValue];
        __weak typeof (self) weakSelf = self;
        [self showHUDWithResult:YES message:@"订单提交成功" completion:^{
            PayMethodViewController *payMethod = [[PayMethodViewController alloc] init];
            payMethod.order_id = [NSString stringWithFormat:@"%@",[response objectForKey:@"order_id"]];
            payMethod.orderNum = [NSString stringWithFormat:@"%@",order_number];
            payMethod.orderMoney = [NSString stringWithFormat:@"%@",order_Money];
            payMethod.orderPayType = flag;
            [weakSelf.navigationController pushViewController:payMethod animated:YES];
        }];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orderItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.address ? 80 : 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderItemModel *item = [self.orderItems objectAtIndex:indexPath.row];
    BOOL is_customize = NO;
    for (GoodsModel *goods in item.goods_list) {
        if (goods.is_customize) {
            is_customize = YES;
            break;
        }
    }
    if (is_customize) {
        return 376 + 90 * item.goods_list.count;
    }
    return 301 + 90 * item.goods_list.count;
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
    OrderItemModel *item = [self.orderItems objectAtIndex:indexPath.row];
    OrderConfirmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderConfirmTableViewCell"];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.delegate = self;
    [cell updateUIWithGoods:item.goods_list];
    cell.freightLabel.text = [NSString stringWithFormat:@"¥%.2f",item.seller.seller_fee];
    [cell.sellerImgView sd_setImageWithURL:[NSURL URLWithString:item.seller.thumb_img] placeholderImage:placeHolderImg];
    cell.sellerNameLabel.text = item.seller.seller_name;
    cell.sellerPhoneLabel.text = item.seller.telephone;
    cell.totalCountLabel.text = [NSString stringWithFormat:@"共%ld件商品",(long)item.sum_goods];
    cell.totalPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",item.sum_price];
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - OrderConfirmTableViewCellDelegate
- (void)orderConfrimCellDidClickCallSellerBtn:(OrderConfirmTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    OrderItemModel *item = [self.orderItems objectAtIndex:indexPath.row];
    [FrankTools detailPhone:item.seller.telephone];
}

- (void)orderConfrimCellDidFinishEditingNoteTextField:(OrderConfirmTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    OrderItemModel *item = [self.orderItems objectAtIndex:indexPath.row];
    item.orderMessage = [cell.noteTextField.text trim];
}

- (void)orderConfrimCellDidFinishEditingCustomizeTextField:(OrderConfirmTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    OrderItemModel *item = [self.orderItems objectAtIndex:indexPath.row];
    item.sepcialMessage = [cell.customizeTextField.text trim];
}

#pragma mark - ManageAddressViewControllerDelegate
- (void)modifyAddress:(RecieveAddressModel *)address {
    self.address = address;
    [self updateUI];
}

#pragma mark - AddressViewControllerDelegate
- (void)didFinishAddOrEditAddress:(RecieveAddressModel *)address {
    self.address = address;
    [self updateUI];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"代言购买"]) {
        [self submitOrderWithEndorse:YES];
    } else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"普通购买"]) {
        [self submitOrderWithEndorse:NO];
    }
}

@end
