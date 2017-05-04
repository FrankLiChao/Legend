//
//  HotWordCollectionViewCell.m
//  LegendWorld
//
//  Created by Tsz on 2016/10/31.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "HotWordCollectionViewCell.h"

@implementation HotWordCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor backgroundColor];
    self.textLabel.textColor = [UIColor bodyTextColor];
    self.textLabel.font = [UIFont bodyTextFont];
    
}

@end
