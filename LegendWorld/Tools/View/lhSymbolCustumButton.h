//
//  lhSymbolCustumButton.h
//  Drive
//
//  Created by Frank on 15/7/29.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>

//自定义按钮
@interface lhSymbolCustumButton : UIButton

@property (nonatomic,strong)UIImageView * tImgView;//图片
@property (nonatomic,strong)UILabel * tLabel;//按钮名字
@property (nonatomic,strong)UIButton * imgBtn;//图片

//用于主页功能按钮
- (instancetype)initWithFrame1:(CGRect)frame;
//用于分享选择按钮
- (instancetype)initWithFrame2:(CGRect)frame;
//用于上图下文字的小按钮
- (instancetype)initWithFrame3:(CGRect)frame;
@end
