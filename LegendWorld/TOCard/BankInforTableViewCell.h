//
//  BankInforTableViewCell.h
//  LegendWorld
//
//  Created by Frank on 2016/12/16.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BankInforTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logoIm;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UILabel *bankNum;

@end
