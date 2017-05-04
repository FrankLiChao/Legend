//
//  OrderConfirmTableViewCell.h
//  LegendWorld
//
//  Created by Tsz on 2016/11/7.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderConfirmTableViewCell;
@protocol OrderConfirmTableViewCellDelegate <NSObject>

- (void)orderConfrimCellDidFinishEditingNoteTextField:(OrderConfirmTableViewCell *)cell;
- (void)orderConfrimCellDidFinishEditingCustomizeTextField:(OrderConfirmTableViewCell *)cell;
- (void)orderConfrimCellDidClickCallSellerBtn:(OrderConfirmTableViewCell *)cell;

@end

@interface OrderConfirmTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITableView *goodsTableView;
@property (weak, nonatomic) IBOutlet UILabel *freightLabel;
@property (weak, nonatomic) IBOutlet UITextField *noteTextField;
@property (weak, nonatomic) IBOutlet UITextField *customizeTextField;
@property (weak, nonatomic) IBOutlet UIImageView *sellerImgView;
@property (weak, nonatomic) IBOutlet UILabel *sellerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sellerPhoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *callSellerBtn;
@property (weak, nonatomic) IBOutlet UILabel *totalCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint1;
@property (weak, nonatomic) IBOutlet UIImageView *customImg;
@property (weak, nonatomic) IBOutlet UILabel *customTitle;
@property (weak, nonatomic) IBOutlet UILabel *customInfo;

@property (weak, nonatomic) id delegate;

- (void)updateUIWithGoods:(NSArray *)goods;

@end
