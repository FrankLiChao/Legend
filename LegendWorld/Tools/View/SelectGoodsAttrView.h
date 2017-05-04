//
//  SelectGoodsAttrView.h
//  LegendWorld
//
//  Created by Tsz on 2016/11/8.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SelectGoodsAttrView;
@protocol SelectGoodsAttrViewDelegate <NSObject>

- (void)selectGoodsAttrViewDidClickCloseBtn:(SelectGoodsAttrView *)view;
- (void)selectGoodsAttrViewDidClickMinusBtn:(SelectGoodsAttrView *)view;
- (void)selectGoodsAttrViewDidClickPlusBtn:(SelectGoodsAttrView *)view;
- (void)selectGoodsAttrViewDidClickOKBtn:(SelectGoodsAttrView *)view;
- (void)selectGoodsAttrView:(SelectGoodsAttrView *)view didSelectAttrAtIndex:(NSInteger)index;

@end


typedef NSArray<NSString *> * (^SelectGoodsAttrFetchDataBlock)();

@interface SelectGoodsAttrView : UIView

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImgView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *goodsAttrCollectionView;
@property (weak, nonatomic) IBOutlet UITextField *goodsCountTextField;

@property (nonatomic) NSInteger selectedAttrIndex;
@property (strong, nonatomic) SelectGoodsAttrFetchDataBlock fetchDataBlock;
@property (weak, nonatomic) id delegate;

- (void)show;
- (void)dismiss;

@end
