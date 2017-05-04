//
//  DefineButton.m
//  LegendWorld
//
//  Created by Frank on 2016/12/12.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "DefineButton.h"

@implementation DefineButton

-(instancetype)initWithFrame:(CGRect)frame{
    self =  [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(void)commonInit{
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.titleLabel.font = [UIFont systemFontOfSize:13];
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake((contentRect.size.width-80)/2, 45, 80, 15);
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake((contentRect.size.width-25)/2, 10, 25, 25);
}

-(void)layoutSubviews{
    [super layoutSubviews];
    //Center text
    CGRect newFrame = [self titleLabel].frame;
    newFrame.origin.x = 0;
    newFrame.origin.y = 45;
    newFrame.size.width = self.frame.size.width;
    
    self.titleLabel.frame = newFrame;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

@end
