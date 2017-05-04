//
//  SellerInforTableViewCell.h
//  LegendWorld
//
//  Created by Frank on 2016/11/14.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SellerInforTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *shopImage;//店铺图片
@property (weak, nonatomic) IBOutlet UILabel *nameLab;//姓名
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;//电话
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;//打电话

@end
