//
//  ShoppingCartFooterView.m
//  LegendWorld
//
//  Created by Tsz on 2016/11/7.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "ShoppingCartFooterView.h"

@interface ShoppingCartFooterView()

@property (nonatomic, weak) UIImageView *line;

@end

@implementation ShoppingCartFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *endorseInfoLabel = [[UILabel alloc] init];
        self.endorseInfoLabel = endorseInfoLabel;
        self.endorseInfoLabel.numberOfLines = 1;
        self.endorseInfoLabel.font = [UIFont noteTextFont];
        self.endorseInfoLabel.textAlignment = NSTextAlignmentLeft;
        self.endorseInfoLabel.textColor = [UIColor bodyTextColor];
        [self.contentView addSubview:self.endorseInfoLabel];
        
        UIButton *makeUpBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        self.makeUpBtn = makeUpBtn;
        self.makeUpBtn.tintColor = [UIColor themeColor];
        self.makeUpBtn.titleLabel.font = [UIFont noteTextFont];
        [self.makeUpBtn setTitle:@"去凑单" forState:UIControlStateNormal];
        [self.makeUpBtn setImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];
        [self.makeUpBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 65 - 10, 0, 0)];
        [self.makeUpBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -25, 0, 0)];
        [self.contentView addSubview:self.makeUpBtn];
        
        UIImageView *line = [[UIImageView alloc] init];
        self.line = line;
        self.line.backgroundColor = [UIColor seperateColor];
        [self.contentView addSubview:self.line];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), 40);
    
    self.makeUpBtn.frame = CGRectMake(CGRectGetWidth(self.contentView.bounds) - 15 - 65, 0, 65, CGRectGetHeight(self.contentView.bounds));
    self.endorseInfoLabel.frame = CGRectMake(40, 0, CGRectGetWidth(self.contentView.bounds) - 40 - CGRectGetWidth(self.makeUpBtn.frame) - 15, CGRectGetHeight(self.contentView.bounds));
    self.line.frame = CGRectMake(0, CGRectGetHeight(self.contentView.bounds) - 0.5, CGRectGetWidth(self.contentView.bounds), 0.5);
}

@end
