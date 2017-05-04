//
//  OrderConfirmAddressHeaderView.h
//  LegendWorld
//
//  Created by Tsz on 2016/11/7.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderConfirmAddressHeaderView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UILabel *consigneeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *noAddressLabel;

@end
