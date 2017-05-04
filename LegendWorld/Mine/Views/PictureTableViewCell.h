//
//  PictureTableViewCell.h
//  LegendWorld
//
//  Created by Frank on 2016/11/17.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameHight;

@property (weak, nonatomic) IBOutlet UIImageView *imageOne;
@property (weak, nonatomic) IBOutlet UIImageView *imageTwo;
@property (weak, nonatomic) IBOutlet UIImageView *imagethree;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWith;

@end
