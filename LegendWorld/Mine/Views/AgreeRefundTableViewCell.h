//
//  AgreeRefundTableViewCell.h
//  LegendWorld
//
//  Created by Frank on 2016/11/11.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgreeRefundTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *statusIm;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIButton *modefyBtn;
@property (weak, nonatomic) IBOutlet UIButton *applyServerBtn;
@property (weak, nonatomic) IBOutlet UIButton *revokBtn;

@end
