//
//  GradeView.m
//  LegendWorld
//
//  Created by Frank on 2016/11/4.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "GradeView.h"

@interface GradeView ()

@property (weak,nonatomic)UIView *bgView;
@property (weak,nonatomic)UIView *nowView;
@property (weak,nonatomic)UIImageView *tagView;
@property (weak,nonatomic)UILabel *tagLab;
@property (weak,nonatomic)UILabel *startLab;
@property (weak,nonatomic)UILabel *endLab;
@property (weak,nonatomic)UIView *pointView;
@property (weak,nonatomic)UIView *tempView;
@property(nonatomic)NSInteger nowNum;
@property(nonatomic)NSInteger totalNum;

@end

@implementation GradeView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _tempView = self;
        
        UIImageView *tagImage = [UIImageView new];
        [tagImage setImage:imageWithName(@"mine_grade")];
        self.tagView = tagImage;
        [self addSubview:tagImage];
        
        tagImage.sd_layout
        .leftSpaceToView(self,15*widthRate)
        .topSpaceToView(self,0)
        .widthIs(60)
        .heightIs(21);
        
        UILabel *tagLab = [UILabel new];
        tagLab.text = @"已完成1个";
        tagLab.textColor = [UIColor whiteColor];
        self.tagLab = tagLab;
        tagLab.textAlignment = NSTextAlignmentCenter;
        tagLab.font = [UIFont systemFontOfSize:11];
        [self addSubview:tagLab];
        
        tagLab.sd_layout
        .leftEqualToView(tagImage)
        .rightEqualToView(tagImage)
        .topEqualToView(tagImage)
        .heightIs(17);
        
        UIView *bgView = [UIView new];
        bgView.backgroundColor = contentTitleColorStr3;
        bgView.layer.cornerRadius = 5;
        bgView.layer.masksToBounds = YES;
        self.bgView = bgView;
        [self addSubview:bgView];
        
        bgView.sd_layout
        .leftSpaceToView(self,30)
        .rightSpaceToView(self,30)
        .heightIs(10)
        .topSpaceToView(tagImage,5);
        
        UIView *nowView = [UIView new];
        nowView.backgroundColor = mainColor;
        self.nowView = nowView;
        [bgView addSubview:nowView];
        
        nowView.sd_layout
        .leftEqualToView(bgView)
        .topEqualToView(bgView)
        .heightRatioToView(bgView,1)
        .widthIs(100);
        
        UIView *pointV = [UIView new];
        self.pointView = pointV;
        [self addSubview:pointV];
        
        pointV.sd_layout
        .leftEqualToView(bgView)
        .topEqualToView(bgView)
        .widthIs(0)
        .heightEqualToWidth();
        
        UILabel *startLab = [UILabel new];
        startLab.text = @"0个";
        startLab.textColor = contentTitleColorStr1;
        startLab.font = [UIFont systemFontOfSize:13];
        self.startLab = startLab;
        [self addSubview:startLab];
        
        startLab.sd_layout
        .leftEqualToView(bgView)
        .topSpaceToView(bgView,5)
        .widthIs(100)
        .heightIs(20);
        
        UILabel *endLab = [UILabel new];
        endLab.text = @"2个";
        endLab.textColor = contentTitleColorStr1;
        endLab.textAlignment = NSTextAlignmentRight;
        endLab.font = [UIFont systemFontOfSize:13];
        self.endLab = endLab;
        [self addSubview:endLab];
        
        endLab.sd_layout
        .rightEqualToView(bgView)
        .topEqualToView(startLab)
        .widthIs(100)
        .heightIs(20);
    }
    return self;
}

-(void)setVipModel:(VIPGreadeModel *)vipModel{
    NSInteger nowNum = [vipModel.complete_num integerValue];
    NSInteger totalNum = [vipModel.target_number integerValue];
    self.nowNum = nowNum;
    self.totalNum = totalNum;
    self.endLab.text = [NSString stringWithFormat:@"%ld个",(long)totalNum];
    self.tagLab.text = [NSString stringWithFormat:@"已完成%ld个",(long)nowNum];
}

-(void)drawRect:(CGRect)rect{
    CGFloat nowNum = self.nowNum;
    CGFloat totalNum = self.totalNum;
    if (totalNum == 0) {
        return;
    }
    self.nowView.sd_layout
    .widthIs((DeviceMaxWidth-60)*(nowNum/totalNum));
    if (nowNum == 0) {
        self.tagView.sd_layout
        .leftSpaceToView(_tempView,15*widthRate);
        
    }else if (nowNum == totalNum) {
        self.tagView.sd_layout
        .rightSpaceToView(_tempView,15*widthRate);
    }else{
        self.tagView.sd_layout
        .leftSpaceToView(_pointView,(DeviceMaxWidth-60)*(nowNum/totalNum)-30);
    }
    [self.tagView updateLayout];
}

@end
