//
//  MyOrderTableViewCell.h
//  LegendWorld
//
//  Created by Tsz on 2016/11/10.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyOrderTableViewCell;
@protocol MyOrderTableViewCellDelegate <NSObject>

- (void)myOrderCell:(MyOrderTableViewCell *)cell didClickedActionBtn:(UIButton *)sender;

@end

@interface MyOrderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderstatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *seeDetailBtn;

@property (weak, nonatomic) id delegate;

@end
