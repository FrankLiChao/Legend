//
//  CountdownLabel.m
//  LegendWorld
//
//  Created by Frank on 2016/11/8.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "CountdownLabel.h"

@interface CountdownLabel ()

@property (strong,nonatomic)UILabel *dayLab;//天
@property (strong,nonatomic)UILabel *hourLab;//小时
@property (strong,nonatomic)UILabel *minuteLab;//分钟
@property (strong,nonatomic)UILabel *secondLab;//秒

@property (nonatomic)NSTimeInterval timeCount;
@property (strong,nonatomic)NSTimer *myTimer;

@property(nonatomic)BOOL timeTag;


@end

@implementation CountdownLabel

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *bgView = [UIView new];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        
        bgView.sd_layout
        .leftSpaceToView(self,0)
        .rightSpaceToView(self,0)
        .heightIs(30*widthRate)
        .centerYEqualToView(self);
        
        _secondLab = [UILabel new];
        _secondLab.text = @"00";
        _secondLab.textColor = [UIColor whiteColor];
        _secondLab.font = [UIFont systemFontOfSize:11];
        _secondLab.textAlignment = NSTextAlignmentCenter;
        _secondLab.backgroundColor = [UIColor blackColor];
        [bgView addSubview:_secondLab];
        
        _secondLab.sd_layout
        .rightSpaceToView(bgView,0)
        .centerYEqualToView(bgView)
        .widthIs(17*widthRate)
        .heightIs(15*widthRate);
        
        UILabel *pointLab = [UILabel new];
        pointLab.text = @":";
        pointLab.textColor = contentTitleColorStr2;
        pointLab.textAlignment = NSTextAlignmentCenter;
        pointLab.font = [UIFont systemFontOfSize:11];
        [bgView addSubview:pointLab];
        
        pointLab.sd_layout
        .rightSpaceToView(_secondLab,0)
        .centerYEqualToView(bgView)
        .widthIs(10*widthRate)
        .heightIs(15*widthRate);
        
        _minuteLab = [UILabel new];
        _minuteLab.text = @"00";
        _minuteLab.textColor = [UIColor whiteColor];
        _minuteLab.font = [UIFont systemFontOfSize:11];
        _minuteLab.textAlignment = NSTextAlignmentCenter;
        _minuteLab.backgroundColor = [UIColor blackColor];
        [bgView addSubview:_minuteLab];
        
        _minuteLab.sd_layout
        .rightSpaceToView(pointLab,0)
        .centerYEqualToView(bgView)
        .widthIs(17*widthRate)
        .heightIs(15*widthRate);
        
        UILabel *mpoint = [UILabel new];
        mpoint.text = @":";
        mpoint.textColor = contentTitleColorStr2;
        mpoint.textAlignment = NSTextAlignmentCenter;
        mpoint.font = [UIFont systemFontOfSize:11];
        [bgView addSubview:mpoint];
        
        mpoint.sd_layout
        .rightSpaceToView(_minuteLab,0)
        .centerYEqualToView(bgView)
        .widthIs(10*widthRate)
        .heightIs(15*widthRate);
        
        _hourLab = [UILabel new];
        _hourLab.text = @"00";
        _hourLab.textColor = [UIColor whiteColor];
        _hourLab.font = [UIFont systemFontOfSize:11];
        _hourLab.textAlignment = NSTextAlignmentCenter;
        _hourLab.backgroundColor = [UIColor blackColor];
        [bgView addSubview:_hourLab];
        
        _hourLab.sd_layout
        .rightSpaceToView(mpoint,0)
        .centerYEqualToView(bgView)
        .widthIs(17*widthRate)
        .heightIs(15*widthRate);
        
        UILabel *hday = [UILabel new];
        hday.text = @"天";
        hday.textColor = contentTitleColorStr2;
        hday.textAlignment = NSTextAlignmentCenter;
        hday.font = [UIFont systemFontOfSize:11];
        [bgView addSubview:hday];
        
        hday.sd_layout
        .rightSpaceToView(_hourLab,0)
        .centerYEqualToView(bgView)
        .widthIs(17*widthRate)
        .heightIs(15*widthRate);
        
        _dayLab = [UILabel new];
        _dayLab.text = @"00";
        _dayLab.textColor = [UIColor whiteColor];
        _dayLab.font = [UIFont systemFontOfSize:11];
        _dayLab.textAlignment = NSTextAlignmentCenter;
        _dayLab.backgroundColor = [UIColor blackColor];
        [bgView addSubview:_dayLab];
        
        _dayLab.sd_layout
        .rightSpaceToView(hday,0)
        .centerYEqualToView(bgView)
        .widthIs(17*widthRate)
        .heightIs(15*widthRate);
        
        UILabel *haveLab = [UILabel new];
        haveLab.text = @"还有";
        haveLab.textColor = contentTitleColorStr2;
        haveLab.textAlignment = NSTextAlignmentCenter;
        haveLab.font = [UIFont systemFontOfSize:11];
        [bgView addSubview:haveLab];
        
        haveLab.sd_layout
        .rightSpaceToView(_dayLab,0)
        .centerYEqualToView(bgView)
        .widthIs(30*widthRate)
        .heightIs(15*widthRate);
    }
    return self;
}

-(void)startCountdownTime:(NSTimeInterval)serverTime{
    _timeCount = serverTime;
    [self dealWithTime:_timeCount];
    if (!_myTimer) {
        _myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(myTimerEvent) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_myTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)dealWithTime:(NSInteger)timeNumber
{
    NSInteger day = timeNumber/(24*3600);
    NSInteger hour = (timeNumber%(24*3600))/3600;
    NSInteger minutes = (timeNumber%3600)/60;
    NSInteger seconds = timeNumber%60;
    
    if (day > 1000) {
        self.timeTag = YES;
    }else{
        self.timeTag = NO;
    }
    NSString * dayStr = [NSString stringWithFormat:@"%ld",(long)day];
    NSString * hourStr = [NSString stringWithFormat:@"%ld",(long)hour];
    if (hour < 10 && hour > 0) {
        hourStr = [NSString stringWithFormat:@"0%ld",(long)hour];
    }
    NSString * minutesStr = [NSString stringWithFormat:@"%ld",(long)minutes];
    if (minutes < 10 && minutes > 0) {
        minutesStr = [NSString stringWithFormat:@"0%@",minutesStr];
    }
    NSString * secondsStr = [NSString stringWithFormat:@"%ld",(long)seconds];
    if (seconds < 10) {
        secondsStr = [NSString stringWithFormat:@"0%@",secondsStr];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (timeNumber>0) {
            _hourLab.text = [NSString stringWithFormat:@"%@",hourStr];
            _minuteLab.text = [NSString stringWithFormat:@"%@",minutesStr];
            _secondLab.text = [NSString stringWithFormat:@"%@",secondsStr];
            if(day <= 0){
                _dayLab.text = @"00";
            }else if (day >= 10000) {
                _dayLab.text = [NSString stringWithFormat:@"%.1f万",[dayStr floatValue]/10000];
            }
            else{
                _dayLab.text = [NSString stringWithFormat:@"%@",dayStr];;
            }
        }
    });
}

-(void)myTimerEvent{
    _timeCount--;
    if (_timeCount > 0) {
        [self dealWithTime:_timeCount];
    }else
    {
        if (_myTimer) {
            [_myTimer invalidate];
            _myTimer = nil;
        }
    }
}

-(void)endCountdownTime{
    if (_myTimer) {
        [_myTimer invalidate];
        _myTimer = nil;
    }
}

-(void)drawRect:(CGRect)rect{
    if (self.timeTag) {
        _dayLab.sd_layout
        .minWidthIs(17*widthRate)
        .rightSpaceToView(_hourLab,25);
        [_dayLab setSingleLineAutoResizeWithMaxWidth:100];
        [_dayLab updateLayout];
    }else{
        _dayLab.sd_layout
        .minWidthIs(17*widthRate)
        .rightSpaceToView(_hourLab,18);
        [_dayLab setSingleLineAutoResizeWithMaxWidth:50];
        [_dayLab updateLayout];
    }
}



@end
