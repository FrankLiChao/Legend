//
//  ChooseView.h
//  LegendWorld
//
//  Created by Frank on 2016/11/10.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseViewDelegate <NSObject>

-(void)ChooseTypeEvet:(NSInteger)type;

@end

@interface ChooseView : UIView

@property (nonatomic, weak)id <ChooseViewDelegate> delegate;
@property (nonatomic)NSInteger type;//收益类型

@end
