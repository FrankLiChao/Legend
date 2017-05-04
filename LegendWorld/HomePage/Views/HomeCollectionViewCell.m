//
//  HomeCollectionViewCell.m
//  LegendWorld
//
//  Created by Frank on 2016/11/1.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "HomeCollectionViewCell.h"

@implementation HomeCollectionViewCell

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _backGroundIm = [[UIImageView alloc] initWithFrame:frame];
        _backGroundIm.layer.borderWidth = 0.5;
        _backGroundIm.layer.borderColor = viewColor.CGColor;
        [_backGroundIm setImage:imageWithName(@"a2.jpg")];
        [self.contentView addSubview:_backGroundIm];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backGroundIm.frame = self.contentView.bounds;
}

@end
