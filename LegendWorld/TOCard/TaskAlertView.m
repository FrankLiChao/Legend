//
//  TaskAlertView.m
//  LegendWorld
//
//  Created by Tsz on 2016/11/28.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "TaskAlertView.h"

@implementation TaskAlertView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.layer.cornerRadius = 6;
    
    [self.actionBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.actionBtn setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    [self.actionBtn setBackgroundImage:[UIImage backgroundStrokeImageWithColor:[UIColor themeColor]] forState:UIControlStateNormal];
    [self.actionBtn addTarget:self action:@selector(taskAlertActionEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackground:)];
    [self addGestureRecognizer:tap];
}

- (void)show {
    self.backgroundColor = [UIColor clearColor];
    self.contentView.alpha = 0;
    self.contentView.transform = CGAffineTransformMakeScale(1.5, 1.5);
    self.frame = [UIScreen mainScreen].bounds;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.alpha = 1;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }];
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.contentView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.contentView.alpha = 0;
        self.contentView.transform = CGAffineTransformMakeScale(1.5, 1.5);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)tapBackground:(id)sender {
    [self dismiss];
}

- (void)taskAlertActionEvent:(id)sender {
    [self dismiss];
}

- (void)setTaskType:(TaskType)taskType {
    _taskType = taskType;
    switch (taskType) {
        case 1: {
            self.imageView.image = [UIImage imageNamed:@"newer"];
            [self setContentLabelText:@"在30天内完成6个团队成员的建设，即奖励48元现金！"];
            [self setTimeLabelTextWithDay:self.day hour:self.hour minute:self.minute];
            break;
        }
        case 2: {
            self.imageView.image = [UIImage imageNamed:@"old_driver"];
            [self setContentLabelText:@"在60天内6个团队成员全部完成6人队伍搭建，再奖励98元现金！" ];
            [self setTimeLabelTextWithDay:self.day hour:self.hour minute:self.minute];
            break;
        }
        default:
            break;
    }
}

- (void)setContentLabelText:(NSString *)text {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 7.5;
    [string addAttributes:@{NSParagraphStyleAttributeName: style} range:NSMakeRange(0, string.length)];
    self.contentLabel.attributedText = string;
}

- (void)setTimeLabelTextWithDay:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute {
    NSString *dayStr = [NSString stringWithFormat:@"%ld", (long)day];
    NSString *hourStr = [NSString stringWithFormat:@"%ld", (long)hour];
    NSString *minuteStr = [NSString stringWithFormat:@"%ld", (long)minute];
    NSString *timeString = [NSString stringWithFormat:@"距离您任务结束还有%@天%@时%@分哦", dayStr, hourStr, minuteStr];
    NSRange dayRang = [timeString rangeOfString:[NSString stringWithFormat:@"%@天", dayStr]];
    NSRange hourRang = [timeString rangeOfString:[NSString stringWithFormat:@"%@时", hourStr]];
    NSRange minuteRang = [timeString rangeOfString:[NSString stringWithFormat:@"%@分", minuteStr]];
    NSMutableAttributedString *time = [[NSMutableAttributedString alloc] initWithString:timeString];
    [time addAttributes:@{NSForegroundColorAttributeName: [UIColor themeColor]} range:NSMakeRange(dayRang.location, dayRang.length - 1)];
    [time addAttributes:@{NSForegroundColorAttributeName: [UIColor themeColor]} range:NSMakeRange(hourRang.location, hourRang.length - 1)];
    [time addAttributes:@{NSForegroundColorAttributeName: [UIColor themeColor]} range:NSMakeRange(minuteRang.location, minuteRang.length - 1)];
    self.timeLabel.attributedText = time;
}

@end
