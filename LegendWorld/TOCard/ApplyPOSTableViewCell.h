//
//  ApplyPOSTableViewCell.h
//  LegendWorld
//
//  Created by Tsz on 2016/12/28.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyPOSTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *posImageView;
@property (weak, nonatomic) IBOutlet UILabel *posLabel;
@property (weak, nonatomic) IBOutlet UILabel *posPrice;
@property (weak, nonatomic) IBOutlet UILabel *posOldPrice;
@property (weak, nonatomic) IBOutlet UITextField *posCount;
@property (weak, nonatomic) IBOutlet UIButton *plusBtn;
@property (weak, nonatomic) IBOutlet UIButton *minusBtn;
@property (weak, nonatomic) IBOutlet UILabel *freight;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *applyDelegateBtn;

@end
