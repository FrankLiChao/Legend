//
//  OrderDetailViewController.m
//  LegendWorld
//
//  Created by 文荣 on 16/9/22.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "PayMethodViewController.h"
#import "DealSuccessViewController.h"
#import "ApplyAfterSaleViewController.h"
#import "EvaluationNewViewController.h"
#import "DrawbackDetailViewController.h"
#import "FillShippingInfoViewController.h"
#import "LogisticsViewController.h"

#import "OrderDetailOrderIdCell.h"
#import "OrderDetailShippingCell.h"
#import "OrderDetailAddressCell.h"
#import "OrderDetailGoodsCell.h"
#import "OrderDetailSellerCell.h"
#import "OrderDetailHistoryCell.h"


@interface OrderDetailViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, OrderDetailGoodsCellDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIButton *leftBtn;
@property (nonatomic, weak) UIButton *rightBtn;
@property (nonatomic, weak) UIView *bottomView;

@property (nonatomic, strong) OrderModel *order;
@property (nonatomic, strong) LogisticsProcessModel *process;
@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单详情";
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView = tableView;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor seperateColor];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 40, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 40, 0);
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderDetailOrderIdCell" bundle:nil] forCellReuseIdentifier:@"OrderDetailOrderIdCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderDetailShippingCell" bundle:nil] forCellReuseIdentifier:@"OrderDetailShippingCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderDetailAddressCell" bundle:nil] forCellReuseIdentifier:@"OrderDetailAddressCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderDetailGoodsCell" bundle:nil] forCellReuseIdentifier:@"OrderDetailGoodsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderDetailSellerCell" bundle:nil] forCellReuseIdentifier:@"OrderDetailSellerCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderDetailHistoryCell" bundle:nil] forCellReuseIdentifier:@"OrderDetailHistoryCell"];
    [self.view addSubview:self.tableView];
    
    UIView *bottomView = [[UIView alloc] init];
    self.bottomView = bottomView;
    self.bottomView.layer.borderColor = [UIColor seperateColor].CGColor;
    self.bottomView.layer.borderWidth = .5;
    self.bottomView.backgroundColor = [UIColor whiteColor];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.leftBtn = leftBtn;
    self.leftBtn.titleLabel.font = [UIFont buttonTextFont];
    [self.leftBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.rightBtn = rightBtn;
    self.rightBtn.titleLabel.font = [UIFont buttonTextFont];
    [self.rightBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.rightBtn];
    
    [self.view addSubview:self.bottomView];
    
    [self refreshData];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
    self.bottomView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - 40, CGRectGetWidth(self.view.bounds), 40);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark - Event
- (void)updateUI {
    //'0未付款,1已付款,2已发货,3已收货,4已评价,5已退货,6已取消,7无效,8充值失败',
    switch ([self.order.order_status integerValue]) {
        case 0: {
            self.leftBtn.hidden = NO;
            [self.leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [self.leftBtn setTitleColor:[UIColor bodyTextColor] forState:UIControlStateNormal];
            [self.leftBtn setBackgroundImage:[UIImage backgroundStrokeImageWithColor:[UIColor bodyTextColor]] forState:UIControlStateNormal];
            self.leftBtn.frame = CGRectMake(50, 5, 80, 30);
            
            self.rightBtn.hidden = NO;
            [self.rightBtn setTitle:@"付款" forState:UIControlStateNormal];
            [self.rightBtn setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
            [self.rightBtn setBackgroundImage:[UIImage backgroundStrokeImageWithColor:[UIColor themeColor]] forState:UIControlStateNormal];
            self.rightBtn.frame = CGRectMake(CGRectGetMaxX(self.bottomView.bounds) - 50 - 80, 5, 80, 30);
            break;
        }
        case 1: {
            self.leftBtn.hidden = YES;
            
            self.rightBtn.hidden = NO;
            [self.rightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            [self.rightBtn setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
            [self.rightBtn setBackgroundImage:[UIImage backgroundStrokeImageWithColor:[UIColor themeColor]] forState:UIControlStateNormal];
            self.rightBtn.frame = CGRectMake((CGRectGetWidth(self.bottomView.bounds) - 180)/2, 5, 180, 30);
            break;
        }
        case 2: {
            self.leftBtn.hidden = YES;
            
            self.rightBtn.hidden = NO;
            [self.rightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            [self.rightBtn setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
            [self.rightBtn setBackgroundImage:[UIImage backgroundStrokeImageWithColor:[UIColor themeColor]] forState:UIControlStateNormal];
            self.rightBtn.frame = CGRectMake((CGRectGetWidth(self.bottomView.bounds) - 180)/2, 5, 180, 30);
            break;
        }
        case 3: {
            self.leftBtn.hidden = YES;
            
            self.rightBtn.hidden = NO;
            [self.rightBtn setTitle:@"去评价" forState:UIControlStateNormal];
            [self.rightBtn setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
            [self.rightBtn setBackgroundImage:[UIImage backgroundStrokeImageWithColor:[UIColor themeColor]] forState:UIControlStateNormal];
            self.rightBtn.frame = CGRectMake((CGRectGetWidth(self.bottomView.bounds) - 180)/2, 5, 180, 30);
            break;
        }
        case 4: {
            self.leftBtn.hidden = NO;
            [self.leftBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            [self.leftBtn setTitleColor:[UIColor bodyTextColor] forState:UIControlStateNormal];
            [self.leftBtn setBackgroundImage:[UIImage backgroundStrokeImageWithColor:[UIColor bodyTextColor]] forState:UIControlStateNormal];
            self.leftBtn.frame = CGRectMake((CGRectGetWidth(self.bottomView.bounds) - 80)/2, 5, 80, 30);
            
            self.rightBtn.hidden = YES;
            break;
        }
        case 5: {
            self.leftBtn.hidden = NO;
            [self.leftBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            [self.leftBtn setTitleColor:[UIColor bodyTextColor] forState:UIControlStateNormal];
            [self.leftBtn setBackgroundImage:[UIImage backgroundStrokeImageWithColor:[UIColor bodyTextColor]] forState:UIControlStateNormal];
            self.leftBtn.frame = CGRectMake((CGRectGetWidth(self.bottomView.bounds) - 80)/2, 5, 80, 30);
            
            self.rightBtn.hidden = YES;
            break;
        }
        case 6: {
            self.leftBtn.hidden = NO;
            [self.leftBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            [self.leftBtn setTitleColor:[UIColor bodyTextColor] forState:UIControlStateNormal];
            [self.leftBtn setBackgroundImage:[UIImage backgroundStrokeImageWithColor:[UIColor bodyTextColor]] forState:UIControlStateNormal];
            self.leftBtn.frame = CGRectMake((CGRectGetWidth(self.bottomView.bounds) - 80)/2, 5, 80, 30);
            
            self.rightBtn.hidden = YES;
            break;
        }
        case 7: {
            self.leftBtn.hidden = NO;
            [self.leftBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            [self.leftBtn setTitleColor:[UIColor bodyTextColor] forState:UIControlStateNormal];
            [self.leftBtn setBackgroundImage:[UIImage backgroundStrokeImageWithColor:[UIColor bodyTextColor]] forState:UIControlStateNormal];
            self.leftBtn.frame = CGRectMake((CGRectGetWidth(self.bottomView.bounds) - 80)/2, 5, 80, 30);
            
            self.rightBtn.hidden = YES;
            break;
        }
        case 8: {
            self.leftBtn.hidden = YES;
            self.rightBtn.hidden = YES;
            break;
        }
        default:
            break;
    }
    [self.tableView reloadData];
}

- (void)refreshData {
    //'0未付款,1已付款,2已发货,3已收货,4已评价,5已退货,6已取消,7无效,8充值失败',
    [self showHUDWithMessage:nil];
    NSDictionary *param = @{@"device_id":[FrankTools getDeviceUUID], @"token":[FrankTools getUserToken], @"order_id":@(self.orderId)};
    [MainRequest RequestHTTPData:PATHShop(@"Api/Order/orderInfo") parameters:param success:^(id response) {
        self.order = [OrderModel parseOrderDetailResponse:response];
        NSInteger orderstatus = [self.order.order_status integerValue];
        if (orderstatus == 1 || orderstatus == 2 || orderstatus == 3 || orderstatus == 4 || orderstatus == 5) {
            self.process = [self queryShippingWithShippingNumber:self.order.shipping_number];
        }
        [self updateUI];
        [self hideHUD];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"] completion:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

- (LogisticsProcessModel *)queryShippingWithShippingNumber:(NSString *)shippingNumber {
    if (shippingNumber.length <= 0) {
        return nil;
    }
    
    NSString *appcode = @"61d591aca549401f89360dba853fbb48";
    NSString *host = @"http://jisukdcx.market.alicloudapi.com";
    NSString *path = @"/express/query";
    NSString *method = @"GET";
    NSString *querys = [NSString stringWithFormat:@"?number=%@&type=auto",shippingNumber];
    NSString *url = [NSString stringWithFormat:@"%@%@%@", host, path, querys];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: url] cachePolicy:1 timeoutInterval:10];
    request.HTTPMethod = method;
    [request addValue:[NSString stringWithFormat:@"APPCODE %@",appcode] forHTTPHeaderField:@"Authorization"];
    
    NSError *error = nil;
    NSURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error == nil && data != nil) {
        NSString *resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *resultDic = [JSONParser parseToDictionaryWithString:resultString];
        NSDictionary *resultInfoDic = [resultDic objectForKey:@"result"];
        if (![resultInfoDic isKindOfClass:[NSDictionary class]]) {
            return nil;
        }
        NSString *type = [resultInfoDic objectForKey:@"type"];
        NSInteger deliveryStatusCode = [[[resultDic objectForKey:@"result"] objectForKey:@"deliverystatus"] integerValue];
        BOOL isSign = [[[resultDic objectForKey:@"result"] objectForKey:@"issign"] integerValue];
        NSString *deliveryStatusDesc = nil;
        switch (deliveryStatusCode) {
            case 1:
                deliveryStatusDesc = @"在途中";
                break;
            case 2:
                deliveryStatusDesc = @"派件中";
                break;
            case 3:
                deliveryStatusDesc = @"已签收";
                break;
            case 4:
                deliveryStatusDesc = @"派送失败";
                break;
            default:
                break;
        }
        
        NSMutableArray *logProcess = [NSMutableArray array];
        NSArray *processArr = [[resultDic objectForKey:@"result"] objectForKey:@"list"];
        for (NSDictionary *pDic in processArr) {
            LogisticsProcessModel *process = [LogisticsProcessModel parseByLogisticsProcessDic:pDic];
            [logProcess addObject:process];
        }
    
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //Start s
            NSString *shost = @"http://jisukdcx.market.alicloudapi.com";
            NSString *spath = @"/express/type";
            NSString *smethod = @"GET";
            NSString *squerys = @"";
            NSString *surl = [NSString stringWithFormat:@"%@%@%@", shost, spath, squerys];
            
            NSMutableURLRequest *srequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:surl] cachePolicy:1 timeoutInterval:10];
            srequest.HTTPMethod = smethod;
            [srequest addValue:[NSString stringWithFormat:@"APPCODE %@",appcode] forHTTPHeaderField:@"Authorization"];
            
            NSError *serror = nil;
            NSURLResponse *sresponse = nil;
            NSData *sdata = [NSURLConnection sendSynchronousRequest:srequest returningResponse:&sresponse error:&serror];
            
            if (serror == nil && sdata != nil) {
                NSString *sresultString = [[NSString alloc] initWithData:sdata encoding:NSUTF8StringEncoding];
                NSDictionary *sresultDic = [JSONParser parseToDictionaryWithString:sresultString];
                NSArray *logArr = [sresultDic objectForKey:@"result"];
                for (NSDictionary *logDic in logArr) {
                    if ([[[logDic objectForKey:@"type"] uppercaseString] isEqualToString:[type uppercaseString]]) {
                        LogisticsModel *log = [LogisticsModel parseByLogisticsDic:logDic];
                        log.number = shippingNumber;
                        log.deliveryStatusCode = deliveryStatusCode;
                        log.deliveryStatusDesc = deliveryStatusDesc;
                        log.isSign = isSign;
                        log.processes = [logProcess copy];
                        self.order.logistic = log;
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self updateUI];
                        });
                        return;
                    }
                }
            }
        });
        return [logProcess firstObject];
    }
    return nil;
}

- (void)btnAction:(UIButton *)sender {
    if ([sender.currentTitle isEqualToString:@"取消订单"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"您要取消订单吗？"
                                                       delegate:self
                                              cancelButtonTitle:@"不取消"
                                              otherButtonTitles:@"确认取消", nil];
        [alert show];
    } else if ([sender.currentTitle isEqualToString:@"付款"]) {
        PayMethodViewController *payMethod = [[PayMethodViewController alloc] init];
        payMethod.orderNum = self.order.order_number;
        payMethod.order_id = self.order.order_id;
        payMethod.orderMoney = self.order.order_money;
        payMethod.orderPayType = OrderPayTypeNormal;
        [self.navigationController pushViewController:payMethod animated:YES];
    } else if ([sender.currentTitle isEqualToString:@"确认收货"]) {
        if ([self.order.order_status integerValue] == 1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"当前订单未发货，无法确认收货"
                                                           delegate:nil
                                                  cancelButtonTitle:@"知道了"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        
        if (self.order.is_after) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"该订单中包含有退款记录的商品，确认收货将关闭退款。"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确认收货", nil];
            [alert show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"您要确认收货吗？"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确认收货", nil];
            [alert show];
        }
    } else if ([sender.currentTitle isEqualToString:@"去评价"]) {
        EvaluationNewViewController *ev = [[EvaluationNewViewController alloc] init];
        ev.order_id = self.order.order_id;
        ev.seller_id = self.order.seller_info.seller_id;
        ev.modelDataArr = [self.order.order_goods copy];
        [self.navigationController pushViewController:ev animated:YES];
    } else if ([sender.currentTitle isEqualToString:@"删除订单"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"您要删除订单吗？"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确认删除", nil];
        [alert show];
    }
}

- (NSString *)getOrderStatusDesc {
    if (self.order.is_after == 1) {
        return @"申请退款中";
    } else if (self.order.is_after == 2) {
        return @"退款已完成";
    } else if (self.order.is_after == 3) {
        return @"退款关闭";
    }
    NSInteger orderStatus = [self.order.order_status integerValue];
    NSString *desc = nil;
    //'0未付款,1已付款,2已发货,3已收货,4已评价,5已退货,6已取消,7无效,8充值失败',
    switch (orderStatus) {
        case 0:{
            desc = @"待付款";
            break;
        }
        case 1:{
            desc = @"待收货";
            break;
        }
        case 2:{
            desc = @"待收货";
            break;
        }
        case 3:{
            desc = @"待评价";
            break;
        }
        case 4:{
            desc = @"已完成";
            break;
        }
        case 5:{
            desc = @"退款已完成";
            break;
        }
        case 6:{
            desc = @"已取消";
            break;
        }
        case 7:{
            desc = @"已取消";
            break;
        }
        case 8:{
            desc = @"充值失败";
            break;
        }
        default:
            break;
    }
    return desc;
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.order == nil) {
        return 0;
    }
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger orderStatus = [self.order.order_status integerValue];
    NSInteger row = 1;
    if (section == 0) {
        if (orderStatus == 0 || orderStatus == 6 || orderStatus == 7 || orderStatus == 8) {
            row = 3;
        } else {
            row = 4;
        }
        return row;
    }
    return row;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger orderStatus = [self.order.order_status integerValue];
    //'0未付款,1已付款,2已发货,3已收货,4已评价,5已退货,6已取消,7无效,8充值失败',
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if (orderStatus == 2 || orderStatus == 1) {
                return 65;
            }
            return 45;
        } else if (indexPath.row == 1) {
            if (orderStatus == 0 || orderStatus == 6 || orderStatus == 7 || orderStatus == 8) {
                return 90;
            } else {
                if (self.order.logistic) {
                    return 90;
                }
                return 45;
            }
        } else if (indexPath.row == 2) {
            if (orderStatus == 0 || orderStatus == 6 || orderStatus == 7 || orderStatus == 8) {
                if (self.order.need_note.length <= 0) {
                    return 210 - 69 + 90 * self.order.order_goods.count;
                } else {
                    return 210 + 90 * self.order.order_goods.count;
                }
            }
            return 90;
        } else if (indexPath.row == 3) {
            if (orderStatus == 0 || orderStatus == 6 || orderStatus == 7 || orderStatus == 8 || [self.order.complete_status integerValue] == 2) {
                return 210 + 90 * self.order.order_goods.count;
            }
            if (self.order.need_note.length <= 0) {
                return 210 - 69 + 125 * self.order.order_goods.count;
            } else {
                return 210 + 125 * self.order.order_goods.count;
            }
        }
    } else if (indexPath.section == 1) {
        return 100;
    } else if (indexPath.section == 2) {
        CGFloat height = 40;
        switch (orderStatus) {
            case 0:{
                height = height + 25;
                break;
            }
            case 1: {
                height = height + 25 * 3;
                break;
            }
            case 2: {
                height = height + 25 * 3;
                break;
            }
            case 3: {
                height = height + 25 * 4;
                break;
            }
            case 4: {
                height = height + 25 * 5;
                break;
            }
            case 5: {
                NSInteger addCount = 3;
                if (![self.order.confirm_receipt_time isEqualToString:@"0"]) {
                    addCount ++;
                }
                if (![self.order.complete_time isEqualToString:@"0"]) {
                    addCount ++;
                }
                height = height + 25 * addCount;
                break;
            }
            case 6: {
                height = height + 25;
                break;
            }
            case 7: {
                height = height + 25;
                break;
            }
            case 8:{
                height = height + 25;
                break;
            }
            default:
                break;
        }
        return height;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger orderStatus = [self.order.order_status integerValue];
    //'0未付款,1已付款,2已发货,3已收货,4已评价,5已退货,6已取消,7无效,8充值失败',
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            OrderDetailOrderIdCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailOrderIdCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.orderNumberLabel.text = [NSString stringWithFormat:@"订单号：%@",self.order.order_number];
            cell.orderStatusLabel.text = [self getOrderStatusDesc];
            if ([self.order.order_status integerValue] == 1 || [self.order.order_status integerValue] == 2) {
                cell.timeLeftLabel.hidden = NO;
                NSArray *arr = [self.order.range_time componentsSeparatedByString:@"_"];
                NSInteger day = [[arr firstObject] integerValue];
                NSInteger hour = [[arr lastObject] integerValue];
                cell.timeLeftLabel.text = [NSString stringWithFormat:@"还剩%ld天%ld小时自动确认收货",(long)day,(long)hour];
            } else {
                cell.timeLeftLabel.hidden = YES;
            }
            return cell;
        } else if (indexPath.row == 1) {
            if (orderStatus == 0 || orderStatus == 6 || orderStatus == 7 || orderStatus == 8) {
                OrderDetailAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailAddressCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell updateUIWithAddress:self.order.address];
                return cell;
            } else {
                OrderDetailShippingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailShippingCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell updateUIWithLogistic:self.order.logistic];
                return cell;
            }
        } else if (indexPath.row == 2) {
            if (orderStatus == 0 || orderStatus == 6 || orderStatus == 7 || orderStatus == 8) {
                OrderDetailGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailGoodsCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegate = self;
                [cell updateUIWithOrder:self.order];
                return cell;
            } else {
                OrderDetailAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailAddressCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell updateUIWithAddress:self.order.address];
                return cell;
            }
        } else if (indexPath.row == 3) {
            OrderDetailGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailGoodsCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            [cell updateUIWithOrder:self.order];
            return cell;
        }
    } else if (indexPath.section == 1) {
        OrderDetailSellerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailSellerCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell updateUIWithSeller:self.order.seller_info];
        return cell;
    } else if (indexPath.section == 2) {
        OrderDetailHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailHistoryCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell updateUIWithOrder:self.order];
        return cell;
    }
    static NSString * tifier = @"FrankCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:tifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger orderStatus = [self.order.order_status integerValue];
    if (orderStatus == 0 || orderStatus == 6 || orderStatus == 7 || orderStatus == 8) {
        //没有物流信息的订单
    } else {
        if (indexPath.section == 0 && indexPath.row == 1) {
            LogisticsViewController *log = [[LogisticsViewController alloc] init];
            log.logistics = self.order.logistic;
            [self.navigationController pushViewController:log animated:YES];
        }
    }
}

#pragma mark - OrderDetailGoodsCellDelegate
- (void)goodsCell:(OrderDetailGoodsCell *)cell didSelectApplyAfterSaleBtnAtIndex:(NSInteger)index {
    GoodsModel *goods = [self.order.order_goods objectAtIndex:index];
    if (goods.after_status == 0) {
        if (self.order.is_endorse && [goods.is_endorse boolValue]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您已代言该商品，无法申请售后" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        } else if (goods.is_tocard) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"TO卡无法申请售后" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        ApplyAfterSaleViewController *apply = [[ApplyAfterSaleViewController alloc] init];
        apply.order_id = [NSString stringWithFormat:@"%ld",(long)self.orderId];
        apply.goods_id = [NSString stringWithFormat:@"%@",goods.goods_id];
        apply.seller_id = [NSString stringWithFormat:@"%@",self.order.seller_info.seller_id];
        apply.attr_id = [NSString stringWithFormat:@"%ld",(long)goods.attr_id];
        apply.goods_price = [NSString stringWithFormat:@"%.2f",[goods.price floatValue]*goods.goods_number];
        [self.navigationController pushViewController:apply animated:YES];
    } else {
        if (!goods.after_id) {
            return;
        }
        DrawbackDetailViewController *draw = [[DrawbackDetailViewController alloc] init];
        draw.after_id = goods.after_id;
        [self.navigationController pushViewController:draw animated:YES];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"确认收货"]) {
        [self showHUDWithMessage:nil];
        NSDictionary *param = @{@"device_id": [FrankTools getDeviceUUID], @"token": [FrankTools getUserToken], @"order_id": self.order.order_id, @"deal_type":@2};
        [MainRequest RequestHTTPData:PATHShop(@"api/Order/dealOrder") parameters:param success:^(id response) {
            NSDictionary *par = @{@"device_id":[FrankTools getDeviceUUID], @"token":[FrankTools getUserToken], @"order_id":@(self.orderId)};
            [MainRequest RequestHTTPData:PATHShop(@"api/Order/orderInfo") parameters:par success:^(id responseData) {
                self.order = [OrderModel parseOrderDetailResponse:responseData];
                if (self.delegate && [self.delegate respondsToSelector:@selector(refreshParentVC)]) {
                    [self.delegate refreshParentVC];
                }
                [self updateUI];
                [self hideHUD];
                DealSuccessViewController *dealSuccess = [[DealSuccessViewController alloc] init];
                dealSuccess.order = self.order;
                [self.navigationController pushViewController:dealSuccess animated:YES];
            } failed:^(NSDictionary *errorDic) {
                [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
            }];
        } failed:^(NSDictionary *errorDic) {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }];
    } else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"确认删除"]) {
        [self showHUDWithMessage:nil];
        NSDictionary *param = @{@"device_id": [FrankTools getDeviceUUID], @"token": [FrankTools getUserToken], @"order_id": self.order.order_id, @"deal_type":@1};
        [MainRequest RequestHTTPData:PATHShop(@"api/Order/dealOrder") parameters:param success:^(id response) {
            [self showHUDWithResult:YES message:@"删除成功" completion:^{
                if (self.delegate && [self.delegate respondsToSelector:@selector(refreshParentVC)]) {
                    [self.delegate refreshParentVC];
                }
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } failed:^(NSDictionary *errorDic) {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }];
    } else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"确认取消"]) {
        [self showHUDWithMessage:nil];
        NSDictionary *param = @{@"device_id": [FrankTools getDeviceUUID], @"token": [FrankTools getUserToken], @"order_id": self.order.order_id, @"deal_type":@3};
        [MainRequest RequestHTTPData:PATHShop(@"api/Order/dealOrder") parameters:param success:^(id response) {
            NSDictionary *par = @{@"device_id":[FrankTools getDeviceUUID], @"token":[FrankTools getUserToken], @"order_id":@(self.orderId)};
            [MainRequest RequestHTTPData:PATHShop(@"api/Order/orderInfo") parameters:par success:^(id responseData) {
                self.order = [OrderModel parseOrderDetailResponse:responseData];
                [self updateUI];
                [self showHUDWithResult:YES message:@"取消成功" completion:^{
                    if (self.delegate && [self.delegate respondsToSelector:@selector(refreshParentVC)]) {
                        [self.delegate refreshParentVC];
                    }
                }];
            } failed:^(NSDictionary *errorDic) {
                [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
            }];
        } failed:^(NSDictionary *errorDic) {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }];
    }
}

@end
