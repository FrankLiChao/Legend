//
//  GoodsAppraiseTableViewCell.h
//  LegendWorld
//
//  Created by Frank on 2016/12/9.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsAppraiseModel.h"

@interface GoodsAppraiseTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headIm;//logo Image
@property (weak, nonatomic) IBOutlet UILabel *nameLab;//商品名称
@property (weak, nonatomic) IBOutlet UILabel *dateLab;//日期
@property (weak, nonatomic) IBOutlet UIImageView *start1;
@property (weak, nonatomic) IBOutlet UIImageView *start2;
@property (weak, nonatomic) IBOutlet UIImageView *start3;
@property (weak, nonatomic) IBOutlet UIImageView *start4;
@property (weak, nonatomic) IBOutlet UIImageView *start5;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;//评价内容
@property (weak, nonatomic) IBOutlet UIView *imageBgViewOne;//前三张图片的背景View
@property (weak, nonatomic) IBOutlet UIView *imageBgViewTwo;//后三张图片的背景View
@property (weak, nonatomic) IBOutlet UILabel *attrLab;//规格
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UIImageView *image4;
@property (weak, nonatomic) IBOutlet UIImageView *image5;
@property (weak, nonatomic) IBOutlet UIImageView *image6;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageBgViewOneHight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageBgViewTwoHight;

-(void)bindingDataForCell:(GoodsAppraiseModel *)model;

@end
