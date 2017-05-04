//
//  WxAccountTableViewCell.h
//  LegendWorld
//
//  Created by Frank on 2016/12/16.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WxAccountTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headIm;//头像
@property (weak, nonatomic) IBOutlet UILabel *acountLab;//微信账号
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;//选择按钮

@end
