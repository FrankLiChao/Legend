//
//  GoodsAttrCollectionViewCell.m
//  LegendWorld
//
//  Created by Tsz on 2016/11/8.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "GoodsAttrCollectionViewCell.h"

@implementation GoodsAttrCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.attrNameLabel.textColor = [UIColor noteTextColor];
    self.attrNameLabel.backgroundColor = [UIColor clearColor];
    self.attrNameLabel.layer.borderColor = [UIColor noteTextColor].CGColor;
    self.attrNameLabel.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        self.attrNameLabel.textColor = [UIColor whiteColor];
        self.attrNameLabel.backgroundColor = [UIColor themeColor];
        self.attrNameLabel.layer.borderColor = [UIColor clearColor].CGColor;
        self.attrNameLabel.layer.borderWidth = 0;
    } else {
        self.attrNameLabel.textColor = [UIColor noteTextColor];
        self.attrNameLabel.backgroundColor = [UIColor clearColor];
        self.attrNameLabel.layer.borderColor = [UIColor noteTextColor].CGColor;
        self.attrNameLabel.layer.borderWidth = 1;
    }
}

@end
