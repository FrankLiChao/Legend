//
//  ShoppingCartHeader.m
//  LegendWorld
//
//  Created by Tsz on 2016/11/4.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "ShoppingCartHeaderView.h"

@interface ShoppingCartHeaderView()

@property (nonatomic, weak) UIImageView *line;

@end

@implementation ShoppingCartHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *line = [[UIImageView alloc] init];
        self.line = line;
        self.line.backgroundColor = [UIColor seperateColor];
        [self.contentView addSubview:self.line];
        
        UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.checkBtn = checkBtn;
        [self.checkBtn setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
        [self.checkBtn setImage:[UIImage imageNamed:@"check"] forState:UIControlStateSelected];
        [self.contentView addSubview:self.checkBtn];
        
        UILabel *sellerNameLabel = [[UILabel alloc] init];
        self.sellerNameLabel = sellerNameLabel;
        self.sellerNameLabel.numberOfLines = 1;
        self.sellerNameLabel.backgroundColor = [UIColor clearColor];
        self.sellerNameLabel.font = [UIFont systemFontOfSize:15];
        self.sellerNameLabel.textColor = [UIColor bodyTextColor];
        self.sellerNameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.sellerNameLabel];
        
        UIImageView *indicateImgView = [[UIImageView alloc] init];
        self.indicatImgView = indicateImgView;
        self.indicatImgView.contentMode = UIViewContentModeScaleAspectFit;
        self.indicatImgView.image = [UIImage imageNamed:@"arrow_right"];
        [self.contentView addSubview:self.indicatImgView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.line.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), 0.5);
    self.checkBtn.frame = CGRectMake(5, 0, 35, CGRectGetHeight(self.bounds));
    self.sellerNameLabel.frame = CGRectMake(CGRectGetMaxX(self.checkBtn.frame), 0, CGRectGetWidth(self.bounds) - (CGRectGetMaxX(self.checkBtn.frame) + 10 + 15) , CGRectGetHeight(self.bounds));
    self.indicatImgView.frame = CGRectMake(CGRectGetWidth(self.bounds) - 15 - 10, (CGRectGetHeight(self.bounds) - 15)/2, 10, 15);
}


@end
