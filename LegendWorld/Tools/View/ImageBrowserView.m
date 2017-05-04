//
//  ImageBrowserView.m
//  LegendWorld
//
//  Created by Tsz on 2016/11/19.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "ImageBrowserView.h"

@interface ImageBrowserView() <UICollectionViewDataSource, UICollectionViewDelegate, ImageBrowserCollectionViewCellDelegate>

@property (nonatomic, weak) UICollectionView *collectionView;

@end


static CGFloat seperate = 20;

@implementation ImageBrowserView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = seperate;
        layout.minimumInteritemSpacing = seperate;
        layout.itemSize = CGSizeMake(DeviceMaxWidth, DeviceMaxHeight);
        layout.sectionInset = UIEdgeInsetsMake(0, seperate, 0, seperate);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                              collectionViewLayout:layout];
        self.collectionView = collectionView;
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.pagingEnabled = YES;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.alwaysBounceHorizontal = NO;
        self.collectionView.bounces = YES;
        self.collectionView.scrollsToTop = NO;
        self.collectionView.backgroundColor = [UIColor clearColor];
        [self.collectionView registerClass:[ImageBrowserCollectionViewCell class]
                forCellWithReuseIdentifier:@"ImageBrowserCollectionViewCell"];
        [self addSubview:self.collectionView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;
    
}

#pragma mark - Public API
- (void)show {    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    self.frame = CGRectMake(-seperate, 0, DeviceMaxWidth + 2 * seperate, DeviceMaxHeight);
    [keyWindow addSubview:self];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                        animated:NO];
    
    self.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }];
}

- (void)dismiss {
    self.alpha = 1;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.fetchDataSource) {
        return self.fetchDataSource().count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.fetchDataSource) {
        NSArray *data = self.fetchDataSource();
        ImageBrowserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageBrowserCollectionViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        [cell.contentImageView sd_setImageWithURL:[NSURL URLWithString:data[indexPath.row]]];
        return cell;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self dismiss];
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    self.currentIndex = indexPath.row;
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageBrowserView:didScrollToIndex:)]) {
        [self.delegate imageBrowserView:self didScrollToIndex:indexPath.row];
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageBrowserCollectionViewCell *mycell = (ImageBrowserCollectionViewCell *)cell;
    mycell.scrollView.zoomScale = 1.0;
}

#pragma mark - ImageBrowserCollectionViewCellDelegate
- (void)imageBrowserCollectionViewCellDidTapped:(ImageBrowserCollectionViewCell *)cell {
    [self dismiss];
}

@end


@interface ImageBrowserCollectionViewCell() <UIScrollViewDelegate>

@end


@implementation ImageBrowserCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        self.scrollView = scrollView;
        self.scrollView.delegate = self;
        self.scrollView.maximumZoomScale = 2.0;
        self.scrollView.minimumZoomScale = 1.0;
        [self.contentView addSubview:self.scrollView];
        
        UITapGestureRecognizer *tapScrollView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScrollView:)];
        [self.scrollView addGestureRecognizer:tapScrollView];
        
        UIImageView *contentImageView = [[UIImageView alloc] init];
        self.contentImageView = contentImageView;
        self.contentImageView.backgroundColor = [UIColor clearColor];
        self.contentImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.scrollView addSubview:self.contentImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.frame = self.contentView.bounds;
    self.contentImageView.frame = self.scrollView.bounds;
}

#pragma mark - Custom
- (void)tapScrollView:(UITapGestureRecognizer *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageBrowserCollectionViewCellDidTapped:)]) {
        [self.delegate imageBrowserCollectionViewCellDidTapped:self];
    }
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.contentImageView;
}

@end

