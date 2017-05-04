//
//  OrderConfirmTableViewCell.m
//  LegendWorld
//
//  Created by Tsz on 2016/11/7.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "OrderConfirmTableViewCell.h"
#import "OrderConfirmGoodsTableViewCell.h"

@interface OrderConfirmTableViewCell() <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *goods;

@end

@implementation OrderConfirmTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    self.noteTextField.layer.borderColor = [UIColor seperateColor].CGColor;
    self.noteTextField.layer.borderWidth = 0.5;
    
    self.customizeTextField.layer.borderColor = [UIColor seperateColor].CGColor;
    self.customizeTextField.layer.borderWidth = 0.5;
    
    [self.goodsTableView registerNib:[UINib nibWithNibName:@"OrderConfirmGoodsTableViewCell" bundle:nil] forCellReuseIdentifier:@"OrderConfirmGoodsTableViewCell"];
    self.goodsTableView.scrollEnabled = NO;
    self.goodsTableView.scrollsToTop = NO;
    self.goodsTableView.separatorColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)callSellerBtnClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderConfrimCellDidClickCallSellerBtn:)]) {
        [self.delegate orderConfrimCellDidClickCallSellerBtn:self];
    }
}

- (void)updateUIWithGoods:(NSArray *)goods {
    self.goods = [goods copy];
    BOOL is_customize = NO;
    for (GoodsModel *goods in self.goods) {
        if (goods.is_customize) {
            is_customize = YES;
            break;
        }
    }
    
    if (!is_customize) {
        self.customImg.hidden = YES;
        self.customTitle.hidden = YES;
        self.customInfo.hidden = YES;
        self.customizeTextField.hidden = YES;
        
        self.constraint1.priority = 999;
        self.constraint2.priority = 1000;
        [self updateConstraints];
        [self layoutIfNeeded];
    } else {
        self.customImg.hidden = NO;
        self.customTitle.hidden = NO;
        self.customInfo.hidden = NO;
        self.customizeTextField.hidden = NO;
        
        self.constraint1.priority = 1000;
        self.constraint2.priority = 999;
        [self updateConstraints];
        [self layoutIfNeeded];
    }
    [self.goodsTableView reloadData];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.noteTextField) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(orderConfrimCellDidFinishEditingNoteTextField:)]) {
            [self.delegate orderConfrimCellDidFinishEditingNoteTextField:self];
        }
    } else if (textField == self.customizeTextField) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(orderConfrimCellDidFinishEditingCustomizeTextField:)]) {
            [self.delegate orderConfrimCellDidFinishEditingCustomizeTextField:self];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSInteger length = textField.text.length - range.length + string.length;
    return length <= 200;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.goods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderConfirmGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderConfirmGoodsTableViewCell"];
    GoodsModel *goods = [self.goods objectAtIndex:indexPath.row];
    [cell.goodsImg sd_setImageWithURL:[NSURL URLWithString:goods.goods_thumb] placeholderImage:placeHolderImg];
    cell.goodsName.text = goods.goods_name;
    cell.goodsAttr.text = goods.attr_name;
    cell.goodsCount.text = [NSString stringWithFormat:@"X%ld",(long)goods.goods_number];
    cell.goodsPrice.text = [NSString stringWithFormat:@"¥%@",goods.price];
    return cell;
}

@end
