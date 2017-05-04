//
//  MineOrderFooterView.h
//  LegendWorld
//
//  Created by Tsz on 2016/12/16.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineOrderFooterView : UITableViewHeaderFooterView

@property (nonatomic, weak) id delegate;

@end

@protocol MineOrderFooterCollectionViewCellDelegate <NSObject>

- (void)orderFooterSelectItemAtIndex:(NSInteger)index;

@end
@interface MineOrderFooterCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *titleLabel;



@end
