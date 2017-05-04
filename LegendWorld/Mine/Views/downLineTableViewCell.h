//
//  downLineTableViewCell.h
//  LegendWorld
//
//  Created by Frank on 2016/11/7.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface downLineTableViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView *headIm;
@property (nonatomic, strong)UILabel *nameLab;
@property (nonatomic, strong)UILabel *phoneLab;
//@property (nonatomic, strong)UIImageView *phoneIm;
@property (nonatomic, strong)UIButton *callPhoneBtn;
@property (nonatomic, strong)UIView *lineView;

@end
