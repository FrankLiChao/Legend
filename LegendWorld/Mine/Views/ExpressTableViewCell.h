//
//  ExpressTableViewCell.h
//  LegendWorld
//
//  Created by Frank on 2016/11/16.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *statusIm;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UIButton *expressBtn;
@property (weak, nonatomic) IBOutlet UILabel *addressNameLab;

@end
