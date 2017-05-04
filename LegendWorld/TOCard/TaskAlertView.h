//
//  TaskAlertView.h
//  LegendWorld
//
//  Created by Tsz on 2016/11/28.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TaskType) {
    TaskTypeNone = 0,
    TaskTypeNewer = 1,
    TaskTypeOldDriver = 2
};

@interface TaskAlertView : UIView

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;

@property (nonatomic) NSInteger day;
@property (nonatomic) NSInteger hour;
@property (nonatomic) NSInteger minute;

@property (nonatomic) TaskType taskType;

- (void)show;
- (void)dismiss;

@end
