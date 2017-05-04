//
//  MyAdListTableViewCell.h
//  LegendWorld
//
//  Created by 文荣 on 16/9/23.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdvertModel.h"

@interface MyAdListTableViewCell : UITableViewCell

- (void)configWithModel: (AdvertModel *) model;
@end
