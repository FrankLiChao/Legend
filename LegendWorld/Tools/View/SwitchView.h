//
//  SwitchView.h
//  LegendWorld
//
//  Created by wenrong on 16/10/28.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SwitchView;
@protocol SwitchViewDelegate <NSObject>

- (void)swithView:(SwitchView *)switchView didSelectItemAtIndex:(NSInteger)index;

@end


@interface SwitchView : UIView

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *unselecteTitleColor;
@property (nonatomic, weak) id <SwitchViewDelegate> delegate;
@property (nonatomic, readonly) NSInteger currentLabelIndex;

- (instancetype)initWithFrame:(CGRect)rect andTitles:(NSArray *)titles andScrollLineColor:(UIColor *)color andUnselecteColor:(UIColor *)unselecteColor;
- (instancetype)initWithTitles:(NSArray *)titles selectedColor:(UIColor *)selectedColor unselecteTitleColor:(UIColor *)unselectedColor;

- (void)needImageViewAtBackWithIndex:(NSInteger)index;

- (void)setCurrentIndex:(NSInteger)index;
- (void)setBadgeValue:(NSInteger)value atIndex:(NSInteger)index;
- (void)scrollViewDidScrollPercent:(CGFloat)percent;

@end
