//
//  OrderDetailSellerCell.h
//  LegendWorld
//
//  Created by Tsz on 2016/11/14.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailSellerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *sellerImg;
@property (weak, nonatomic) IBOutlet UILabel *sellerName;
@property (weak, nonatomic) IBOutlet UILabel *sellerPhone;
@property (weak, nonatomic) IBOutlet UIButton *dialPhoneBtn;

- (void)updateUIWithSeller:(SellerInfoModel *)seller;

@end
