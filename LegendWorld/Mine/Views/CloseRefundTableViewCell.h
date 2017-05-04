//
//  CloseRefundTableViewCell.h
//  LegendWorld
//
//  Created by Frank on 2016/11/15.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CloseRefundTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *statusIm;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *closeResonLab;
@property (weak, nonatomic) IBOutlet UILabel *closeTimeLab;
@property (weak, nonatomic) IBOutlet UIButton *otherResonLab;
@property (weak, nonatomic) IBOutlet UILabel *otherLab;

@end
