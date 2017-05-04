//
//  RefreshControl.m
//  LegendWorld
//
//  Created by Tsz on 2016/11/4.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "RefreshControl.h"

typedef NS_ENUM(NSInteger, RefreshState) {
    RefreshStateNormal = 0,
    RefreshStateWillRefreshing = 1,
    RefreshStateRefreshing = 2,
    RefreshStateRefreshSuccessed = 3,
    RefreshStateRefreshFailed = 4
};

static NSString *const titleNormal = @"下拉刷新";
static NSString *const titleWillRefreshing = @"释放刷新";
static NSString *const titleRefreshing = @"刷新中...";
static NSString *const titleRefreshSuccessed = @"刷新成功";
static NSString *const titleRefreshFailed = @"刷新失败";

static CGFloat const refreshControlHeight = 50.0;
static CGFloat const animDuration = 0.25;
static CGFloat const refreshPeriod = 1.0;
static CGSize const imageSize = {20, 20};

static NSString *const contentOffsetKeyPath = @"contentOffset";
static NSString *const contentSizeKeyPath = @"contentSize";

@interface RefreshControl()

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic) RefreshState refreshState;

@property (nonatomic) UIEdgeInsets originalInset;
@property (nonatomic) CGPoint previousOffset;
@property (nonatomic, strong) NSString *titleText;

@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *refreshImage;
@property (nonatomic, strong) UIImage *successImage;
@property (nonatomic, strong) UIImage *failImage;

@end

@implementation RefreshControl

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
        
        self.color = [UIColor lightGrayColor];
        
        self.refreshState = RefreshStateNormal;
        self.titleText = titleNormal;
        self.imageView.image = self.normalImage;
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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleOrientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    } else {
        [self.scrollView removeObserver:self forKeyPath:contentOffsetKeyPath];
        [self.scrollView removeObserver:self forKeyPath:contentSizeKeyPath];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    }
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    if (self.superview) {
        self.originalInset = self.scrollView.contentInset;
    } else {
        self.originalInset = UIEdgeInsetsZero;
    }
}

#pragma mark - Event
- (void)beginRefreshing {
    if (self.isRefreshing) {
        return;
    }
    
    self.refreshState = RefreshStateRefreshing;
    
    UIEdgeInsets animInset = self.scrollView.contentInset;
    animInset.top = self.originalInset.top + refreshControlHeight;
    CGPoint animOffset = self.scrollView.contentOffset;
    animOffset.y = -animInset.top;
    
    self.scrollView.contentOffset = self.previousOffset;
    
    [UIView animateWithDuration:animDuration animations:^{
        self.scrollView.contentInset = animInset;
        [self.scrollView setContentOffset:animOffset animated:NO];
    } completion:^(BOOL finished) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }];
}

- (void)endRefreshing:(BOOL)isSuccess {
    if (!self.isRefreshing) {
        return;
    }
    self.refreshState = isSuccess ? RefreshStateRefreshSuccessed : RefreshStateRefreshFailed;
    
    CGFloat timeOffset = isSuccess ? 0.5 : 1.0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeOffset * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIEdgeInsets animInset = self.scrollView.contentInset;
        animInset.top = self.originalInset.top;
        CGPoint animOffset = self.scrollView.contentOffset;
        animOffset.y = animOffset.y + refreshControlHeight;
        
        [UIView animateWithDuration:animDuration animations:^{
            self.scrollView.contentInset = animInset;
            [self.scrollView setContentOffset:animOffset animated:NO];
        } completion:^(BOOL finished) {
            self.refreshState = RefreshStateNormal;
        }];
    });
}

- (void)handleOrientationChanged:(NSNotification *)notification {
    UIEdgeInsets inset = self.scrollView.contentInset;
    self.originalInset = self.isRefreshing ? UIEdgeInsetsMake(inset.top - refreshControlHeight, inset.left, inset.bottom, inset.right) : inset;
}

#pragma mark - Observing
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:contentOffsetKeyPath]) {
        if (self.refreshState == RefreshStateRefreshing || self.refreshState == RefreshStateRefreshSuccessed || self.refreshState == RefreshStateRefreshFailed) {
            return;
        }
        CGFloat offsetY = self.scrollView.contentOffset.y;
        if (self.scrollView.isDragging) {
            if (offsetY < -(self.originalInset.top + refreshControlHeight)) {
                self.refreshState = RefreshStateWillRefreshing;
            } else {
                self.refreshState = RefreshStateNormal;
            }
        } else if (self.scrollView.isDecelerating) {
            if (self.refreshState == RefreshStateWillRefreshing) {
                [self beginRefreshing];
            } else {
                self.refreshState = RefreshStateNormal;
            }
        } else {
            self.refreshState = RefreshStateNormal;
        }
        self.previousOffset = self.scrollView.contentOffset;
    } else if ([keyPath isEqualToString:contentSizeKeyPath]) {
        self.frame = CGRectMake(0, -refreshControlHeight, CGRectGetWidth(self.scrollView.bounds), refreshControlHeight);
        [self layoutIfNeeded];
    }
}

#pragma mark - Setter & Getter
- (BOOL)isRefreshing {
    return self.refreshState == RefreshStateRefreshing;
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
    self.refreshImage = [[UIImage imageNamed:@"refresh"] redrawingWithTintColor:self.color];
    self.successImage = [[UIImage imageNamed:@"success"] redrawingWithTintColor:self.color];
    self.failImage = [[UIImage imageNamed:@"fail"] redrawingWithTintColor:self.color];
    
    switch (self.refreshState) {
        case RefreshStateNormal:
            self.imageView.image = self.normalImage;
            break;
        case RefreshStateWillRefreshing:
            self.imageView.image = self.normalImage;
            break;
        case RefreshStateRefreshing:
            self.imageView.image = self.refreshImage;
            break;
        case RefreshStateRefreshSuccessed:
            self.imageView.image = self.successImage;
            break;
        case RefreshStateRefreshFailed:
            self.imageView.image = self.failImage;
            break;
        default:
            break;
    }
}

- (void)setRefreshState:(RefreshState)refreshState {
    if (self.refreshState == refreshState) {
        return;
    }
    _refreshState = refreshState;
    switch (refreshState) {
        case RefreshStateNormal: {
            self.titleText = titleNormal;
            self.imageView.image = self.normalImage;
            [self.imageView.layer removeAllAnimations];
            [UIView animateWithDuration:animDuration animations:^{
                self.imageView.transform = CGAffineTransformIdentity;
            }];
            break;
        }
        case RefreshStateWillRefreshing: {
            self.titleText = titleWillRefreshing;
            self.imageView.image = self.normalImage;
            [self.imageView.layer removeAllAnimations];
            [UIView animateWithDuration:animDuration animations:^{
                self.imageView.transform = CGAffineTransformMakeRotation(M_PI);
            }];
            break;
        }
        case RefreshStateRefreshing: {
            self.titleText = titleRefreshing;
            self.imageView.image = self.refreshImage;
            self.imageView.transform = CGAffineTransformIdentity;
            [self.imageView.layer removeAllAnimations];
            
            CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            rotation.fromValue = 0;
            rotation.toValue = @(2 * M_PI);
            rotation.duration = refreshPeriod;
            rotation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            rotation.repeatCount = HUGE_VALF;
            [self.imageView.layer addAnimation:rotation forKey:@"RotateAnimation"];
            break;
        }
        case RefreshStateRefreshSuccessed: {
            self.titleText = titleRefreshSuccessed;
            self.imageView.image = self.successImage;
            self.imageView.transform = CGAffineTransformIdentity;
            [self.imageView.layer removeAllAnimations];
            break;
        }
        case RefreshStateRefreshFailed: {
            self.titleText = titleRefreshFailed;
            self.imageView.image = self.failImage;
            self.imageView.transform = CGAffineTransformIdentity;
            [self.imageView.layer removeAllAnimations];
            break;
        }
        default:
            break;
    }
}
@end

