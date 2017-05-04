//
//  GPClassifyPageView.m
//  GPFruit
//
//  Created by Angle on 15/9/23.
//  Copyright © 2015年  果铺电子商务有限公司. All rights reserved.
//

#import "GPClassifyPageView.h"
#import "UIView+Extension.h"

static const NSInteger kTopScrollHeight = 40;
static const NSInteger kLineHeight = 4;
static const CGFloat   kBtnFontSize = 15;
static const CGFloat   kBaseOfBtn = 60; //按钮间的距离
static const CGFloat   kTopLineHeight = 1;
static const CGFloat   kTopNameBackHeight = 0;

@interface GPClassifyPageView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView* topScrollView;

@property (nonatomic, strong) UILabel* line;
@property (nonatomic, strong) UIView*  nameBack;
@property (nonatomic, strong) UILabel* topLine;
@property (nonatomic, strong) UILabel* curNameLabel;
@property (nonatomic, strong) NSMutableArray* centerArray;
@property (nonatomic, strong) NSMutableArray* widthArray;
@property (nonatomic, strong) NSMutableArray* btnArray;
@property (nonatomic, assign) BOOL isBtnClick;

@end

@implementation GPClassifyPageView
#pragma mark - 生命周期

- (instancetype)init
{
    self = [super init];
    if (self) {
        _pagesView = [NSMutableArray new];
        _pagesName = [NSMutableArray new];
        _centerArray = [NSMutableArray new];
        _widthArray = [NSMutableArray new];
    }
    return self;
}

- (instancetype)initWithPagesView:(NSArray *)views names:(NSArray *)names andFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _pagesName = [NSMutableArray arrayWithArray:names];
        _pagesView = [NSMutableArray arrayWithArray:views];
        _centerArray = [NSMutableArray new];
        _widthArray = [NSMutableArray new];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self updateFrame];
}

-(void)dealloc
{

}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!_isBtnClick) {
        CGFloat needChange = 0;
        NSInteger tmp =0;
        for (NSInteger idx =0; idx < _centerArray.count; idx++)
        {
            NSNumber *num = _centerArray[idx];
            if (num.floatValue >= _line.center.x)
            {
                
                if (idx-1 >= 0)
                {
                    needChange = [_centerArray[idx] floatValue] - [_centerArray[idx-1] floatValue];
                    tmp = idx;
                    break;
                }
            }
        }
        
        float offset = 0;
        offset = needChange/self.width *(scrollView.contentOffset.x - (tmp -1) * self.width);
        if (tmp != 0) {
            _line.center = CGPointMake([_centerArray[tmp -1] floatValue] +  offset, kTopScrollHeight - kLineHeight/2.0);
        }
        
        _line.bounds = CGRectMake(0,
                                  0,
                                  [_widthArray[tmp -1] floatValue] + ([_widthArray[tmp] floatValue] - [_widthArray[tmp - 1] floatValue])/self.width *(scrollView.contentOffset.x - (tmp -1) *self.width),
                                  kLineHeight);
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        _curPage = (NSInteger)scrollView.contentOffset.x/self.width;
        [self changeTop];
        [self changeLine];
        
    }
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _curPage = (NSInteger)scrollView.contentOffset.x/self.width;
    [self changeTop];
    [self changeLine];
    
}


#pragma mark - 按钮方法
- (void)btnClick:(UIButton *)button
{
    _isBtnClick = YES;
    _curPage = button.tag - 200;
    [self changeContent];
    [self changeTop];
    [self changeLine];
}
/*
 * 主动点击按钮，调整scrollview 显示
 */
- (void)CustombtnClick:(NSInteger)index
{
    if (index >= self.pagesView.count) {
        return;
    }
    _isBtnClick = YES;
    _curPage = index;
    [self changeContent];
    [self changeTop];
    [self changeLine];
}

#pragma mark - 共有方法
- (void)setupView
{
    self.frame = CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight - 64);
    _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, kTopScrollHeight)];
    _topScrollView.showsHorizontalScrollIndicator = NO;
    _topScrollView.backgroundColor = [UIColor whiteColor];
    _topScrollView.bounces = NO;
    [self addSubview:_topScrollView];
    //计算按钮是否超出屏幕
    CGFloat width = 0;
    BOOL isOverWidth = NO;
    for (NSUInteger idx = 0; idx < _pagesName.count; ++idx) {
        CGSize size = [_pagesName[idx] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kBtnFontSize]}];
        width += size.width;
    }
    
    isOverWidth = (width+60) > DeviceMaxWidth;
    CGFloat centerX = 0;
    for (int idx = 0; idx < _pagesName.count; ++idx) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:_pagesName[idx] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:kBtnFontSize];
        CGSize size = [btn.currentTitle sizeWithAttributes:@{NSFontAttributeName:btn.titleLabel.font}];
        if (isOverWidth) {
            btn.frame = CGRectMake(centerX, 0, size.width, kTopScrollHeight - kLineHeight);
            centerX = btn.frame.origin.x + size.width + kBaseOfBtn;
        }else {
            btn.frame = CGRectMake(centerX, 0, DeviceMaxWidth/_pagesName.count, kTopScrollHeight - kLineHeight);
            centerX = btn.x + btn.width;
        }
        btn.tag = 200 + idx;
        [btn setTitleColor:contentTitleColorStr forState:UIControlStateNormal];
        [btn setTitleColor:mainColor forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_topScrollView addSubview:btn];
        
        [self.centerArray addObject:@(btn.center.x)];
        NSInteger tempWidth = DeviceMaxWidth / _pagesName.count;
        [self.widthArray addObject:@(tempWidth)];
        [self.btnArray addObject:btn];
    }
    
    _topScrollView.contentSize = CGSizeMake(centerX, kTopScrollHeight);
    
    _topLine = [[UILabel alloc] init];
    _topLine.frame = CGRectMake(0, _topScrollView.height-kTopLineHeight, DeviceMaxWidth+60, kTopLineHeight);
    _topLine.backgroundColor = contentTitleColorStr3;
    [_topScrollView addSubview:_topLine];
    
    NSNumber *num = [_centerArray firstObject];
    NSNumber *num2 = [_widthArray firstObject];
    _line = [[UILabel alloc] init];
    _line.frame = CGRectMake(num.floatValue - num2.floatValue/2, kTopScrollHeight - kLineHeight, num2.floatValue, kLineHeight);
    [_topScrollView addSubview:_line];
    _line.backgroundColor = mainColor;

    
    _nameBack = [[UIView alloc] init];
    _nameBack.frame = CGRectMake(0, _topLine.y + _topLine.height, DeviceMaxWidth, kTopNameBackHeight);
    _nameBack.backgroundColor = mainColor;
    [self addSubview:_nameBack];
    
    self.curNameLabel = [[UILabel alloc] init];
    self.curNameLabel.frame = CGRectMake(0, 0, _nameBack.width, _nameBack.height);
    self.curNameLabel.textAlignment = NSTextAlignmentCenter;
    self.curNameLabel.textColor = mainColor;
    self.curNameLabel.font = [UIFont systemFontOfSize:kBtnFontSize];
    self.curNameLabel.hidden = YES;
    [_nameBack addSubview:self.curNameLabel];
    
    CGFloat realContentHeight = 0;
    realContentHeight =  self.height;
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kTopScrollHeight +kTopNameBackHeight, DeviceMaxWidth, realContentHeight - kTopScrollHeight - kTopNameBackHeight)];
    _contentScrollView.delegate = self;
    _contentScrollView.contentSize = CGSizeMake(DeviceMaxWidth * _pagesName.count, 0);
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.clipsToBounds = YES;
    _contentScrollView.bounces = NO;
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_contentScrollView];
    
    for (int idx = 0; idx < _pagesView.count; ++idx) {
        UIView* subView = _pagesView[idx];
        subView.frame = CGRectMake(_contentScrollView.frame.size.width * idx, 0, _contentScrollView.frame.size.width, _contentScrollView.frame.size.height);
        [_contentScrollView addSubview:subView];
    }

    [self changeContent];
    [self changeTop];
    [self changeLine];
}

- (void)updateFrame
{
    CGFloat realContentHeight = 0;
    realContentHeight =  self.height;
    _contentScrollView.frame  = CGRectMake(0, kTopScrollHeight +kTopNameBackHeight, DeviceMaxWidth, realContentHeight - kTopScrollHeight - kTopNameBackHeight);
    for (int idx = 0; idx < _pagesView.count; ++idx) {
        UIView* subView = _pagesView[idx];
        subView.frame = CGRectMake(_contentScrollView.frame.size.width * idx, 0, _contentScrollView.frame.size.width, _contentScrollView.frame.size.height);
    }
}

#pragma mark - 私有方法

- (void)changeTop
{
    _isBtnClick = NO;
    CGFloat x = [_centerArray[_curPage] floatValue];
    [UIView animateWithDuration:0.3 animations:^{
        if (x> self.width/2.0 && x < _topScrollView.contentSize.width - self.width/2.0)
        {
            _topScrollView.contentOffset = CGPointMake( x - self.width/2.0, 0);
        }
        else if (x >= _topScrollView.contentSize.width - self.width/2.0)
        {
            _topScrollView.contentOffset = CGPointMake(_topScrollView.contentSize.width - self.width, 0);
        }
        else
        {
            _topScrollView.contentOffset = CGPointMake(0, 0);
        }
    }];
}

- (void)changeContent
{
    [UIView animateWithDuration:0.3 animations:^{
        _contentScrollView.contentOffset = CGPointMake(self.width *_curPage, 0);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)changeLine
{
    [UIView animateWithDuration:0.3 animations:^{
        _line.frame = CGRectMake([_centerArray[_curPage] floatValue] -[_widthArray[_curPage] floatValue]/2.0, kTopScrollHeight - kLineHeight, [_widthArray[_curPage] floatValue], kLineHeight);
    } completion:^(BOOL finished) {
        [self selectBtnWithIdx:_curPage];
    }];
}

- (void)selectBtnWithIdx:(NSInteger)idx
{
    for (int index = 0; index < self.btnArray.count;++index) {
        UIButton* btn = (UIButton *)[self.btnArray objectAtIndex:index];
        if (index == idx) {
            btn.selected = YES;
            CATransition *animation = [CATransition animation];
            animation.duration = 0.25f;
            self.curNameLabel.text = _pagesName[index];
            [self.curNameLabel.layer addAnimation:animation forKey:nil];
            
            [self.delegate selectedPage:self.curPage];
        }else
        {
            btn.selected = NO;
        }
    }
}

#pragma mark - 设置，获取方法
- (NSMutableArray *)centerArray
{
    if (!_centerArray) {
        _centerArray = [NSMutableArray array];
    }
    return _centerArray;
}

- (NSMutableArray *)widthArray
{
    if (!_widthArray) {
        _widthArray = [NSMutableArray array];
    }
    return _widthArray;
}

- (NSMutableArray *)btnArray
{
    if (!_btnArray) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

@end
