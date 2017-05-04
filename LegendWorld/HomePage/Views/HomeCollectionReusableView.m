//
//  HomeCollectionReusableView.m
//  LegendWorld
//
//  Created by Frank on 2016/11/1.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "HomeCollectionReusableView.h"

@implementation HomeCollectionReusableView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _titleIm = [UIImageView new];
        _titleIm.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_titleIm];
        
        _titleIm.sd_layout
        .centerXEqualToView(self)
        .heightIs(40)
        .yIs(0)
        .widthIs(133);
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

@end
