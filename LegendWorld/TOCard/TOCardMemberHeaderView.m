//
//  TOCardMemberHeaderView.m
//  LegendWorld
//
//  Created by Tsz on 2016/11/28.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "TOCardMemberHeaderView.h"

@implementation TOCardMemberHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc] init];
        self.titleLabel = titleLabel;
        self.titleLabel.numberOfLines = 1;
        self.titleLabel.font = [UIFont bodyTextFont];
        self.titleLabel.textColor = [UIColor bodyTextColor];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.titleLabel];
        
        UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.infoBtn = infoBtn;
        self.infoBtn.titleLabel.font = [UIFont buttonTextFont];
        [self.infoBtn setTitle:@"查看任务进度 >" forState:UIControlStateNormal];
        [self.infoBtn setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
        [self.infoBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [self.contentView addSubview:self.infoBtn];
        
        UILabel *infoLabel = [[UILabel alloc] init];
        self.infoLabel = infoLabel;
        self.infoLabel.numberOfLines = 1;
        self.infoLabel.font = [UIFont noteTextFont];
        self.infoLabel.textColor = [UIColor bodyTextColor];
        self.infoLabel.textAlignment = NSTextAlignmentRight;
        self.infoLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.infoLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(15, 0, (CGRectGetWidth(self.contentView.bounds) - 30)/2, CGRectGetHeight(self.contentView.bounds));
    self.infoBtn.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame), 0, (CGRectGetWidth(self.contentView.bounds) - 30)/2, CGRectGetHeight(self.contentView.bounds));
    self.infoLabel.frame = self.infoBtn.frame;
}

- (void)setInfoLabelRemainCount:(NSInteger)count {
    NSString *remainString = [NSString stringWithFormat:@"%ld", (long)count];
    NSString *string = [NSString stringWithFormat:@"当前成员数还差%@人",remainString];
    NSRange remainRange = [string rangeOfString:remainString];
    NSMutableAttributedString *mstring = [[NSMutableAttributedString alloc] initWithString:string];
    [mstring addAttributes:@{NSForegroundColorAttributeName: [UIColor themeColor]} range:remainRange];
    self.infoLabel.attributedText = mstring;
}

- (void)setInfoLabelBenifitLayer:(NSInteger)count {
    NSString *remainString = [NSString stringWithFormat:@"%ld", (long)count];
    NSString *string = [NSString stringWithFormat:@"可享受%@层关联收益",remainString];
    NSRange remainRange = [string rangeOfString:remainString];
    NSMutableAttributedString *mstring = [[NSMutableAttributedString alloc] initWithString:string];
    [mstring addAttributes:@{NSForegroundColorAttributeName: [UIColor themeColor]} range:remainRange];
    self.infoLabel.attributedText = mstring;
}

@end
