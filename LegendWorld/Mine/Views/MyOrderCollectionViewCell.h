//
//  MyOrderCollectionViewCell.h
//  LegendWorld
//
//  Created by Tsz on 2016/11/10.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshControl.h"
#import "LoadControl.h"

@interface MyOrderCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) RefreshControl *refreshControl;
@property (weak, nonatomic) LoadControl *loadControl;
@property (weak, nonatomic) IBOutlet UITableView *orderTableView;
@property (weak, nonatomic) IBOutlet UIImageView *emptyImg;
@property (weak, nonatomic) IBOutlet UILabel *emptyLabel;


@end
