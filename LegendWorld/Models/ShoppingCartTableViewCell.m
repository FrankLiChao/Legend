//
//  ShoppingCartTableViewCell.m
//  LegendWorld
//
//  Created by Tsz on 2016/11/2.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "ShoppingCartTableViewCell.h"

@implementation ShoppingCartTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.isEditMode = NO;
    self.goodsNameLabel.textColor = [UIColor bodyTextColor];
    self.goodsAttrLabel.textColor = [UIColor noteTextColor];
    self.goodsPriceLabel.textColor = [UIColor themeColor];
    self.goodsCountLabel.textColor = [UIColor noteTextColor];
    
    self.goodsCountTextField.textColor = [UIColor bodyTextColor];
    self.goodsAttrBtn.layer.borderColor = [UIColor noteTextColor].CGColor;
    self.goodsAttrBtn.layer.borderWidth = 0.5;
    [self.goodsAttrBtn setTitleColor:[UIColor noteTextColor] forState:UIControlStateNormal];
    
    self.stockInfoLabel.layer.cornerRadius = 27.5;
    self.stockInfoLabel.layer.masksToBounds = YES;
    
    self.endorseLabel.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setIsEditMode:(BOOL)isEditMode {
    self.minusBtn.hidden = !isEditMode;
    self.plusBtn.hidden = !isEditMode;
    self.line1.hidden = !isEditMode;
    self.line2.hidden = !isEditMode;
    self.goodsCountTextField.hidden = !isEditMode;
    self.goodsAttrBtn.hidden = !isEditMode;
    
    self.goodsNameLabel.hidden = isEditMode;
    self.goodsAttrLabel.hidden = isEditMode;
    self.goodsPriceLabel.hidden = isEditMode;
    self.goodsCountLabel.hidden = isEditMode;
}
- (IBAction)checkBtnClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(shoppingCartCellDidClickedCheckBtn:)]) {
        [self.delegate shoppingCartCellDidClickedCheckBtn:self];
    }
}
- (IBAction)minusBtnClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(shoppingCartCellDidClickedMinusBtn:)]) {
        [self.delegate shoppingCartCellDidClickedMinusBtn:self];
    }
}
- (IBAction)plusBtnClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(shoppingCartCellDidClickedPlusBtn:)]) {
        [self.delegate shoppingCartCellDidClickedPlusBtn:self];
    }
}
- (IBAction)attrBtnClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(shoppingCartCellDidClickedAttributesBtn:)]) {
        [self.delegate shoppingCartCellDidClickedAttributesBtn:self];
    }
}

@end
