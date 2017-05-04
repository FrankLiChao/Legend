//
//  OrderDetailHistoryCell.m
//  LegendWorld
//
//  Created by Tsz on 2016/11/14.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "OrderDetailHistoryCell.h"

#import "OrderDetailHistoryDetailCell.h"

@interface OrderDetailHistoryCell() <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *data;

@end

@implementation OrderDetailHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.historyTableView.backgroundColor = [UIColor clearColor];
    self.historyTableView.tableFooterView = [UIView new];
    self.historyTableView.dataSource = self;
    self.historyTableView.delegate = self;
    self.historyTableView.rowHeight = 25;
    self.historyTableView.scrollEnabled = NO;
    self.historyTableView.separatorColor = [UIColor clearColor];
    [self.historyTableView registerNib:[UINib nibWithNibName:@"OrderDetailHistoryDetailCell" bundle:nil] forCellReuseIdentifier:@"OrderDetailHistoryDetailCell"];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSString *)getPayTypeText:(NSInteger)payType {
    NSString *text = nil;
    switch (payType) {
        case 1:
            text = @"余额支付";
            break;
        case 2:
            text = @"支付宝支付";
            break;
        case 3:
            text = @"微信支付";
            break;
        default:
            break;
    }
    return text;
}

- (void)updateUIWithOrder:(OrderModel *)order {
    NSInteger orderStatus = [order.order_status integerValue];
    //'0未付款,1已付款,2已发货,3已收货,4已评价,5已退货,6已取消,7无效,8充值失败',
    NSMutableArray *arr = [NSMutableArray array];
    switch (orderStatus) {
        case 0: {
            NSString *text = [NSString stringWithFormat:@"创建时间：%@",order.create_time];
            [arr addObject:text];
            break;
        }
        case 1: {
            NSString *payTypeText = [NSString stringWithFormat:@"支付方式：%@", [self getPayTypeText:[order.pay_type integerValue]]];
            [arr addObject:payTypeText];
            NSString *creatTimeText = [NSString stringWithFormat:@"创建时间：%@",order.create_time];
            [arr addObject:creatTimeText];
            NSString *payTimeText = [NSString stringWithFormat:@"支付时间：%@",order.pay_time];
            [arr addObject:payTimeText];
            break;
        }
        case 2: {
            NSString *payTypeText = [NSString stringWithFormat:@"支付方式：%@", [self getPayTypeText:[order.pay_type integerValue]]];
            [arr addObject:payTypeText];
            NSString *creatTimeText = [NSString stringWithFormat:@"创建时间：%@",order.create_time];
            [arr addObject:creatTimeText];
            NSString *payTimeText = [NSString stringWithFormat:@"支付时间：%@",order.pay_time];
            [arr addObject:payTimeText];
            break;
        }
        case 3: {
            NSString *payTypeText = [NSString stringWithFormat:@"支付方式：%@", [self getPayTypeText:[order.pay_type integerValue]]];
            [arr addObject:payTypeText];
            NSString *creatTimeText = [NSString stringWithFormat:@"创建时间：%@",order.create_time];
            [arr addObject:creatTimeText];
            NSString *payTimeText = [NSString stringWithFormat:@"支付时间：%@",order.pay_time];
            [arr addObject:payTimeText];
            NSString *recieveTimeText = [NSString stringWithFormat:@"收货时间：%@",order.confirm_receipt_time];
            [arr addObject:recieveTimeText];
            break;
        }
        case 4: {
            NSString *payTypeText = [NSString stringWithFormat:@"支付方式：%@", [self getPayTypeText:[order.pay_type integerValue]]];
            [arr addObject:payTypeText];
            NSString *creatTimeText = [NSString stringWithFormat:@"创建时间：%@",order.create_time];
            [arr addObject:creatTimeText];
            NSString *payTimeText = [NSString stringWithFormat:@"支付时间：%@",order.pay_time];
            [arr addObject:payTimeText];
            NSString *recieveTimeText = [NSString stringWithFormat:@"收货时间：%@",order.confirm_receipt_time];
            [arr addObject:recieveTimeText];
            NSString *finishTimeText = [NSString stringWithFormat:@"完成时间：%@",order.confirm_receipt_time];
            [arr addObject:finishTimeText];
            break;
        }
        case 5: {
            NSString *payTypeText = [NSString stringWithFormat:@"支付方式：%@", [self getPayTypeText:[order.pay_type integerValue]]];
            [arr addObject:payTypeText];
            NSString *creatTimeText = [NSString stringWithFormat:@"创建时间：%@",order.create_time];
            [arr addObject:creatTimeText];
            NSString *payTimeText = [NSString stringWithFormat:@"支付时间：%@",order.pay_time];
            [arr addObject:payTimeText];
            if (![order.confirm_receipt_time isEqualToString:@"0"]) {
                NSString *recieveTimeText = [NSString stringWithFormat:@"收货时间：%@",order.confirm_receipt_time];
                [arr addObject:recieveTimeText];
            }
            if (![order.complete_time isEqualToString:@"0"]) {
                NSString *complete_time = [NSString stringWithFormat:@"完成时间：%@",order.complete_time];
                [arr addObject:complete_time];
            }
            break;
        }
        case 6: {
            NSString *text = [NSString stringWithFormat:@"创建时间：%@",order.create_time];
            [arr addObject:text];
            break;
        }
        case 7: {
            NSString *text = [NSString stringWithFormat:@"创建时间：%@",order.create_time];
            [arr addObject:text];
            break;
        }
        case 8: {
            break;
        }
        default:
            break;
    }
    self.data = [arr copy];
    [self.historyTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderDetailHistoryDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailHistoryDetailCell"];
    cell.historyInfoLabel.text = self.data[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
