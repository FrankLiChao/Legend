//
//  SelectGoodsAttrView.m
//  LegendWorld
//
//  Created by Tsz on 2016/11/8.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "SelectGoodsAttrView.h"
#import "GoodsAttrCollectionViewCell.h"

@interface SelectGoodsAttrView() <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end

@implementation SelectGoodsAttrView

- (instancetype)init {
    self = [[[NSBundle mainBundle] loadNibNamed:@"SelectGoodsAttrView" owner:self options:nil] firstObject];
    if (self) {

    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)setup {
    self.frame = CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight);
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    self.contentView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.contentView.bounds) + 35);
    [self.goodsAttrCollectionView registerNib:[UINib nibWithNibName:@"GoodsAttrCollectionViewCell" bundle:nil]
                   forCellWithReuseIdentifier:@"GoodsAttrCollectionViewCell"];
}

- (void)show {
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    [self.goodsAttrCollectionView reloadData];
    [self.goodsAttrCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedAttrIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.contentView.transform = CGAffineTransformIdentity;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        self.contentView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.contentView.bounds) + 35);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)closeBtnClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectGoodsAttrViewDidClickCloseBtn:)]) {
        [self.delegate selectGoodsAttrViewDidClickCloseBtn:self];
    }
    [self dismiss];
}

- (IBAction)plusBtnClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectGoodsAttrViewDidClickPlusBtn:)]) {
        [self.delegate selectGoodsAttrViewDidClickPlusBtn:self];
    }
}

- (IBAction)minusBtnClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectGoodsAttrViewDidClickMinusBtn:)]) {
        [self.delegate selectGoodsAttrViewDidClickMinusBtn:self];
    }
}

- (IBAction)okBtnClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectGoodsAttrViewDidClickOKBtn:)]) {
        [self.delegate selectGoodsAttrViewDidClickOKBtn:self];
    }
    [self dismiss];
}

- (IBAction)backgroundDidTapped:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectGoodsAttrViewDidClickCloseBtn:)]) {
        [self.delegate selectGoodsAttrViewDidClickCloseBtn:self];
    }
    [self dismiss];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.fetchDataBlock().count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray<NSString *> *data = self.fetchDataBlock();
    GoodsAttrCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GoodsAttrCollectionViewCell" forIndexPath:indexPath];
    cell.attrNameLabel.text = data[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectGoodsAttrView:didSelectAttrAtIndex:)]) {
        [self.delegate selectGoodsAttrView:self didSelectAttrAtIndex:indexPath.row];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray<NSString *> *data = self.fetchDataBlock();
    NSString *text = data[indexPath.row];
    CGSize size = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 35) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size;
    return CGSizeMake(size.width + 30, 35);
}
@end
