//
//  OrderDetailGoodsCell.h
//  LegendWorld
//
//  Created by Tsz on 2016/11/14.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderDetailGoodsCell;
@protocol OrderDetailGoodsCellDelegate <NSObject>

- (void)goodsCell:(OrderDetailGoodsCell *)cell didSelectApplyAfterSaleBtnAtIndex:(NSInteger)index;

@end

@interface OrderDetailGoodsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *requirementImg;
@property (weak, nonatomic) IBOutlet UILabel *requirementTitle;
@property (weak, nonatomic) IBOutlet UITextField *requirementsTextField;
@property (weak, nonatomic) IBOutlet UITableView *goodsTableView;
@property (weak, nonatomic) IBOutlet UILabel *goodsAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *freightLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) id delegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint2;

- (void)updateUIWithOrder:(OrderModel *)order;
@end
