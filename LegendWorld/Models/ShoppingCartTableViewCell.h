//
//  ShoppingCartTableViewCell.h
//  LegendWorld
//
//  Created by Tsz on 2016/11/2.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShoppingCartTableViewCell;
@protocol ShoppingCartTableViewCellDelegate <NSObject>

- (void)shoppingCartCellDidClickedCheckBtn:(ShoppingCartTableViewCell *)cell;
- (void)shoppingCartCellDidClickedMinusBtn:(ShoppingCartTableViewCell *)cell;
- (void)shoppingCartCellDidClickedPlusBtn:(ShoppingCartTableViewCell *)cell;
- (void)shoppingCartCellDidClickedAttributesBtn:(ShoppingCartTableViewCell *)cell;

@end


@interface ShoppingCartTableViewCell : UITableViewCell

@property (nonatomic) BOOL isEditMode;

@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UILabel *endorseLabel;
@property (weak, nonatomic) IBOutlet UILabel *stockInfoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImgView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsAttrLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsCountLabel;

@property (weak, nonatomic) IBOutlet UIButton *minusBtn;
@property (weak, nonatomic) IBOutlet UIImageView *line1;
@property (weak, nonatomic) IBOutlet UIImageView *line2;
@property (weak, nonatomic) IBOutlet UIButton *plusBtn;
@property (weak, nonatomic) IBOutlet UITextField *goodsCountTextField;
@property (weak, nonatomic) IBOutlet UIButton *goodsAttrBtn;

@property (weak, nonatomic) id delegate;


@end
