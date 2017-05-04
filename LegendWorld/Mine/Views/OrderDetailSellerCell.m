//
//  OrderDetailSellerCell.m
//  LegendWorld
//
//  Created by Tsz on 2016/11/14.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "OrderDetailSellerCell.h"

@implementation OrderDetailSellerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateUIWithSeller:(SellerInfoModel *)seller {
    [self.sellerImg sd_setImageWithURL:[NSURL URLWithString:seller.thumb_img] placeholderImage:placeHolderImg];
    self.sellerName.text = seller.seller_name;
    self.sellerPhone.text = seller.telephone;
}

- (IBAction)dialTelephone:(id)sender {
    [FrankTools detailPhone:self.sellerPhone.text];
}

@end
