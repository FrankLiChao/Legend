//
//  GPClassifyPageView.h
//  GPFruit
//
//  Created by Angle on 15/9/23.
//  Copyright © 2015年  果铺电子商务有限公司. All rights reserved.
//  左右滑动

#import <UIKit/UIKit.h>


/**
 *  通知外部，分页发生变化
 */
@protocol GPClassifyPageDelegate <NSObject>

@required
- (void)selectedPage:(NSInteger)page;

@end

//上边栏分类组件，可代码，也可xib使用
@interface GPClassifyPageView : UIView

/**
 *  用于展示的视图，只能是UIView
 */
@property (nonatomic, strong) NSMutableArray* pagesView;
/**
 *  各个分页的名字
 */
@property (nonatomic, copy) NSArray* pagesName;

@property (nonatomic, assign) NSInteger curPage;
@property (nonatomic, strong) UIScrollView* contentScrollView;
@property (nonatomic, weak) id<GPClassifyPageDelegate> delegate;

- (instancetype)initWithPagesView:(NSArray*)views names:(NSArray *)names andFrame:(CGRect)frame;

- (void)setupView;
- (void)updateFrame;

/*
 * 主动点击按钮，调整scrollview 显示
 */
- (void)CustombtnClick:(NSInteger)index;
@end
