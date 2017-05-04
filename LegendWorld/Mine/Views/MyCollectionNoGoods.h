//
//  MyCollectionNoGoods.h
//  LegendWorld
//
//  Created by wenrong on 16/11/3.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyCollectionNoGoodsDelegate <NSObject>

- (void)turnToBuy;

@end



@interface MyCollectionNoGoods : UIView
@property (weak, nonatomic) IBOutlet UIImageView *defaultIm;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (nonatomic, weak) id <MyCollectionNoGoodsDelegate> delegate;
@end
