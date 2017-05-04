//
//  ApplyRecordTableViewCell.h
//  LegendWorld
//
//  Created by Frank on 2016/12/28.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyRecordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logoIm;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;//状态

@end
