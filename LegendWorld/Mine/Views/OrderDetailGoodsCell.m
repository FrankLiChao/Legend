//
//  OrderDetailGoodsCell.m
//  LegendWorld
//
//  Created by Tsz on 2016/11/14.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "OrderDetailGoodsCell.h"
#import "OrderDetailGoodsInfoCell.h"

@interface OrderDetailGoodsCell() <UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) NSArray *goods;

@end


@implementation OrderDetailGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.clipsToBounds = YES;
    self.contentView.clipsToBounds = YES;
    
    self.goodsTableView.backgroundColor = [UIColor clearColor];
    self.goodsTableView.tableFooterView = [UIView new];
    self.goodsTableView.dataSource = self;
    self.goodsTableView.delegate = self;
    self.goodsTableView.scrollEnabled = NO;
    self.goodsTableView.separatorColor = [UIColor clearColor];
    [self.goodsTableView registerNib:[UINib nibWithNibName:@"OrderDetailGoodsInfoCell" bundle:nil] forCellReuseIdentifier:@"OrderDetailGoodsInfoCell"];
    
    self.requirementsTextField.layer.borderColor = [UIColor seperateColor].CGColor;
    self.requirementsTextField.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSString *)getAfterSaleDescByGoods:(GoodsModel *)goods {
    NSString *desc = nil;
    if (goods.is_complete == 1) {
        if (goods.complete_type == 3) {
            return @"退款已完成";
        } else {
            return @"退款已取消";
        }
    }
    //1：申请售后；2：同意；3:买家发货; 4:卖家收货;5：拒绝；6：取消；7：卖家换货；
    switch (goods.after_status) {
        case 0:{
            desc = @"申请售后";
            break;
        }
        case 1:{
            desc = @"退款审核中";
            break;
        }
        case 2:{
            desc = @"退款中";
            break;
        }
        case 3:{
            desc = @"退款中";
            break;
        }
        case 4:{
            desc = @"退款中";
            break;
        }
        case 5:{
            desc = @"退款未同意";
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
        default:
            break;
    }
    return desc;
}

- (void)updateUIWithOrder:(OrderModel *)order {
    self.requirementsTextField.text = order.need_note;
    self.goodsAmountLabel.text = [NSString stringWithFormat:@"¥%@",order.goods_amount];
    self.freightLabel.text = [NSString stringWithFormat:@"¥%@",order.shipping_fee];
    self.totalPriceLabel.text = [NSString stringWithFormat:@"¥%@",order.order_money];
    
    self.goods = [order.order_goods copy];
    
    if (order.need_note.length <= 0) {
        self.constraint1.priority = 999;
        self.constraint2.priority = 1000;
        self.requirementImg.hidden = YES;
        self.requirementTitle.hidden = YES;
        self.requirementsTextField.hidden = YES;
    } else {
        self.constraint1.priority = 1000;
        self.constraint2.priority = 999;
        self.requirementImg.hidden = NO;
        self.requirementTitle.hidden = NO;
        self.requirementsTextField.hidden = NO;
    }
    
    [self updateConstraints];
    [self layoutIfNeeded];
    
    
    if ([order.order_status integerValue] == 0 || [order.order_status integerValue] == 6 || [order.order_status integerValue] == 7 || [order.order_status integerValue] == 8) {
        self.goodsTableView.rowHeight = 90;
    } else {
        self.goodsTableView.rowHeight = 125;
    }
    [self.goodsTableView reloadData];
}


- (void)actionBtnAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(goodsCell:didSelectApplyAfterSaleBtnAtIndex:)]) {
        [self.delegate goodsCell:self didSelectApplyAfterSaleBtnAtIndex:sender.tag];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.goods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GoodsModel *curGoods = [self.goods objectAtIndex:indexPath.row];
    OrderDetailGoodsInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailGoodsInfoCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.goodsImg sd_setImageWithURL:[NSURL URLWithString:curGoods.goods_thumb] placeholderImage:placeHolderImg];
    cell.goodsName.text = curGoods.goods_name;
    cell.goodsAttr.text = curGoods.attr_name;
    cell.goodsPrice.text = [NSString stringWithFormat:@"¥%@",curGoods.price];
    cell.goodsNumber.text = [NSString stringWithFormat:@"X%ld", (long)curGoods.goods_number];
    cell.actionBtn.hidden = tableView.rowHeight == 90;
    cell.actionBtn.tag = indexPath.row;
    [cell.actionBtn setTitle:[self getAfterSaleDescByGoods:curGoods] forState:UIControlStateNormal];
    [cell.actionBtn addTarget:self action:@selector(actionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

@end
