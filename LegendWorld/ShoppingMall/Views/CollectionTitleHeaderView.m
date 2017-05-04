//
//  CollectionTitleHeaderView.m
//  LegendWorld
//
//  Created by Tsz on 2016/10/31.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "CollectionTitleHeaderView.h"

@implementation CollectionTitleHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.textLabel.font = [UIFont titleTextFont];
    self.textLabel.textColor = [UIColor titleTextColor];
}

@end
