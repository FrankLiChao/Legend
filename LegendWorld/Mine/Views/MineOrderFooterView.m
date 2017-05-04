//
//  MineOrderFooterView.m
//  LegendWorld
//
//  Created by Tsz on 2016/12/16.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "MineOrderFooterView.h"

@interface MineOrderFooterView() <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) UIImageView *line;
@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSArray *imgDataSource;
@end

@implementation MineOrderFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(DeviceMaxWidth/4, 87.5);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsZero;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        self.collectionView = collectionView;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.bounces = NO;
        self.collectionView.scrollsToTop = NO;
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        [self.collectionView registerClass:[MineOrderFooterCollectionViewCell class] forCellWithReuseIdentifier:@"MineOrderFooterCollectionViewCell"];
        [self.contentView addSubview:self.collectionView];
        
        UIImageView *line = [[UIImageView alloc] init];
        self.line = line;
        self.line.backgroundColor = [UIColor seperateColor];
        [self.contentView addSubview:self.line];
        
        self.dataSource = @[@"待付款",@"待收货",@"待评价",@"售后/退款"];
        self.imgDataSource = @[@"待付款",@"待收货",@"待评价",@"售后退款"];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.line.frame = CGRectMake(15, 0, CGRectGetWidth(self.bounds) - 30, 0.5);
    self.collectionView.frame = self.bounds;
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MineOrderFooterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MineOrderFooterCollectionViewCell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:self.imgDataSource[indexPath.row]];
    cell.titleLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderFooterSelectItemAtIndex:)]) {
        [self.delegate orderFooterSelectItemAtIndex:indexPath.row];
    }
}

@end



@implementation MineOrderFooterCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] init];
        self.imageView = imageView;
        self.imageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.imageView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        self.titleLabel = titleLabel;
        self.titleLabel.numberOfLines = 1;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor noteTextColor];
        self.titleLabel.font = [UIFont noteTextFont];
        [self.contentView addSubview:self.titleLabel];
        
        self.selectedBackgroundView = [[UIView alloc] init];
        self.selectedBackgroundView.backgroundColor = [[UIColor noteTextColor] colorWithAlphaComponent:0.5];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize btnSize = {34,34};
    self.imageView.frame = CGRectMake((CGRectGetWidth(self.bounds) - btnSize.width)/2, 15, btnSize.width, btnSize.height);
    self.titleLabel.frame = CGRectMake(CGRectGetMinX(self.imageView.frame) - 15, CGRectGetMaxY(self.imageView.frame) + 10, btnSize.width + 30, 15);
    self.backgroundView.frame = self.bounds;
}

@end


