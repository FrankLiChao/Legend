//
//  MyCollectionGoodsCell.h
//  LegendWorld
//
//  Created by wenrong on 16/11/3.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyCollectionGoodsCellDelegate <NSObject>

- (void)getAward:(NSInteger)num;

@end

@interface MyCollectionGoodsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLab;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLab;
@property (weak, nonatomic) IBOutlet UIButton *awardBtn;
@property (nonatomic, weak) id <MyCollectionGoodsCellDelegate> delegate;
@end
