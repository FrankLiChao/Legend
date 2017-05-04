//
//  DealdetailsViewController.m
//  LegendWorld
//
//  Created by ios-dev-01 on 16/9/26.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "DealdetailsViewController.h"
#import "PayDeteilTableViewCell.h"
#import "MainRequest.h"
#import "AgentSuccessController.h"

@interface DealdetailsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(weak,nonatomic)UITableView *myTableView;
@property(strong,nonatomic)NSArray *nameArray;
@property(strong,nonatomic)NSArray *valueArray;

@end

@implementation DealdetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"交易详情";
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(DeviceMaxWidth-90, 20, 80, 44);
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(clickCompleteEvent) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:rightBtn];
    [self requestData];
//    [self initFrameView];
}

-(void)requestData
{
    [self showHUD];
    NSDictionary *dic = @{@"device_id":[FrankTools getDeviceUUID],
                          @"token":[FrankTools getUserToken],
                          @"trade_no":_orderModel.trade_no?_orderModel.trade_no:@"",
                          @"trade_type":@"2"};
    [MainRequest RequestHTTPData:PATHShop(@"api/Order/finishTrade") parameters:dic success:^(id responseData) {
        _orderModel = [Order mj_objectWithKeyValues:responseData];
        [self initData];
        [self initFrameView];
        [self hideHUD];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

-(void)initData{
    self.nameArray = @[@"商品名称",@"商品金额",@"交易时间",@"支付方式",@"订 单 号"];
    NSString *nameStr = [NSString stringWithFormat:@"%@",_orderModel.goods_info];
    NSString *trade_no = [NSString stringWithFormat:@"%@",self.orderModel.trade_no?self.orderModel.trade_no:@""];//订单号
    NSString *payWay = nil;
    switch ([self.orderModel.pay_type integerValue]) {
        case 1:{
            payWay = @"余额支付";
        }break;
        case 3:{
            payWay = @"微信支付";
        }break;
        case 2:{
            payWay = @"支付宝支付";
        }break;
        default:
            break;
    }
    NSString *timeStr = [NSString stringWithFormat:@"%@",self.orderModel.pay_time?self.orderModel.pay_time:@""];
    NSString *moneyStr = [NSString stringWithFormat:@"¥%0.2f",[_orderModel.order_amount floatValue]];
    self.valueArray = @[nameStr,moneyStr,timeStr,payWay,trade_no];
}

-(void)initFrameView
{
    self.view.backgroundColor = viewColor;
    UILabel *moneyLab = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 64+45*widthRate, DeviceMaxWidth-20*widthRate, 55*widthRate)];
    moneyLab.textAlignment = NSTextAlignmentCenter;
    moneyLab.text = [NSString stringWithFormat:@"¥%0.2f",[_orderModel.order_amount floatValue]];
    moneyLab.font = [UIFont systemFontOfSize:48];
    moneyLab.textColor = contentTitleColorStr;
    [self.view addSubview:moneyLab];
    
    UIButton *payStautBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    payStautBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [payStautBtn setTitleColor:mainColor forState:UIControlStateNormal];
    
    [self.view addSubview:payStautBtn];
    
    NSString *statusStr = nil;
    if ([self.orderModel getPayStatus] == 0) {
        statusStr = @"未支付";
    }else if ([self.orderModel getPayStatus] == 2) {
        statusStr = @"支付成功";
        [payStautBtn setTitleColor:[UIColor colorFromHexRGB:@"36cb87"] forState:UIControlStateNormal];
    }else if ([self.orderModel getPayStatus] == 1) {
        statusStr = @"支付失败";
    }
    [payStautBtn setTitle:statusStr forState:UIControlStateNormal];
    
    payStautBtn.sd_layout
    .topSpaceToView(moneyLab,0)
    .heightIs(22*widthRate)
    .centerXEqualToView(moneyLab)
    .widthIs(100);
    
    if ([self.orderModel getPayStatus] == 2) {
        [payStautBtn setImage:imageWithName(@"pay_success") forState:UIControlStateNormal];
    }else{
        [payStautBtn setImage:imageWithName(@"pay_failed") forState:UIControlStateNormal];
    }
    
    UITableView *myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+165*widthRate, DeviceMaxWidth, 200*widthRate) style:UITableViewStylePlain];
    myTableView.scrollEnabled = NO;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    self.myTableView = myTableView;
    [self.view addSubview:self.myTableView];
    
    
}

#pragma mark - UItabViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.nameArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40*widthRate;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * tifier = @"FrankCell";
    PayDeteilTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:tifier];
    if (cell == nil) {
        cell = [[PayDeteilTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tifier];
    }
    cell.name.text = self.nameArray[indexPath.row];
    cell.deteil.text = self.valueArray[indexPath.row];
    return cell;
}

-(void)clickCompleteEvent
{
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 2) {
        [self.navigationController popToViewController:[viewControllers objectAtIndex:viewControllers.count-3] animated:YES];
    }
    else [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
