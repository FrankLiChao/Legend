//
//  CountdownLabel.h
//  LegendWorld
//
//  Created by Frank on 2016/11/8.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountdownLabel : UILabel

-(void)startCountdownTime:(NSTimeInterval)serverTime;

-(void)endCountdownTime;

@end
