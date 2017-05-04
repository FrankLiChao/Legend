//
//  SwitchView.m
//  LegendWorld
//
//  Created by wenrong on 16/10/28.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "SwitchView.h"
#import "UIView+WZLBadge.h"

@interface SwitchView ()

@property (nonatomic, strong) NSMutableArray *titleLabels;
@property (nonatomic, weak) UIView *scrollLine;
@property (nonatomic, weak) UIImageView *switchImageView;
@property (nonatomic, weak) UIImageView *seperateLine;

@property (nonatomic) NSInteger currentLabelIndex;
@property (nonatomic) NSInteger imgIndex;
@property (nonatomic) BOOL isAsc;

@end

@implementation SwitchView

-(instancetype)initWithFrame:(CGRect)rect andTitles:(NSArray *)titles andScrollLineColor:(UIColor *)color andUnselecteColor:(UIColor *)unselecteColor
{
    self = [super initWithFrame:rect];
    if (self) {
        self.titleColor = color;
        self.unselecteTitleColor = unselecteColor;
        self.titles = titles;
    }
    return self;
}

- (instancetype)initWithTitles:(NSArray *)titles selectedColor:(UIColor *)selectedColor unselecteTitleColor:(UIColor *)unselectedColor {
    self = [super init];
    if (self) {
        self.titleColor = selectedColor;
        self.unselecteTitleColor = unselectedColor;
        self.titles = titles;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.bounds)/self.titleLabels.count;
    for (NSInteger i = 0; i < self.titleLabels.count; i++) {
        UILabel *label = self.titleLabels[i];
        label.frame = CGRectMake(i * width, 0, width, CGRectGetHeight(self.bounds));
    }
    CGFloat startX = MIN(self.currentLabelIndex * width, CGRectGetWidth(self.bounds) - width);
    self.scrollLine.frame = CGRectMake(startX, CGRectGetHeight(self.bounds) - 2, width, 2);
    self.switchImageView.frame = CGRectMake((self.imgIndex + 1) * width - 20, (CGRectGetHeight(self.bounds)-15)/2, 15, 15);
    self.seperateLine.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - 0.5, CGRectGetWidth(self.bounds), 0.5);
}

- (void)setupUI {
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.titleLabels = [NSMutableArray array];
    for (NSInteger index = 0; index < self.titles.count; index++) {
        UILabel *label = [[UILabel alloc] init];
        label.tag = index;
        label.text = self.titles[index];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = self.unselecteTitleColor;
        label.font = [UIFont bodyTextFont];
        label.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnLabel:)];
        [label addGestureRecognizer:tap];
        [self.titleLabels addObject:label];
        [self addSubview:label];
    }
    
    UIView *scrollLine = [[UIView alloc] init];
    self.scrollLine = scrollLine;
    self.scrollLine.backgroundColor = self.titleColor;
    self.scrollLine.userInteractionEnabled = NO;
    [self addSubview:self.scrollLine];
    
    UIImageView *seperateLine = [[UIImageView alloc] init];
    self.seperateLine = seperateLine;
    self.seperateLine.backgroundColor = [UIColor seperateColor];
    [self addSubview:self.seperateLine];
}

- (void)needImageViewAtBackWithIndex:(NSInteger)index {
    if (self.switchImageView == nil) {
        UIImageView *switchImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"price_no_order"]];
        self.switchImageView = switchImageView;
        self.switchImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.switchImageView];
    }
    self.imgIndex = index;
    [self setNeedsLayout];
}

- (void)tapOnLabel:(UITapGestureRecognizer *)tapIndex {
    UILabel *currentLabel = (UILabel *)tapIndex.view;
    if (self.switchImageView) {
        if (currentLabel.tag == self.imgIndex) {
            if (self.currentLabelIndex != self.imgIndex) {
                self.switchImageView.image = [UIImage imageNamed:@"price_order_asc"];
                self.isAsc = YES;
                [self performAction:self.imgIndex];
            } else {
                self.isAsc = !self.isAsc;
                self.switchImageView.image = [UIImage imageNamed: self.isAsc ? @"price_order_asc" : @"price_order_desc"];
                NSInteger index = self.isAsc ? self.imgIndex : self.imgIndex + 1;
                [self performAction:index];
            }
        } else {
            self.switchImageView.image = [UIImage imageNamed:@"price_no_order"];
            [self performAction:currentLabel.tag];
        }
    } else {
        [self performAction:currentLabel.tag];
    }
}

- (void)setCurrentIndex:(NSInteger)index {
    [self performAction:index];
}

- (void)performAction:(NSInteger)index {
    if (self.currentLabelIndex == index) {
        return;
    }
    
    if (self.currentLabelIndex >= self.titleLabels.count) {
        self.currentLabelIndex = self.titleLabels.count - 1;
    }
    UILabel *oldLabel = (UILabel *)self.titleLabels[self.currentLabelIndex];
    self.currentLabelIndex = index;
    if (index >= self.titleLabels.count) {
        index = self.titleLabels.count - 1;
    }
    UILabel *currentLabel = [self.titleLabels objectAtIndex:index];
    oldLabel.textColor = self.unselecteTitleColor;
    currentLabel.textColor = self.titleColor;
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect rect = self.scrollLine.frame;
        rect.origin.x = currentLabel.frame.origin.x;
        self.scrollLine.frame = rect;
    } completion:^(BOOL finished) {
        [self setNeedsLayout];
    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(swithView:didSelectItemAtIndex:)]) {
        [self.delegate swithView:self didSelectItemAtIndex:self.currentLabelIndex];
    }
}

- (void)setBadgeValue:(NSInteger)value atIndex:(NSInteger)index {
    UILabel *label = [self.titleLabels objectAtIndex:index];
    label.badgeBgColor = [UIColor themeColor];
    label.badgeFont = [UIFont systemFontOfSize:10];
    label.badgeTextColor = [UIColor whiteColor];
    label.badgeCenterOffset = CGPointMake(-12.5, 12.5);
    if (value <= 0) {
        [label clearBadge];
    } else {
        [label showBadgeWithStyle:WBadgeStyleNumber value:value animationType:WBadgeAnimTypeNone];
    }
    [label bringSubviewToFront:label.badge];
}

- (void)scrollViewDidScrollPercent:(CGFloat)percent {
    if (percent >= 0 && percent <= (1.0/self.titleLabels.count) * (self.titleLabels.count - 1)) {
        CGRect frame = self.scrollLine.frame;
        frame.origin.x = percent * CGRectGetWidth(self.bounds);
        self.scrollLine.frame = frame;
    }
}

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    [self setupUI];
    [self setNeedsLayout];
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    UILabel *currentLabel = self.titleLabels[self.currentLabelIndex];
    currentLabel.textColor = titleColor;
    self.scrollLine.backgroundColor = titleColor;
}

- (void)setUnselecteTitleColor:(UIColor *)unselecteTitleColor {
    _unselecteTitleColor = unselecteTitleColor;
    for (UILabel *label in self.titleLabels) {
        if (self.currentLabelIndex != [self.titleLabels indexOfObject:label]) {
            label.textColor = unselecteTitleColor;
        }
    }
}


@end
