//
//  ImageBrowserView.h
//  LegendWorld
//
//  Created by Tsz on 2016/11/19.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSArray<NSString *> * (^DataSourceFetcher)();

@class ImageBrowserView;
@protocol ImageBrowserViewDelegate <NSObject>

- (void)imageBrowserView:(ImageBrowserView *)imageBrowserView didScrollToIndex:(NSInteger)index;

@end


@interface ImageBrowserView : UIView

@property (nonatomic) NSInteger currentIndex;// default is 0

@property (nonatomic, strong) DataSourceFetcher fetchDataSource;
@property (nonatomic, weak) id delegate;

- (void)show;
- (void)dismiss;

@end

@class ImageBrowserCollectionViewCell;
@protocol ImageBrowserCollectionViewCellDelegate <NSObject>

- (void)imageBrowserCollectionViewCellDidTapped:(ImageBrowserCollectionViewCell *)cell;

@end


@interface ImageBrowserCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id delegate;

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIImageView *contentImageView;

@end
