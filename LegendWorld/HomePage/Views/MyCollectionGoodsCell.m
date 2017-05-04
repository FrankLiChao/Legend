//
//  MyCollectionGoodsCell.m
//  LegendWorld
//
//  Created by wenrong on 16/11/3.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "MyCollectionGoodsCell.h"

@implementation MyCollectionGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.awardBtn setBackgroundImage:[UIImage backgroundStrokeImageWithColor:[UIColor colorFromHexRGB:@"ff5400"]] forState:UIControlStateNormal];
    [self.awardBtn setTitleColor:[UIColor colorFromHexRGB:@"ff5400"] forState:UIControlStateNormal];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (IBAction)getAwardAct:(UIButton *)sender {
    [self.delegate getAward:sender.tag];
}

@end
