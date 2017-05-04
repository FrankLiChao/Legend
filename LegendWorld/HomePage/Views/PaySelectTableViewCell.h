//
//  PaySelectTableViewCell.h
//  LegendWorld
//
//  Created by 文荣 on 16/9/14.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaySelectTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImahe;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;

@end
