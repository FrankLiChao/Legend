//
//  OrderDetailAddressCell.m
//  LegendWorld
//
//  Created by Tsz on 2016/11/14.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "OrderDetailAddressCell.h"

@implementation OrderDetailAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateUIWithAddress:(RecieveAddressModel *)address {
    self.consigneeLabel.text = [NSString stringWithFormat:@"收货人：%@",address.consignee];
    self.mobileLabel.text = address.mobile;
    self.addressLabel.text = [NSString stringWithFormat:@"收货地址：%@ %@", address.area, address.address];
}

@end
