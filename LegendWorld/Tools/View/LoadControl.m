//
//  LoadControl.m
//  LegendWorld
//
//  Created by Tsz on 2016/11/4.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "LoadControl.h"
#import "RefreshControl.h"

typedef NS_ENUM(NSInteger, LoadState) {
    LoadStateNormal = 1,
    LoadStateLoading = 2,
    LoadStateLoadSuccessed = 3,
    LoadStateLoadFailed = 4,
    LoadStateLoadAll = 5
};

static NSString *const titleNormal = @"上拉加载更多";
static NSString *const titleLoading = @"加载中...";
static NSString *const titleLoadSuccessed = @"加载成功";
static NSString *const titleLoadFailed = @"加载失败";
static NSString *const titleLoadAll = @"全部加载完成";

static CGFloat const LoadControlHeight = 50.0;
static CGFloat const LoadPeriod = 1.0;
static CGSize const imageSize = {20, 20};

static NSString *const contentOffsetKeyPath = @"contentOffset";
static NSString *const contentSizeKeyPath = @"contentSize";

@interface LoadControl()

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic) LoadState loadState;

@property (nonatomic) UIEdgeInsets originalInset;
@property (nonatomic) CGSize previousContentSize;
@property (nonatomic, strong) NSString *titleText;

@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *loadImage;
@property (nonatomic, strong) UIImage *successImage;
@property (nonatomic, strong) UIImage *failImage;

@end

@implementation LoadControl

#pragma mark - Life Cycle
- (instancetype)initWithScrollView:(UIScrollView *)scrollView {
    self = [super init];
    if (self) {
        self.scrollView = scrollView;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        self.imageView = imageView;
        self.imageView.backgroundColor = [UIColor clearColor];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.imageView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        self.titleLabel = titleLabel;
        self.titleLabel.numberOfLines = 1;
        self.titleLabel.font = [UIFont systemFontOfSize:12.5];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.titleLabel];
        
        [self.scrollView insertSubview:self atIndex:0];
        
        self.displayCondition = ^{ return YES; };
        self.loadAllCondition = ^{ return NO; };
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat seperate = 10.0;
    CGFloat totalWidth = imageSize.width + seperate + self.titleLabel.frame.size.width;
    self.imageView.frame = CGRectMake((self.bounds.size.width - totalWidth)/2, (self.bounds.size.height - imageSize.height)/2, imageSize.width, imageSize.height);
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + seperate, (CGRectGetHeight(self.bounds) - self.titleLabel.frame.size.height)/2, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    if (self.window) {
        [self.scrollView addObserver:self forKeyPath:contentOffsetKeyPath options:NSKeyValueObservingOptionNew context:nil];
        [self.scrollView addObserver:self forKeyPath:contentSizeKeyPath options:NSKeyValueObservingOptionNew context:nil];
    } else {
        [self.scrollView removeObserver:self forKeyPath:contentOffsetKeyPath];
        [self.scrollView removeObserver:self forKeyPath:contentSizeKeyPath];
    }
}

- (void)didMoveToSuperview {
    if (self.superview) {
        self.originalInset = self.scrollView.contentInset;
    } else {
        self.originalInset = UIEdgeInsetsZero;
    }
}

#pragma mark - Event
- (void)beginLoading {
    if (self.isLoading) {
        return;
    }
    self.loadState = LoadStateLoading;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)endLoading:(BOOL)isSuccess {
    if (!self.isLoading) {
        return;
    }
    self.loadState = isSuccess ? LoadStateLoadSuccessed : LoadStateLoadFailed;
    CGFloat timeOffset = isSuccess ? 0.5 : 1.0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeOffset * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        BOOL isLoadAll = self.loadAllCondition();
        self.loadState = isLoadAll ? LoadStateLoadAll : LoadStateNormal;
    });
}

#pragma mark - Observing
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {    
    if ([keyPath isEqualToString:contentOffsetKeyPath]) {
        BOOL isDisplay = self.displayCondition();
        BOOL isLoadAll = self.loadAllCondition();
        if (isLoadAll) {
            isDisplay = NO;
        }
        
        if (self.isHidden || !isDisplay) {
            return;
        }
        if (self.loadState == LoadStateLoading || self.loadState == LoadStateLoadSuccessed || self.loadState == LoadStateLoadFailed || self.loadState == LoadStateLoadAll) {
            return;
        }
        CGFloat offsetY = self.scrollView.contentOffset.y;
        if (offsetY > self.scrollView.contentSize.height + self.originalInset.bottom + LoadControlHeight - self.scrollView.bounds.size.height && (self.scrollView.isDecelerating || self.scrollView.isDragging)) {
            [self beginLoading];
        } else {
            self.loadState = LoadStateNormal;
        }
    } else if ([keyPath isEqualToString:contentSizeKeyPath]) {
        if (self.previousContentSize.height == self.scrollView.contentSize.height) {
            return;
        }
        self.frame = CGRectMake(0, self.scrollView.contentSize.height, CGRectGetWidth(self.scrollView.bounds), LoadControlHeight);
        [self layoutIfNeeded];
        
        BOOL isDisplay = self.displayCondition();
        BOOL isLoadAll = self.loadAllCondition();
        if (isLoadAll) {
            isDisplay = NO;
        }
        
        self.hidden = !isDisplay;
        if (self.isHidden == NO) {
            UIEdgeInsets inset = self.scrollView.contentInset;
            inset.bottom = self.originalInset.bottom + LoadControlHeight;
            self.scrollView.contentInset = inset;
        } else {
            UIEdgeInsets inset = self.scrollView.contentInset;
            inset.bottom = self.originalInset.bottom;
            self.scrollView.contentInset = inset;
        }
        self.loadState = isLoadAll ? LoadStateLoadAll: LoadStateNormal;
        self.previousContentSize = self.scrollView.contentSize;
    }
}

#pragma mark - Getter & Setter
- (BOOL)isLoading {
    return self.loadState == LoadStateLoading;
}

- (void)setTitleText:(NSString *)titleText {
    self.titleLabel.text = titleText;
    [self.titleLabel sizeToFit];
    [self layoutIfNeeded];
}

- (void)setColor:(UIColor *)color {
    _color = color;
    self.titleLabel.textColor = color;
    
    self.normalImage = [[UIImage imageNamed:@"arrow_down"] redrawingWithTintColor:self.color];
    self.loadImage = [[UIImage imageNamed:@"refresh"] redrawingWithTintColor:self.color];
    self.successImage = [[UIImage imageNamed:@"success"] redrawingWithTintColor:self.color];
    self.failImage = [[UIImage imageNamed:@"fail"] redrawingWithTintColor:self.color];
    
    switch (self.loadState) {
        case LoadStateNormal:
            self.imageView.image = self.normalImage;
            break;
        case LoadStateLoading:
            self.imageView.image = self.loadImage;
            break;
        case LoadStateLoadSuccessed:
            self.imageView.image = self.successImage;
            break;
        case LoadStateLoadFailed:
            self.imageView.image = self.failImage;
            break;
        case LoadStateLoadAll:
            self.imageView.image = self.successImage;
            break;
        default:
            break;
    }
}

- (void)setLoadState:(LoadState)loadState {
    if (_loadState == loadState) {
        return;
    }
    _loadState = loadState;
    switch (loadState) {
        case LoadStateNormal: {
            self.titleText = titleNormal;
            self.imageView.image = [[UIImage imageNamed:@"arrow_down"] redrawingWithTintColor:self.color];
            self.imageView.transform = CGAffineTransformMakeRotation(M_PI);
            [self.imageView.layer removeAllAnimations];
            break;
        }
        case LoadStateLoading: {
            self.titleText = titleLoading;
            self.imageView.image = [[UIImage imageNamed:@"refresh"] redrawingWithTintColor:self.color];
            self.imageView.transform = CGAffineTransformIdentity;
            [self.imageView.layer removeAllAnimations];
            
            CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            rotation.fromValue = 0;
            rotation.toValue = @(2 * M_PI);
            rotation.duration = LoadPeriod;
            rotation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            rotation.repeatCount = HUGE_VALF;
            [self.imageView.layer addAnimation:rotation forKey:@"RotateAnimation"];
            break;
        }
        case LoadStateLoadSuccessed: {
            self.titleText = titleLoadSuccessed;
            self.imageView.image = [[UIImage imageNamed:@"success"] redrawingWithTintColor:self.color];
            self.imageView.transform = CGAffineTransformIdentity;
            [self.imageView.layer removeAllAnimations];
            break;
        }
        case LoadStateLoadFailed: {
            self.titleText = titleLoading;
            self.imageView.image = [[UIImage imageNamed:@"fail"] redrawingWithTintColor:self.color];
            self.imageView.transform = CGAffineTransformIdentity;
            [self.imageView.layer removeAllAnimations];
            break;
        }
        case LoadStateLoadAll: {
            self.titleText = titleLoadAll;
            self.imageView.image = [[UIImage imageNamed:@"success"] redrawingWithTintColor:self.color];
            self.imageView.transform = CGAffineTransformIdentity;
            [self.imageView.layer removeAllAnimations];
            break;
        }
        default:
            break;
    }
    [self layoutIfNeeded];
}
@end
